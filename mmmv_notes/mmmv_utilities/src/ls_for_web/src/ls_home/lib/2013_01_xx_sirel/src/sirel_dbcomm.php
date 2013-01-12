<?php
//-------------------------------------------------------------------------
// Copyright (c) 2009, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
// * Neither the name of the Martin Vahi nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
// CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//-------------------------------------------------------------------------
require_once('sirel_db.php');

// The class sirelDBcomm is a wrapper to the sirelDBgate.
// The difference between the sirelDBgate and the sirelDBcomm is
// that the sirelDBgate abstracts away the database engine specific issues,
// but the sirelDBcomm abstracts away the SQL and provides a
// profound simplification to the database interface.
class sirelDBcomm {
	private $db_;

	// The $database_descriptor is expected to be an instance of
	// sirelDatabaseDescriptor
	public function __construct(&$database_descriptor) {
		try {
			$this->db_=sirelDBgate_pool::get_db($database_descriptor);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // constructor

	// The sole purpose of the method get_column_types
	// is to save a few SQL queries.
	private $columns_types_cache_=array();
	public function get_column_types(&$table_name) {
		try {
			$arht_column_type_names;
			if (array_key_exists($table_name, $this->columns_types_cache_)) {
				$arht_column_type_names=$this->columns_types_cache_[$table_name];
			} else {
				$arht_column_type_names=$this->db_->get_column_types($table_name);
				$this->columns_types_cache_[$table_name]=$arht_column_type_names;
			} // else
			return $arht_column_type_names;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': $table_name=='.$table_name);
		} // catch
	} // get_column_types

	// The sole purpose of the method get_column_names
	// is to save a few SQL queries.
	private $columns_names_cache_=array();
	public function get_column_names(&$table_name) {
		try {
			$ar_column_names;
			if (array_key_exists($table_name, $this->columns_names_cache_)) {
				$ar_column_names=$this->columns_names_cache_[$table_name];
			} else {
				$ar_column_names=$this->db_->get_column_names($table_name);
				$this->columns_names_cache_[$table_name]=$ar_column_names;
			} // else
			return $ar_column_names;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': $table_name=='.$table_name);
		} // catch
	} // get_column_names

//-------------------------------------------------------------------------
	// The keys of the $arht_values are meant to be column names of the
	// database table named $table_name. The $arht_values is not required to
	// contain values for all of the columns.
	//
	// If the $b_allow_keys_that_are_not_column_names===true, then
	// the $arht_values is allowed to contain more
	// key-value pairs than there are columns. In that case the
	// extra key-value pairs are ignored.
	//
	// It returns a casted copy of the $arht_values.
	private function cast_values_2_db_column_types(&$table_name,
			&$arht_values,$b_allow_keys_that_are_not_column_names=False) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $table_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_values);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_bool', $b_allow_keys_that_are_not_column_names);
			} // if
			$ar_keys=array_keys($arht_values);
			$ar_column_names=$this->get_column_names($table_name);
			$ar_keys_that_match_with_column_names=NULL;
			if($b_allow_keys_that_are_not_column_names) {
				// The $b_allow_keys_that_are_not_column_names actually
				// exists only for speed, because the set intersection
				// search has a kind of exponential complexity.
				$ar_keys_that_match_with_column_names=sirelLang::set_intersection_ar_of_mbstrings($ar_keys,
						$ar_column_names);
			} else {
				$ar_keys_that_match_with_column_names=&$ar_keys;
			} // else
			$new_value=null;
			$s_column_type='';
			$arht_values_casted=array();
			$arht_column_type_names=$this->get_column_types($table_name);
			foreach ($ar_keys_that_match_with_column_names as $s_column_name) {
				$s_column_type=$arht_column_type_names[$s_column_name];
				$new_value=$this->db_->cast_2_PHP_type(
						$s_column_type, $arht_values[$s_column_name]);
				$arht_values_casted[$s_column_name]=$new_value;
			} // foreach
			return $arht_values_casted;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': $table_name=='.$table_name);
		} // catch
	} // cast_values_2_db_column_types

