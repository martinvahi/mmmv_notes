<?php
// ------------------------------------------------------------------------
// Copyright (c) 2011, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// All rights reserved.

// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:

// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
// * Neither the name of the Martin Vahi nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.

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
// ------------------------------------------------------------------------
require_once('sirel_dbcomm.php');

// The class sirelDBhashtable implements a persistent
// hashtable that is able to store floating point values,
// strings, integers character based booleans.
//
// If the web application uses only a few database based
// hashtables, one might want to use a wrapper of the
// sirelDBhashtable, class sirelDBht1, instead.
class sirelDBhashtable {
	private $db_;
	private $dbc_;
	private $s_table_name_;

	private $s_value_field_name_prefix_='xval';
	private $s_defval_i_='42';
	private $s_defval_s_='';
	private $s_defval_fd_=1.0;
	private $s_defval_sb_='f';

	private function verify_table_structure() {
		try {
			$s_table_name=$this->s_table_name_;
			$ar_column_names=$this->dbc_->get_column_names($s_table_name);
			if (count($ar_column_names)!=6) {
				throw(new Exception('A db table that is used as a '.
						'hashtable, is specified to have exactly 6 columns. '.
						'count($ar_column_names)=='.
						count($ar_column_names).'.'));
			} // if
			$s=$ar_column_names[0];
			if ($s!='s_key') {
				throw(new Exception('$ar_column_names[0]=='.$s));
			} // if
			$s=$ar_column_names[1];
			if ($s!='s_value_type') {
				throw(new Exception('$ar_column_names[1]=='.$s));
			} // if
			$s=$ar_column_names[2];
			if ($s!=$this->s_value_field_name_prefix_.'_i') {
				throw(new Exception('$ar_column_names[2]=='.$s));
			} // if
			$s=$ar_column_names[3];
			if ($s!=$this->s_value_field_name_prefix_.'_s') {
				throw(new Exception('$ar_column_names[3]=='.$s));
			} // if
			$s=$ar_column_names[4];
			if ($s!=$this->s_value_field_name_prefix_.'_fd') {
				throw(new Exception('$ar_column_names[4]=='.$s));
			} // if
			$s=$ar_column_names[5];
			if ($s!=$this->s_value_field_name_prefix_.'_sb') {
				throw(new Exception('$ar_column_names[5]=='.$s));
			} // if

			$ar_column_types=$this->dbc_->get_column_types($s_table_name);
			$s=$ar_column_types[$ar_column_names[0]];
			if (!sirelLang::str1EqualsStr2($s,'scty_txt')) {
				throw(new Exception('$ar_column_types['.$ar_column_names[0].']=='.$s));
			} // if
			$s=$ar_column_types[$ar_column_names[1]];
			if (!sirelLang::str1EqualsStr2($s,'scty_txt')) {
				throw(new Exception('$ar_column_types['.$ar_column_names[1].']=='.$s));
			} // if
			$s=$ar_column_types[$ar_column_names[2]];
			if (!sirelLang::str1EqualsStr2($s,'scty_int')) {
				throw(new Exception('$ar_column_types['.$ar_column_names[2].']=='.$s));
			} // if
			$s=$ar_column_types[$ar_column_names[3]];
			if (!sirelLang::str1EqualsStr2($s,'scty_txt')) {
				throw(new Exception('$ar_column_types['.$ar_column_names[3].']=='.$s));
			} // if
			$s=$ar_column_types[$ar_column_names[4]];
			if (!sirelLang::str1EqualsStr2($s,'scty_double')) {
				throw(new Exception('$ar_column_types['.$ar_column_names[4].']=='.$s));
			} // if
			$s=$ar_column_types[$ar_column_names[5]];
			if (!sirelLang::str1EqualsStr2($s,'scty_bool')) {
				throw(new Exception('$ar_column_types['.$ar_column_names[5].']=='.$s));
			} // if

		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verify_table_structure


	// The $database_descriptor is expected to be an instance of
	// sirelDatabaseDescriptor
	public function __construct($s_table_name, &$database_descriptor) {
		try {
			$this->db_=sirelDBgate_pool::get_db($database_descriptor);
			$this->dbc_=sirelDBcomm_pool::get_dbc($database_descriptor);
			$this->s_table_name_=$s_table_name;
			$this->db_->ensure_table_existence($this->s_table_name_,
					's_key scty_txt, '.
					's_value_type scty_txt, '.
					$this->s_value_field_name_prefix_.'_i scty_int, '.
					$this->s_value_field_name_prefix_.'_s scty_txt, '.
					$this->s_value_field_name_prefix_.'_fd scty_double, '.
					$this->s_value_field_name_prefix_.'_sb scty_bool '.
					'');
			if (sirelSiteConfig::$debug_PHP) {
				$this->verify_table_structure();
			} // if
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // constructor

	private function get_value_from_row(&$ar_row) {
		try {
			$s_normalized_type=$ar_row['s_value_type'];
			$s_column_name=$this->s_value_field_name_prefix_.'_s';
			switch ($s_normalized_type) {
				case 'scty_txt': // It's the most frequent case.
					break;
				case 'scty_int':
					$s_column_name=$this->s_value_field_name_prefix_.'_i';
					break;
				case 'scty_double':
					$s_column_name=$this->s_value_field_name_prefix_.'_fd';
					break;
				case 'scty_bool':
					$s_column_name=$this->s_value_field_name_prefix_.'_sb';
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_normalized_type=='.$s_normalized_type.'.');
					break;
			} // switch
			$x_out=$ar_row[$s_column_name];
			return $x_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_value_from_row

	// Returns NULL, if the key does not exist.
	// Otherwise it always returns the corresponding value
	// and the type of the value depends on type declaraion of this
	// db-hashtable.
	public function get($s_key) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				// It's possible that some other code deletes the
				// table after the constructor of this instance ran.
				if (!($this->db_->table_exists($this->s_table_name_))) {
					throw(new Exception('The db table of a persistent '.
							'hashtable has been deleted prior to its '.
							'end of use.'));
				} // if
			} // if
			$x_out=NULL;
			$arht_selector=array();
			$arht_selector['s_key']=&$s_key;
			$ar_rows=$this->dbc_->ar_SQL_select($this->s_table_name_,
					$arht_selector,'');
			$i=count($ar_rows);
			if ($i==1) {
				$ar_row=$ar_rows[0];
				$x_out=$this->get_value_from_row($ar_row);
				return $x_out;
			} // if
			if ($i==0) {
				return $x_out;
			} // if
			sirelBubble(_FILE__,__LINE__,'A database table that is '.
					'expected to be a presistent hashtable, has '.
					'a key stored in it more than once. i=='.i,
					__CLASS__.'->'.__FUNCTION__.': ');
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get

	// Returns a boolean value.
	public function has_key($s_key) {
		try {
			$x=$this->get($s_key);
			$b_out=True;
			if (is_null($x)) {
				$b_out=False;
			} // if
			return $b_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // has_key

	private function create_row(&$s_key,&$x_value) {
		try {
			$ar_out=array();
			$ar_out['s_key']=$s_key;
			$s_value_type=&$this->db_->var_2_normalized_data_type($x_value);
			$ar_out['s_value_type']=&$s_value_type;
			$ar_out[$this->s_value_field_name_prefix_.'_i']=&$this->s_defval_i_;
			$ar_out[$this->s_value_field_name_prefix_.'_s']=&$this->s_defval_s_;
			$ar_out[$this->s_value_field_name_prefix_.'_fd']=&$this->s_defval_fd_;
			$ar_out[$this->s_value_field_name_prefix_.'_sb']=&$this->s_defval_sb_;
			switch ($s_value_type) {
				case 'scty_int':
					$ar_out[$this->s_value_field_name_prefix_.'_i']=$x_value;
					break;
				case 'scty_txt':
					$ar_out[$this->s_value_field_name_prefix_.'_s']=$x_value;
					break;
				case 'scty_double':
					$ar_out[$this->s_value_field_name_prefix_.'_fd']=$x_value;
					break;
				case 'scty_bool':
					$ar_out[$this->s_value_field_name_prefix_.'_sb']=$x_value;
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_value_type=='.$s_value_type.'.');
					break;
			} // switch
			return $ar_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_row

	public function put($s_key,$x_value) {
		try {
			$ar_row=&$this->create_row($s_key,$x_value);
			$b_overwrite=$this->has_key($s_key);
			if ($b_overwrite) {
				$arht_changeable_fields=&$ar_row;
				$arht_selector=array();
				$arht_selector['s_key']=$s_key;
				$this->dbc_->change_selection_of_rows($this->s_table_name_,
						$arht_changeable_fields, $arht_selector,'');
			} else {
				$arht_compartments=&$ar_row;
				$this->dbc_->add_table_row($this->s_table_name_,
						$arht_compartments);
			} // else
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // put

} // class sirelDBhashtable

// ---------------------------------------------------------
class sirelDBhashtable_pool {
	private static $dbhts_=array();

	// The $database_descriptor is expected to be an instance of
	// sirelDatabaseDescriptor
	public static function get_element($s_table_name,&$database_descriptor) {
		try {
			$s_hash=''.$database_descriptor->hostname_.'|||99939992'.
					$database_descriptor->port_.'|||;'.
					$database_descriptor->username_.';|||;'.
					$database_descriptor->db_name_.';|||;'.$s_table_name;
			$dbht=NULL;
			if (array_key_exists($s_hash, sirelDBhashtable_pool::$dbhts_)) {
				$dbht=sirelDBhashtable_pool::$dbhts_[$s_hash];
			} else {
				$dbht=new sirelDBhashtable($s_table_name,$database_descriptor);
				sirelDBhashtable_pool::$dbhts_[$s_hash]=$dbht;
			} // else
			return $dbht;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__, __LINE__, $err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // get_element

} // class sirelDBhashtable_pool

// ---------------------------------------------------------

?>