//-------------------------------------------------------------------------
	// Converts the "SQL SELECT * FROM <database> blabla;" output to
	// an array of hashtables, where the DB table column names are
	// the keys of the hashtables. The keys of the outer hashtable
	// are 0,1,2,3,... Almost all verification has been omitted intentionally,
	// because this method is meant to be reached only after all sorts of
	// verification has been already performed.
	private function rows_2_array_of_hashtables(&$rows, &$table_name) {
		try {
			$column_names=array();
			$rows_length=count($rows);
			$column_names_length=0;
			if (0 < $rows_length) {
				$column_names=$this->get_column_names($table_name);
				$column_names_length=count($column_names);
				if (count($rows[0]) != $column_names_length) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.count($rows[0]) .
							'==$rows[0]) != count($column_names)=='
							. $column_names_length.'  $table_name=='.$table_name);
				} // if
			} // if
			$arht_rows=array();
			$n=0;
			foreach($rows as $a_row) {
				$arht=array();
				$i=0;
				for($i=0;$i < $column_names_length;$i++) {
					$a_compartment=$a_row[$i];
					$arht[$column_names[$i]]=$a_compartment;
				} // for
				$arht_rows[''.$n]=$arht;
				$n++;
			} // foreach
			return $arht_rows;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // rows_2_array_of_hashtables

//-------------------------------------------------------------------------
	private function verify_table_name_for_security(&$table_name) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				$tbn=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
						__LINE__, __CLASS__, __FUNCTION__, $table_name);
				if (!sirelLang::str1EqualsStr2($tbn, $table_name)) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': Trimming had an effect. ' .
							'$tbn=="'.$tbn.'" $table_name=="'.$table_name.'".');
				} // if
			} // if
			$tbn=sirelCodeInjectionFilter::SQL($table_name);
			if (!sirelLang::str1EqualsStr2($tbn, $table_name)) {
				sirelThrowIOException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': SQL injection suspected. ' .
						'$tbn=="'.$tbn.'" $table_name=="'.$table_name.'".');
			} // if
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verify_table_name_for_security

//-------------------------------------------------------------------------
	private function verify_ht_selector_column_names(&$table_name,
			&$arht_selector) {
		try {
			$ar_column_names=$this->get_column_names($table_name);
			$arht_column_names=array();
			foreach ($ar_column_names as $cl_name) {
				$arht_column_names[$cl_name]=42;
			} // foreach
			$arht_difference=sirelLang::set_difference($arht_selector,
					$arht_column_names); //==$arht_selector-$arht_column_names
			if (0 < count($arht_difference)) {
				$s_diff='';
				$s_cl_names='';
				foreach (array_keys($arht_difference) as $key) {
					$s_diff=$s_diff.', '.$key;
				} // foreach
				foreach (array_keys($arht_column_names) as $key) {
					$s_cl_names=$s_cl_names.', '.$key;
				} // foreach
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'The following column names within the '.
						'$arht_selector were not present in table '.
						$table_name.':'.$s_diff." \n".
						'The '.$table_name.' had the columns with the '.
						'following names: '.$s_cl_names);
			} // if
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': $table_name=='.$table_name);
		} // catch
	} // verify_ht_selector_column_names

//-------------------------------------------------------------------------
	// Makes sure that for every column name in the table there's
	// a key that matches with the column name in the $arht_compartments.
	private function verify_completeness_of_the_ht_compartments($table_name,
			$arht_compartments) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $table_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_compartments);
			} // if
			$b_err=False;
			$s_cln=NULL;
			$ar_column_names=$this->get_column_names($table_name);
			foreach ($ar_column_names as $s_column_name) {
				if(array_key_exists($s_column_name, $arht_compartments)==False) {
					$b_err=True;
					$s_cln=$s_column_name;
					break;
				} // if
			} // foreach
			if($b_err) {
				throw new Exception('The table named "'.$table_name.
						'" contains a column named "'.$s_cln.
						'", but the $arht_compartments does not '.
						'contain such a key.');
			} // if
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verify_completeness_of_the_ht_compartments

//-------------------------------------------------------------------------
	private $prepare_params_t1_c_=0;
	// Returns a hashtable, where htt['params'] is the
	// hashtable that gets used in the case of the DB connection and
	// htt['s'] is a string in the form of ' "a='blabla1' <delimiter> b='blabla2",
	// where $arht_selector['a']='blabla1' and $arht_selector['b']='blabla2'.
	// $delimiter={'AND',','}, but it can be whatever the SQL accepts.
	private function prepare_params_t1(&$arht_selector, $delimiter) {
		try {
			$this->prepare_params_t1_c_=$this->prepare_params_t1_c_ + 1;
			if ($this->prepare_params_t1_c_ < 0) { // For the integer overflow.
				// The control flow practically never gets in here,
				// but one doesn't want to spend a week on debugging,
				// if the event does occur. That is to say I'm not
				// that crazy as it first might appear.
				$this->prepare_params_t1_c_=0;
			} // if
			$s_pref_x='x'.$this->prepare_params_t1_c_.'_' .
					mt_rand(0, 1000000000).'_'.mt_rand(0, 1000000000).'_';
			$params=array();
			$keys=array_keys($arht_selector);
			$b=False;
			$s='';
			$i_pref_c=0;
			$s_paramvar_name='';
			foreach($keys as $a_key) {
				$s_paramvar_name=$s_pref_x.$i_pref_c.'_'.$a_key;
				$i_pref_c=$i_pref_c + 1;
				$x=sirelCodeInjectionFilter::SQL($a_key);
				if (!sirelLang::str1EqualsStr2($x, $a_key)) {
					sirelThrowIOException(__FILE__, __LINE__, __CLASS__ .
							'->'.__FUNCTION__.' SQL injection suspected. ' .
							'$a_key=="'.$a_key.'" $x=="'.$x.'".');
				} // if
				if ($b) {
					$s=$s.' '.$delimiter.' ';
				} else {
					$b=True;
					$s=$s.' ';
				} // else
				$s=$s.$a_key.'= :'.$s_paramvar_name;
				$params[':'.$s_paramvar_name]=$arht_selector[$a_key];
			} // foreach
			$arhtt=array();
			$arhtt['params']=$params;
			$arhtt['s']=$s;
			return $arhtt;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // prepare_params_t1

//-------------------------------------------------------------------------
	public function ar_fix_raw_SQL_selection_output_rows(&$s_table_name,
			&$rows_buggy) {
		try {
			$rows=array();
			$n=count($this->get_column_names($s_table_name));
			$n_rb=count($rows_buggy[0]);
			if (($n_rb != (2 * $n)) && (0 < $n_rb)) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': Amazing. The PHP ' .
						'interpreter is just amazingly buggy. now the ' .
						'count($rows_buggy[0])=='.count($rows_buggy) .
						' $stm=='.$stm);
			} // if
			foreach($rows_buggy as $row_buggy) {
				$a_row=array();
				for($i=0;$i < $n;$i++) {
					// For some reason, one can not use a
					// reference on the next line.
					$a_row[]=$row_buggy[$i];
				} // for
				$rows[]=$a_row; // Can't use a reference here.
			} // foreach
			return $rows;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_fix_raw_SQL_selection_output_rows
//-------------------------------------------------------------------------
	private function ar_SQL_selectfunc_common(&$table_name,
			&$arht_selector,&$SQL_suffix,&$s_mode) {
		try {
			$s_star='*';
			switch ($s_mode) {
				case 'plain_select':
				// do nothing
					break;
				case 'count':
					$s_star='count(*)';
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__ .
							': There\'s no branch for ' .
							'$s_mode=='.$s_mode.'.');
					break;
			} // switch
			$this->verify_table_name_for_security($table_name);
			$sql_suffix_trimmed=sirelLang::mb_trim($SQL_suffix);
			$i_sql_suffix_trimmed_length=mb_strlen($sql_suffix_trimmed);
			$stm='SELECT '.$s_star.' FROM '.$table_name.' WHERE 42=42 ';
			if (0 < count($arht_selector)) {
				$stm=$stm.' AND ';
				$arht_selector_casted=$this->cast_values_2_db_column_types(
						$table_name, $arht_selector);
				$arhtt=$this->prepare_params_t1($arht_selector_casted, 'AND');
			} else {
				$arhtt=array();
				$arhtt['params']=array();
				$arhtt['s']=''; // It has a generated value in the other branch.
			} // else
			// The next line is a non-plumbable security hole.
			$stm=$stm.$arhtt['s'].' '.$sql_suffix_trimmed.' ;';
			// Due to some bug in the PHP implementation, all of the
			// columns are reported twice like
			// column_1 column_2 column_3 column_1 column_2 column_3.
			$rows_buggy=$this->db_->exec_transaction($stm, $arhtt['params']);
			$rows=array();
			if($s_mode=='plain_select') {
				$rows=$this->ar_fix_raw_SQL_selection_output_rows($table_name,
						$rows_buggy);
				// The original implementation:
				// $n=count($this->get_column_names($table_name));
				// $n_rb=count($rows_buggy[0]);
				// if (($n_rb != (2 * $n)) && (0 < $n_rb)) {
				// sirelThrowLogicException(__FILE__, __LINE__,
				// __CLASS__.'->'.__FUNCTION__.': Amazing. The PHP ' .
				// 'interpreter is just amazingly buggy. now the ' .
				// 'count($rows_buggy[0])=='.count($rows_buggy) .
				// ' $stm=='.$stm);
				// } // if
				// foreach($rows_buggy as $row_buggy) {
				// $a_row=array();
				// for($i=0;$i < $n;$i++) {
				// // For some reason, one can not use a
				// // reference on the next line.
				// $a_row[]=$row_buggy[$i];
				// } // for
				// $rows[]=$a_row; // Can't use a reference here.
				// } // foreach
			} elseif ($s_mode=='count') {
				$rows=&$rows_buggy;
			} else {
				throw new Exception(
				__CLASS__.'->'.__FUNCTION__ .
						': There\'s no branch for ' .
						'$s_mode=='.$s_mode.'.');
			} // else
			return $rows;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_SQL_selectfunc_common

//-------------------------------------------------------------------------
	// Explanation by example:
	//  if $table_name='xx', $arht_selector['a']=='nice',
	// $arht_selector['b']=='man', $SQL_suffix==" and name like 'B%'",
	//  then the resultant SQL sentence will be:
	// "SELECT * FROM xx WHERE a='nice' AND b='man' and name like 'B%' ;
	// // It returns an array of hashtables, where there is one hashtable
	// per row and the column names are the hashtable keys.
	public function ar_SQL_select($table_name, &$arht_selector, $SQL_suffix) {
		try {
			$s_mode='plain_select';
			$rows=$this->ar_SQL_selectfunc_common($table_name,
					$arht_selector,$SQL_suffix,$s_mode);
			$arht_rows=$this->rows_2_array_of_hashtables($rows, $table_name);
			return $arht_rows;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_SQL_select

	// The i_SQL_rowcount is like the ar_SQL_select, except that
	// in stead of an array of hashtables that depict rows, the
	// i_SQL_rowcount returns an integer that depicts the number
	// of the rows that the ar_SQL_select would return.
	//
	// The main motivation for using
	//         $i_rows=i_SQL_rowcount(...);
	// in stead of the
	//         $i_rows=count(ar_SQL_rowcount(...));
	// is that the i_SQL_rowcount saves considerable amount of
	// traffic between the database engine and the PHP virtual
	// machine and at the PHP side it also saves memory.
	//
	// For example, there's a difference between getting the number 9000000
	// as an answer of the i_SQL_rowcount and transferring
	// all of those 9000000 rows from the database to the PHP, allocating
	// memory for all of those 9000000 rows and then counting them.
	public function i_SQL_rowcount($table_name, &$arht_selector, $SQL_suffix) {
		try {
			$s_mode='count';
			$rows=$this->ar_SQL_selectfunc_common($table_name,
					$arht_selector,$SQL_suffix,$s_mode);
			$i_rowcount=0;
			if(0<count($rows)) {
				if(sirelSiteConfig::$debug_PHP) {
					if(count($rows)!=1) {
						sirelThrowLogicException(__FILE__, __LINE__,
								__CLASS__.'->'.__FUNCTION__.': '.
								'Something is wrong. count($rows)=='.
								count($rows).' != 1');
					} // if
				} // if
				// The type casting is for making sure that this method
				// returns an integer regardless of the database engine
				// type/brand. The [0][0] part means:
				// the first column of the first row.
				$i_rowcount=(int)(''.$rows[0][0]);
			} // if
			return $i_rowcount;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_SQL_rowcount

//-------------------------------------------------------------------------
	// It creates a copy of a hashtable so that the copy
	// does not contain any keys that are not column names
	// of the given table.
	private function trim_arht_by_table(&$arht,&$table_name) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $table_name);
			} // if
			$ar_column_names=$this->get_column_names($table_name);
			$arht_out=array();
			$ar_keys=array_keys($arht);
			foreach ($ar_column_names as $s_column_name) {
				if (array_key_exists($s_column_name,$arht)) {
					$arht_out[$s_column_name]=$arht[$s_column_name];
				} // if
			} // foreach
			return $arht_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // trim_arht_by_table

//-------------------------------------------------------------------------
	// Adds a new row. The $arht_compartments is required to contain
	// a value for every column.
	//
	// If the $b_allow_keys_that_are_not_column_names===true, then
	// the $arht_compartments is allowed to contain more
	// key-value pairs than there are columns. In that case the
	// extra key-value pairs are ignored.
	//
	// This method doesn't return anything.
	public function add_table_row($table_name, &$arht_compartments,
			$b_allow_keys_that_are_not_column_names=False,$b_dbg=False) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $table_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_compartments);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_bool',
						$b_allow_keys_that_are_not_column_names);
			} // if
			$this->verify_table_name_for_security($table_name);
			$arht_normalized_compartments=NULL;
			if($b_allow_keys_that_are_not_column_names) {
				$arht_normalized_compartments=$this->trim_arht_by_table($arht_compartments,
						$table_name);
			}else {
				$arht_normalized_compartments=$arht_compartments;
			} // else
			$arht_chf_casted=$this->cast_values_2_db_column_types($table_name,
					$arht_normalized_compartments,
					$b_allow_keys_that_are_not_column_names);
			$stm='INSERT INTO '.$table_name.' ( ';
			$s_params='';
			$params=array();
			$s_p;
			$column_names=$this->get_column_names($table_name);
			$b=False;
			foreach($column_names as $a_column_name) {
				if (!array_key_exists($a_column_name, $arht_chf_casted)) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': The database table ' .
							'has a column named "'.$a_column_name.'", but ' .
							'the hashtable of writable values does not contain ' .
							'such a key. ');
				} // if
				if ($b) {
					$stm=$stm.',';
					$s_params=$s_params.',';
				} else {
					$b=True;
				} // else
				$s_p=':'.$a_column_name;
				$stm=$stm.$a_column_name;
				$s_params=$s_params.$s_p;
				$params[$s_p]=$arht_chf_casted[$a_column_name];
			} // foreach
			$stm=$stm.') values ('.$s_params.');';
			$rows=$this->db_->exec_transaction($stm, $params);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // add_table_row

//-------------------------------------------------------------------------
	// $arht_selector['x']=='y' and $arht_selector['z']='w'
	// is interpreted as ... WHERE x='y' AND z='w'
	public function delete_selection_of_rows($table_name, &$arht_selector,
			$SQL_suffix) {
		try {
			$this->verify_table_name_for_security($table_name);
			$stm='DELETE FROM '.$table_name.' WHERE 42=42 ';
			if (0 < count($arht_selector)) {
				$stm=$stm.' AND ';
				$arht_selector_casted=$this->cast_values_2_db_column_types(
						$table_name, $arht_selector);
				$arhtt=$this->prepare_params_t1($arht_selector_casted, 'AND');
			} else {
				$arhtt=array();
				$arhtt['params']=array();
				$arhtt['s']='';
			} // else
			$stm=$stm.$arhtt['s'].' '.$SQL_suffix.' ;';
			$rows=$this->db_->exec_transaction($stm, $arhtt['params']);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // delete_selection_of_rows

//-------------------------------------------------------------------------
	// $arht_selector['x']=='y' and $arht_selector['z']='w'
	// is interpreted as "... WHERE x='y' AND z='w'"
	// The $arht_changeable_fields has field names as
	// keys and values as values.
	//
	// If the $b_allow_keys_that_are_not_column_names===true, then
	// the $arht_changeable_fields is allowed to contain more
	// key-value pairs than there are columns. In that case the
	// extra key-value pairs are ignored.
	//
	// It's OK for the $arht_changeable_fields to contain less
	// columns than there are in the <$table_name>, regardless
	// of the value of the $b_allow_keys_that_are_not_column_names.
	public function change_selection_of_rows($table_name,
			&$arht_changeable_fields, &$arht_selector, $SQL_suffix,
			$b_allow_keys_that_are_not_column_names=False) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $table_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_changeable_fields);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_selector);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $SQL_suffix);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_bool', $b_allow_keys_that_are_not_column_names);
				$this->verify_table_name_for_security($table_name);
				$this->verify_ht_selector_column_names($table_name,
						$arht_selector);
			} // if
			if (count($arht_changeable_fields) == 0) {
				return;
			} // if
			$arht_normalized_compartments=NULL;
			if($b_allow_keys_that_are_not_column_names) {
				$arht_normalized_compartments=$this->trim_arht_by_table($arht_changeable_fields,
						$table_name);
			}else {
				$arht_normalized_compartments=$arht_changeable_fields;
			} // else
			$arht_chf_casted=$this->cast_values_2_db_column_types($table_name,
					$arht_normalized_compartments,
					$b_allow_keys_that_are_not_column_names);
			$arhtt_chf=$this->prepare_params_t1($arht_chf_casted, ',');
			$stm='UPDATE '.$table_name.' SET ';
			$stm=$stm.$arhtt_chf['s'].' WHERE 42=42 ';
			$arhtt_sel=NULL;
			if (0 < count($arht_selector)) {
				$stm=$stm.' AND ';
				$arht_selector_casted=$this->cast_values_2_db_column_types(
						$table_name, $arht_selector);
				$arhtt_sel=$this->prepare_params_t1($arht_selector_casted,
						'AND');
			} else {
				$arhtt_sel=array();
				$arhtt_sel['params']=array();
				$arhtt_sel['s']='';
			} // else
			$stm=$stm.$arhtt_sel['s'].' '.$SQL_suffix.' ;';
			$params=array_merge($arhtt_chf['params'], $arhtt_sel['params']);
			$rows=$this->db_->exec_transaction($stm, $params);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // change_selection_of_rows

//-------------------------------------------------------------------------

//-------------------------------------------------------------------------

	// The $arht_q is a hashtable which's format conforms to
	// the raudrohi.dbcomm.dbq1.create_empty_ht
	// It returns an instance of sirelOP, where the query
	// result is at the value field.
	//
	// This method is deprecated.
	public function exec_query(&$arht_q) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_q);
			} // if
			$table_name=$arht_q['table_name'];
			$arht_selector=$arht_q['ht_selector'];
			$sql_suffix=$arht_q['SQL_suffix'];
			$command=$arht_q['command'];
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $table_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_array', $arht_selector);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $sql_suffix);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $command);
			} // if
			$op=new sirelOP();
			$arht_rows;
			try {
				switch ($command) {
					case 'select':
						$arht_rows=$this->ar_SQL_select($table_name,
								$arht_selector, $sql_suffix);
						break;
					default:
						throw new Exception(
						__CLASS__.'->'.__FUNCTION__ .
								': There\'s no branch for ' .
								'$command=='.$command.'.');
						break;
				} // switch
				$op->sb_failure='f';
				$op->value=$arht_rows;
			}
			catch (Exception $err0) {
				if(sirelSiteConfig::$debug_PHP) {
					sirelBubble(__FILE__, __LINE__, $err0,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The SQL must have failed. $table_name=='.$table_name.
							'   $sql_suffix=='.$sql_suffix);
				} // if
			} // catch
			return $op;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // exec_query

} // class sirelDBcomm

// ------------------------------------------------------------------------
// The reason, why there's a separate pool, the sirelDBcomm_pool,
// in stead of a singleton implementation like sirelDBcomm::get_instance()
// is that the pool version allows multiple, database specific,
// sirelDBcomm singleton instances at once.
class sirelDBcomm_pool {
	private static $dbs_=array();

	// The $database_descriptor is expected to be an instance of
	// sirelDatabaseDescriptor
	public static function get_dbc(&$database_descriptor) {
		try {
			$hash_string=''.$database_descriptor->hostname_.'|||99999992' .
					$database_descriptor->port_.'|||;' .
					$database_descriptor->username_.';|||;' .
					$database_descriptor->db_name_;
			if (array_key_exists($hash_string, sirelDBcomm_pool::$dbs_)) {
				return sirelDBcomm_pool::$dbs_[$hash_string];
			} else {
				$dbc=new sirelDBcomm($database_descriptor);
				sirelDBcomm_pool::$dbs_[$hash_string]=$dbc;
				return $dbc;
			} // else
		}
		catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // get_dbc
} // class sirelDBcomm_pool


class sirelDBcomm_ops { // "ops" stands for "operations".

	// The hashtable content format is closely related to
	// the raudrohi.dbcomm.dbq1. The output is used in the
	// sirelDBcomm->exec_query(...)
	public static function deserialize_query_hashtable(&$arht_q_sprogfte) {
		try {
			$arht_q=sirelLang::ProgFTE2ht($arht_q_sprogfte);
			$arht_selector=sirelLang::ProgFTE2ht($arht_q['ht_selector']);
			$arht_q['ht_selector']=$arht_selector;
			return $arht_q;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // get_dbc
} // class sirelDBcomm_ops


// ---------------------------------------------------------
?>
