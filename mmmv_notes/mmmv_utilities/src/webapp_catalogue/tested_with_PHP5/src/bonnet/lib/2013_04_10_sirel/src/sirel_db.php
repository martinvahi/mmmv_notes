<?php
//------------------------------------------------------------------------
// Copyright (c) 2009, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer
//   in the documentation and/or other materials provided with the
//   distribution.
// * Neither the name of the Martin Vahi nor the names of its
//   contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.
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
//------------------------------------------------------------------------

require_once('sirel_lang.php');

// The class sirelDBgate is a just another wrapper or layer that
// abstracts away database engine specific issues. The motive is to
// allow the writing of a web application in a database engine
// independent manner and a little bit to make an effort to modify
// the database access API to fit to one's own personal taste. :-)
//
// A few keywords: SQL injection attack, parameterized SQL query,
// sequence, transaction.
class sirelDBgate {
	protected  $pdodc_;
	private $pdodc_connected_=False;

// If skip_existence_checks_==False, the existence of
// some of the database objects gets checked before
// an attempt to access them is made. If the
// skip_existence_checks_==False and the database objects
// are found to be missing, then in some of the cases the
// database objects are created automatically.
	private $skip_existence_checks_=False;

	private $schema_;

	private $convert_to_UTF8_=True;
	protected $db_descriptor_;

// The value of the $generate_ID_tablename_ must be all lowercase,
// because not all databases properly support CamelCase table names.
	private $generate_ID_tablename_='sirel_lib_bonnet_id_generation';

	private static $msg_not_connected_='The database has not been connected
		yet. The function for establishing the connection is
		sirelDBgate.connect(...)';
//-------------------------------------------------------------

	private static $arht_data_types_PostgreSQL_native2normalized_=null;
	private static $arht_data_types_PostgreSQL_normalized2native_=null;
	private static $arht_data_types_PostgreSQL_inited_=False;

	private static $arht_data_types_MySQL_native2normalized_=null;
	private static $arht_data_types_MySQL_normalized2native_=null;
	private static $arht_data_types_MySQL_inited_=False;

	private static $arht_data_types_SQLite3_native2normalized_=null;
	private static $arht_data_types_SQLite3_normalized2native_=null;
	private static $arht_data_types_SQLite3_inited_=False;

	private static function init_ht_data_types_PostgreSQL() {
		try {
			if(!sirelDBgate::$arht_data_types_PostgreSQL_inited_) {
				sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_=array();
				sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_['character varying']='scty_varchar';
				sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_['integer']='scty_int';
				sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_['text']='scty_txt';
				sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_['double precision']='scty_double';
				sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_['character']='scty_bool';

				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_=array();
				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_['scty_varchar']='character varying';
				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_['scty_varchar[(]']='varchar(';
				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_['scty_int']='integer';
				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_['scty_txt']='text';
				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_['scty_double']='double precision';
				sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_['scty_bool']='character(1)';

				sirelDBgate::$arht_data_types_PostgreSQL_inited_=True;
			} // if
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // init_ht_data_types_PostgreSQL

	private static function init_ht_data_types_MySQL() {
		try {
			if(!sirelDBgate::$arht_data_types_MySQL_inited_) {
				sirelDBgate::$arht_data_types_MySQL_native2normalized_=array();
				sirelDBgate::$arht_data_types_MySQL_native2normalized_['varchar']='scty_varchar';
				sirelDBgate::$arht_data_types_MySQL_native2normalized_['int']='scty_int';
				sirelDBgate::$arht_data_types_MySQL_native2normalized_['text']='scty_txt';
				sirelDBgate::$arht_data_types_MySQL_native2normalized_['double']='scty_double';
				sirelDBgate::$arht_data_types_MySQL_native2normalized_['char']='scty_bool';

				sirelDBgate::$arht_data_types_MySQL_normalized2native_=array();
				sirelDBgate::$arht_data_types_MySQL_normalized2native_['scty_varchar']='varchar';
				sirelDBgate::$arht_data_types_MySQL_normalized2native_['scty_varchar[(]']='varchar(';
				sirelDBgate::$arht_data_types_MySQL_normalized2native_['scty_int']='int';
				sirelDBgate::$arht_data_types_MySQL_normalized2native_['scty_txt']='text';
				sirelDBgate::$arht_data_types_MySQL_normalized2native_['scty_double']='double';
				sirelDBgate::$arht_data_types_MySQL_normalized2native_['scty_bool']='char(1)';

				sirelDBgate::$arht_data_types_MySQL_inited_=True;
			} // if
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // init_ht_data_types_MySQL

	private static function init_ht_data_types_SQLite3() {
		try {
			if(!sirelDBgate::$arht_data_types_SQLite3_inited_) {
				sirelDBgate::$arht_data_types_SQLite3_native2normalized_=array();
				//sirelDBgate::$arht_data_types_SQLite3_native2normalized_['varchar']='scty_varchar';
				sirelDBgate::$arht_data_types_SQLite3_native2normalized_['integer']='scty_int';
				sirelDBgate::$arht_data_types_SQLite3_native2normalized_['text']='scty_txt';
				sirelDBgate::$arht_data_types_SQLite3_native2normalized_['real']='scty_double';
				//sirelDBgate::$arht_data_types_SQLite3_native2normalized_['character(1)']='scty_bool';

				sirelDBgate::$arht_data_types_SQLite3_normalized2native_=array();
				sirelDBgate::$arht_data_types_SQLite3_normalized2native_['scty_varchar']='text';
				sirelDBgate::$arht_data_types_SQLite3_normalized2native_['scty_varchar[(]']='varchar(';
				sirelDBgate::$arht_data_types_SQLite3_normalized2native_['scty_int']='integer';
				sirelDBgate::$arht_data_types_SQLite3_normalized2native_['scty_txt']='text';
				sirelDBgate::$arht_data_types_SQLite3_normalized2native_['scty_double']='real';
				sirelDBgate::$arht_data_types_SQLite3_normalized2native_['scty_bool']='text';

				sirelDBgate::$arht_data_types_SQLite3_inited_=True;
			} // if
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // init_ht_data_types_SQLite3


	private function get_ht_data_types_norm2native() {
		try {
			if(!$this->pdodc_connected_) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'In order to convert between database native data '.
						'types and normalized data types, the type of '.
						'database has to be known. The database type '.
						'is received by the method connect(...).');
			} // if
			$arht_data_types_normalized2native;
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					sirelDBgate::init_ht_data_types_PostgreSQL();
					$arht_data_types_normalized2native=sirelDBgate::$arht_data_types_PostgreSQL_normalized2native_;
					break;
				case 'mysql':
					sirelDBgate::init_ht_data_types_MySQL();
					$arht_data_types_normalized2native=sirelDBgate::$arht_data_types_MySQL_normalized2native_;
					break;
				case 'sqlite3':
					sirelDBgate::init_ht_data_types_SQLite3();
					$arht_data_types_normalized2native=sirelDBgate::$arht_data_types_SQLite3_normalized2native_;
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.':: database type '.
							$this->db_descriptor_->db_type_.' '.
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...)
						and the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
			return $arht_data_types_normalized2native;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_ht_data_types_norm2native

	private function get_ht_data_types_native2norm() {
		try {
			if(!$this->pdodc_connected_) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'In order to convert between database native data '.
						'types and normalized data types, the type of '.
						'database has to be known. The database type '.
						'is received by the method connect(...).');
			} // if
			$arht_data_types_native2normalized;
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					sirelDBgate::init_ht_data_types_PostgreSQL();
					$arht_data_types_native2normalized=sirelDBgate::$arht_data_types_PostgreSQL_native2normalized_;
					break;
				case 'mysql':
					sirelDBgate::init_ht_data_types_MySQL();
					$arht_data_types_native2normalized=sirelDBgate::$arht_data_types_MySQL_native2normalized_;
					break;
				case 'sqlite3':
					sirelDBgate::init_ht_data_types_SQLite3();
					$arht_data_types_native2normalized=sirelDBgate::$arht_data_types_SQLite3_native2normalized_;
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.':: database type '.
							$this->db_descriptor_->db_type_.' '.
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...)
						and the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
			return $arht_data_types_native2normalized;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_ht_data_types_native2norm

	// Returns a string, where the normalized data type names are
	// replaced with database specific data type names.
	public function convert_normalized_db_data_types_2_native($a_string) {
		$ereg;
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$a_string);
				if(!$this->pdodc_connected_) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'In order to convert between database native data '.
							'types and normalized data types, the type of '.
							'database has to be known. The database type '.
							'is received by the method connect(...).');
				} // if
				// regex test string: " scty_varchar  (  scty_varchar( "
				$regex="scty_varchar[\\s]+[(]";
				$s_out=$a_string;
				if(mb_ereg_match($regex, $s_out)) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'Actually, it\'s not a fault, but the '.
							'current version of the Sirel library does not'.
							'yet contain a gsub_by_regex function, so '.
							'the scty_varchar has to be right next to '.
							'its parenthesis like "scty_varchar(".');
				} // if
			} // if
			$arht_dt_norm2native=sirelDBgate::get_ht_data_types_norm2native();
			$ar_keys=array_keys($arht_dt_norm2native);
			$s_out=&$a_string;
			foreach ($ar_keys as $s_normalized) {
				$ereg=$s_normalized; // For exception text improvement.
				$s_out=mb_ereg_replace($ereg,
						$arht_dt_norm2native[$s_normalized],$s_out);
			} // foreach
			if(sirelSiteConfig::$debug_PHP) {
				// Regex test string:
				// --------------
				//(scty_x, scty_y,scty_ggscty_,scty_	,scty_  	scty_)
				// scty_fff
				// ,scty_ scty , scty_ scty_scty_ blablascty_
				//scty_
				// scmx_ff scFF_gg fcty_ff
				//---------------
				$regex="([,\\(\\s\\t)]|^)scty_([^,(\\s\\t])*";
				if(mb_ereg_match($regex, $s_out)) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'It\'s very likely that there\'s a typo '.
							'in the input string or the set of '.
							'type conversion relations is faulty. '.
							'One could not replace all strings that '.
							'look as if they are normalized type names. '.
							'The output string would be: "'.$s_out.'".');
				} // if
			} // if
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': $ereg=='.$ereg);
		} // catch
	} // convert_normalized_db_data_types_2_native

	public function var_2_normalized_data_type(&$x_var) {
		try {
			$s_type_name=sirelLang::type_2_s($x_var);
			$s_normalized_data_type=NULL;
			switch ($s_type_name) {
				case 'sirelTD_is_int':
					$s_normalized_data_type='scty_int';
					break;
				case 'sirelTD_is_mbstring':
					$s_normalized_data_type='scty_txt';
					if(mb_strlen($x_var)==1) {
						// The length check is for speed only.
						if((sirelLang::str1EqualsStr2($x_var,'t'))||(sirelLang::str1EqualsStr2($x_var,'f'))) {
							$s_normalized_data_type='scty_bool';
						} // if
					} // if
					break;
				case 'sirelTD_is_float':
					$s_normalized_data_type='scty_double';
					break;
				case 'sirelTD_is_bool':
					$s_normalized_data_type='scty_bool';
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_type_name=='.$s_type_name.'.');
					break;
			} // switch
			return $s_normalized_data_type;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // var_2_normalized_data_type

	public function cast_2_PHP_type(&$s_normalized_data_type, &$a_value) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',
						$s_normalized_data_type);
			} // if
			$answer=null;
			switch ($s_normalized_data_type) {
				case 'scty_varchar':
					$answer=''.$a_value;
					break;
				case 'scty_int':
					$answer=$a_value;
					if(!is_int($a_value)) {
						$answer=(int)$a_value;
					} // if
					break;
				case 'scty_txt':
					$answer=''.$a_value;
					break;
				case 'scty_double':
					$answer=$a_value;
					// PHP float == PHP double
					if(!is_double($a_value)) {
						// The idea is that one can not convert an
						// array or NULL or boolean to a float.
						// On the other hand, the PHP
						// floatval('4.5') returns 4.5, but
						// floatval('4,5') returns 4 in stead of throwing
						// an exception, which entails that
						// strings need separate treatment.
						$s_type=sirelLang::type_2_s($a_value);
						switch ($s_type) {
							case 'sirelTD_is_int':
								$answer=floatval($a_value);
								break;
							case 'sirelTD_is_float':
								$answer=floatval($a_value);
								break;
							case 'sirelTD_is_mbstring':
								$a_pair=sirelLang::str2float($a_value);
								if($a_pair->a_) {
									sirelThrowLogicException(__FILE__, __LINE__,
											__CLASS__.'->'.__FUNCTION__.': '.
											'Conversion from string to float '.
											'failed. $a_value=='.$a_value);
								} // if
								$answer=$a_pair->b_;
								break;
							default:
								throw new Exception(
								__CLASS__.'->'.__FUNCTION__.
										': There\'s no branch for '.
										'$s_type=='.$s_type.'.');
								break;
						} // switch
					} // if
					break;
				case 'scty_bool':
					$answer=$a_value;
					if(!is_bool($a_value)) {
						if(sirelSiteConfig::$debug_PHP) {
							sirelLang::assert_type(__FILE__, __LINE__,
									__CLASS__,__FUNCTION__,
									'sirelTD_is_mbstring',$a_value);
						} // if
						// The general problem with the
						// boolean values is that database
						// engines actually don't support them.
						//
						// That sounds crazy, but as of 2011
						// the only "standardized" solutions
						// available to the situation seemsto
						// be layers of inconsistent hacks. As this
						// code here has to work across databases,
						// one creates one's own hack by using
						// string type and values 't' and 'f'.
						//
						// The reason for using the strings
						// in stead of the more traditional
						// C++ short int, char, boolean is that
						// in the case of the strings all of the
						// database values are auto-convertable,
						// "selfconvertable", to strings, but its often
						// needed to exchange the boolean values
						// with client code, for example, JavaScript.
						$b_err=True;
						if(sirelLang::str1EqualsStr2($a_value,'t')) {
							$answer='t';
							$b_err=False;
						} else {
							if(sirelLang::str1EqualsStr2($a_value,'f')) {
								$answer='f';
								$b_err=False;
							} else {
								// The next if-else is just to overcome
								// some legacy stuff that I could not
								// find at the moment, in a hurry.
								// TODO: find out, where the 'true'/'false'
								// originate and refactor them out or explain
								// here, why they can not be refactored out.
								if(sirelLang::str1EqualsStr2($a_value,'true')) {
									$answer='t';
									$b_err=False;
								} else {
									if(sirelLang::str1EqualsStr2($a_value,'false')) {
										$answer='f';
										$b_err=False;
									} // if
								} // else
							} // else
						} // else
						if ($b_err) {
							sirelThrowLogicException(__FILE__, __LINE__,
									__CLASS__.'->'.__FUNCTION__.': '.
									'There\'s no branch for '.
									'$a_value=='.$a_value.'.');
						} // if
					} // if
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_normalized_data_type=='.
							$s_normalized_data_type.'.');
					break;
			} // switch
			return $answer;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // cast_2_PHP_type

//-------------------------------------------------------------
	function __construct() {
		try {
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // constructor

	// Call example:
	// $this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
	//         __FUNCTION__);
	//
	// It is meant to be the very first sentence of every public method
	// of this class.
	protected function assert_connection_to_the_db_exists($file,$line,
			$function) {
		if (!$this->pdodc_connected_) {
			sirelThrowLogicException($file,$line,
					__CLASS__.'->'.$function.': '.
					$this->msg_not_connected_);
		} // if
	} // assert_connection_to_the_db_exists(...)

	protected function dbstring(&$database_descriptor) {
		$x=$database_descriptor->db_type_;
		$answer=NULL;
		switch ($x) {
			case 'postgresql':
				$answer='pgsql';
				break;
			case 'sqlite':
				$answer='sqlite';
				throw 'As of 2011 the use of SQLite is not yet supported, '.
						'but it is in a TODO list and seems to be a perspective '.
						' thing, specially given that it is included to '.
						'the standard PHP distribution';
				break;
			case 'mysql':
				$answer='mysql';
				throw(new Exception(''.
						'As of 2011 the use of MySQL is deprecated. '.
						' One should use the http://drizzle.org/ in stead. '.
						' The main problem with the MySQL is some MySQL specific '.
						' nonsense with buffered queries, where the PHP side just '.
						' does not support it properly. According to some sources '.
						' the buffered SQL queries are a kind queries that '.
						' do not block the PHP thread that creates them and then '.
						' the programmer is expected to start wasting ones time on '.
						' reinventing the wheel and writing code that deals with that '.
						' situation, not to mention that the PHP drivers do not '.
						' support the alternative and the PHP side just crashes.'));
				break;
			default:
				sirelThrowResourceException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':  The received database '.
						"type (==".$database_descriptor->db_type_.
						") is not yet supported by this method. ");
				break;
		} // switch
		return $answer;
	} // dbstring

	private function connect_inithelp1() {
		try {
			if(array_key_exists('skip_existence_checks', $this->db_descriptor_->various_)) {
				$this->skip_existence_checks_=$this->db_descriptor_->various_['skip_existence_checks'];
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_bool',
						$this->skip_existence_checks_);
			} // if
			if(array_key_exists('schema', $this->db_descriptor_->various_)) {
				$this->schema_=$this->db_descriptor_->various_['schema'];
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__, 'sirelTD_is_mbstring', $this->schema_);
				$this->schema_=sirelLang::mb_trim(mb_strtolower($this->schema_));
				if($this->schema_=='') {
					$this->schema_=NULL;
				} // IF
			} // if
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // connect_inithelp1

	// If the $convert_to_UTF8==True, all of the strings that
	// are sent to database are explicitly converted to UTF-8.
	// If the mbstring internal representation is UTF-8, the strings
	// are usually, but not always, implicitly converted before they
	// reach this method.
	public function connect(&$database_descriptor, $convert_to_UTF8=False) {
		try {
			if(is_null($database_descriptor)) {
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'$database_descriptor had a value of NULL.');
			} // if
			if(get_class($database_descriptor)!='sirelDatabaseDescriptor') {
				$x=sirelLang::type_2_s($database_descriptor);
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'$database_descriptor is required to be of '.
						'sirelDatabaseDescriptor. ||| '.
						'sirelLang::type_2_s($database_descriptor)=='.$x);
			} // if
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__, 'sirelTD_is_bool', $convert_to_UTF8);
			if(!$this->pdodc_connected_) {
				$this->db_descriptor_=&$database_descriptor;
				$this->db_descriptor_->db_type_=
						mb_strtolower($database_descriptor->db_type_);
				$this->pdodc_ = new PDO($this->dbstring($database_descriptor).
								':host='.$database_descriptor->hostname_.
								';port='.$database_descriptor->port_.
								';dbname='.$database_descriptor->db_name_,
						$database_descriptor->username_,
						$database_descriptor->password_);
				$this->pdodc_->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
				$this->convert_to_UTF8_=$convert_to_UTF8;
				$this->connect_inithelp1();
				$this->pdodc_connected_=True;
			} // if
		} catch (PDOException $e) {
			$this->pdodc_connected_=False;
			// The $e->getMessage() reviels the database
			// user name and otherwise too much about
			// the environment. One does not want to display that
			// for sake of security. However, unfortunately,
			// on 28 October 2011 the hiding of it ensured
			// at least 4 hours of extra work, so it has to be
			// visible in debug mode.
			$s_msg='Could not establish a database connection. '.
					'But, let us not forget that there is always a '.
					'<a href="http://www.youtube.com/watch?v=ndwEOIaeuGo">'.
					'bright side of life </a>. :-) '."\n\n";
			if(sirelSiteConfig::$debug_PHP) {
				$s_msg=$s_msg.'  '.$e->getMessage();
			} // if
			sirelThrowResourceException(__FILE__,__LINE__,$s_msg);
		} // catch
	} // connect

	public function is_connected() {
		return $this->pdodc_connected_;
	} // is_connected


	// If a database engine does not support schemas, this
	// method does nothing. In order to avoid programming errors,
	// a connection to the database is required to be established
	// before a call to this method.
	public function set_schema($schema) {
		$schema=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
				__LINE__, __CLASS__,__FUNCTION__,$schema);
		$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
				__FUNCTION__);
		$shemas_supported=False;
		switch ($this->db_descriptor_->db_type_) {
			case 'postgresql':
				$shemas_supported=True;
				break;
			case 'mysql':
				sirelLogger::log(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'MySQL does not support schemas properly.');
				// One would return from here, if one would assume that at least
				// main-stream language implementations are without bugs.
				break;
			default:
				throw new Exception(
				__CLASS__.'->'.__FUNCTION__.':: database type '.
						$this->db_descriptor_->db_type_.' '.
						'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...)
						and the '.__CLASS__.'->dbstring(...).');
				break;
		} // switch
		if(!$shemas_supported) {
			return;
		} // if
		$this->schema_=$schema;
		$this->apply_schema_method_in_use=True;
		$this->apply_schema();
		$this->apply_schema_method_in_use=False;
	} // set_schema(...)

	// Returns an array of schema names or NULL, if no schemas exist.
	// For MySQL it returns database names.
	public function get_existing_schema_names() {
		$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
				__FUNCTION__);
		try {
			$stm='SELECT schema_name FROM information_schema.schemata '.
					'WHERE catalog_name=\''.$this->db_descriptor_->db_name_.'\' ;';
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$params=array();
			$rows=$this->exec_transaction($stm, $params);
			$this->skip_existence_checks_=$b;
			if(count($rows)==0) {
				return NULL;
			}
			// For some weird reason the PHP version of the DB query
			// returns 2 columns in stead of one. Hence the following loop.
			$answer=array();
			foreach($rows as $row) {
				$answer[]=$row[0];
			} //foreach
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_existing_schema_names

	// Returns an array of sequence names. If the database does not
	// contain any sequences, then it returns NULL. If it returns an
	// array, then the array contains at least one element.
	//
	// The sequences are searched only from schemas that are listed within
	// the $array_of_schema_names;
	private function get_existing_sequence_names_PostgreSQL(&$array_of_schema_names) {
		$schemas=&$array_of_schema_names;
		sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
				'sirelTD_is_array',$schemas);
		try {
			$stm0='SELECT sequence_name FROM information_schema.sequences '.
					'WHERE sequence_catalog=\''.$this->db_descriptor_->db_name_.
					'\' AND sequence_schema=\'';
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$params=array();
			$answer0=array();
			foreach($schemas as $schema) {
				sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
						'sirelTD_is_mbstring',$schema);
				$stm=$stm0.$schema.'\' ;';
				$rows=$this->exec_transaction($stm, $params);
				if(0<count($rows)) {
					$answer0=array_merge($answer0,$rows);
				} // if
			} // foreach
			$this->skip_existence_checks_=$b;
			if(count($answer0)==0) {
				return NULL;
			}
			// For some weird reason the PHP version of the DB query
			// returns 2 columns in stead of one. Hence the following loop.
			$answer=array();
			foreach($answer0 as $sequence) {
				$answer[]=$sequence[0];
			} //foreach
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_existing_sequence_names_PostgreSQL


	// Returns an array of strings or NULL. If the answer is not null,
	// the array of strings is quaranteed to contain at least one element.
	private function get_schema_search_path_PostgreSQL() {
		// One might change this method to protected or maybe even public
		// one day.
		$answer;
		try {
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$stm='show search_path ;';
			$params=array();
			$results=$this->exec_transaction($stm, $params);
			$this->skip_existence_checks_=$b;
			if(count($results)<=0) {
				return NULL;
			} // if
			$s=$results[0][0];
			$answer=sirelLang::commaseparated_list_2_array($s);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
		return $answer;
	} // get_schema_search_path_PostgreSQL

	// Creates a schema, if it does not exist, and throws an exception, if
	// it already exists.
	private function create_schema_PostgreSQL(&$schema_name) {
		sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
				'sirelTD_is_mbstring',$schema_name);
		try {
			$s=sirelLang::mb_trim($schema_name);
			if($s=='') {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'$schema_name consisted of only spaces or tabs. ');
			} // if
			if ($s=='public') {
				return;
			} // if
			$stm='create schema '.$s.' ;';
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$params=array();
			$this->exec_transaction($stm, $params);
			$this->skip_existence_checks_=$b;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_schema_PostgreSQL

	// If $require_schemas_to_exist==False, it permanently modifies the
	// search_path within the database, but the modification takes effect
	// at the next connection to the database.
	// If $require_schemas_to_exist==True, the search_path changes
	// within the current database connection, but the modification effect is
	// not present at the next connection to the database.
	private function set_schema_search_path_PostgreSQL_base(&$array_of_schema_names,
			$require_schemas_to_exist=False) {
		$answer;
		try {
			$ar=&$array_of_schema_names;
			sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
					'sirelTD_is_array',$ar);
			if(count($ar)<=0) {
				sirelThrowLogicException(__FILE__, __LINE__,
						'The $array_of_schema_names was empty.');
			} // if
			// The version of the $stm  without the "ALTER USER nicenusername "
			// throws an exception at the SQL execution, if at least one of the
			// schemas within the $array_of_schemas does not exist.
			$stm=' SET search_path TO ';
			if(!$require_schemas_to_exist) {
				// HERE's some bug, because for some reason the search_path
				// can not be altered automatically, by using PHP.
				// TODO: fix it.
				$stm='ALTER USER '.$this->db_descriptor_->username_.' '.$stm;
			} // if
			$b2=False;
			foreach($ar as $schema_name) {
				sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
						'sirelTD_is_mbstring',$schema_name,
						' All of the elements within the $array_of_schema_names '.
						'are required to be strings. ');
				$s=sirelLang::mb_trim($schema_name);
				if($s=='') {
					continue;
				}
				if ($b2) {
					$stm=$stm.',';
				} else {
					$b2=True;
				} // else
				$stm=$stm.$s;
			} // foreach
			if(!$b2) {
				sirelThrowLogicException(__FILE__, __LINE__,
						'All of the strings within the $array_of_schema_names '.
						'consisted of only spaces or tabs.'
				);
			} // if
			$stm=$stm.' ;';
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$params=array();
			$this->exec_transaction($stm, $params);
			$this->exec_transaction($stm, $params);
			$this->skip_existence_checks_=$b;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_schema_search_path_PostgreSQL_base


	// Alters the search_path so that the new value is available
	// while the current connection to the database lasts and also
	// at the next connection, provided that some other thread
	// has not re-altered the value of the search_path. It also
	// creates the missing schemas.
	private function set_schema_search_path_PostgreSQL(
			&$array_of_schema_names) {
		try {
			sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
					'sirelTD_is_array',$array_of_schema_names);
			$path_schemas=&$array_of_schema_names;
			if(count($path_schemas)==0) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'The $array_of_schema_names was empty.');
			} // if
			$existing_schemas=$this->get_existing_schema_names();
			if (is_null($existing_schemas)) {
				$existing_schemas=array();
			} // if
			foreach($path_schemas as $path_schema) {
				if (!sirelLang::array_contains_an_element($existing_schemas, $path_schema)) {
					$this->create_schema_PostgreSQL($path_schema);
				} // if
			} // foreach
			$this->set_schema_search_path_PostgreSQL_base($path_schemas, False);
			$this->set_schema_search_path_PostgreSQL_base($path_schemas, True);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_schema_search_path_PostgreSQL


	// Makes sure that the search_path has an appropriate value and that
	// the schemas also exist.
	private function apply_schema_PostgreSQL() {
		$ar_schemas;
		if(is_null($this->schema_)) {
			$ar_schemas=$this->get_schema_search_path_PostgreSQL();
			if(0<count($ar_schemas)) {
				// The default search_path will do.
			} else {
				sirelThrowResourceException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: The '.
						'search_path in the database is unset while '.
						'the schema has not been determined within '.
						'the site configuration file. ');
			} // else
		} else {
			$ar_schemas=sirelLang::commaseparated_list_2_array($this->schema_);
			// The settings are supposed to override the
			// search_path within the database.
			if(is_null($ar_schemas)) {
				sirelThrowResourceException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'The string in the site configuration does not '.
						'properly describe a schema. String value:|||'.
						$this->schema_);
			} // if
		} // else
		$this->set_schema_search_path_PostgreSQL($ar_schemas);
	} // apply_schema_PostgreSQL


	private $apply_schema_method_in_use=False;
	// Creates the schema, if needed, and modifies the schema search path
	// within the database, if needed. The search path is set according
	// to the schema parameter in the site configuration.
	//
	// It seems that if there are multiple connections to the
	// database, for example, if the web server receives multiple requests,
	// then if the serving of the first request has not been finished,
	// the serving of the other request crashes. That's why this method
	// is executed only by the $this->set_shcema(...).
	private function apply_schema() {
		try {
			if($this->skip_existence_checks_) return;
			if(!$this->apply_schema_method_in_use) return;
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					$this->apply_schema_PostgreSQL();
					break;
				case 'mysql':
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.':: database type '.
							$this->db_descriptor_->db_type_.' '.
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...)
						and the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // apply_schema

	private function exec_transaction_debug_check1(&$statement, $funcname) {
		if(!sirelSiteConfig::$debug_PHP) {
			return;
		} // if
		$s=sirelLang::mb_trim($statement);
		$l=mb_strlen($s);
		if($l==0) {
			return;
		} // if
		$pos=mb_strpos($s, ';');
		if(is_null($pos)) {
			return;
		} // if
		if(($l-1)==$pos) {
			return;
		} // if
		if(($l-1)<$pos) {
			sirelThrowLogicException(__FILE__,__LINE__,
					__CLASS__.'->'.__FUNCTION__.
					'(...): This just can not possibly happen. ');
		} // if
		sirelThrowLogicException(__FILE__,__LINE__,
				__CLASS__.'->'.__FUNCTION__.
				'(...): The SQL statement string contained a semicolon. Function '.
				$funcname.' has a peculiarity that it can process only a single '.
				'SQL statement at a time. ');
	} // exec_transaction_debug_check1

	private $exec_transaction_SQL_statement_compilation_params_cache_=42; // 42 for assignment by reference.
	private $b_exec_transaction_SQL_statement_compilation_params_cached_=False;
	private function exec_transaction_SQL_statement_compilation_params() {
		try {
			$arht_out=&$this->exec_transaction_SQL_statement_compilation_params_cache_;
			if($this->b_exec_transaction_SQL_statement_compilation_params_cached_==True) {
				return $arht_out;
			} // if
			$arht_out=array();
			$s_db_type=$this->db_descriptor_->db_type_;
			switch ($s_db_type) {
				case 'mysql':
					$arht_out[PDO::MYSQL_ATTR_USE_BUFFERED_QUERY]=True;
					break;
				case 'postgresql':
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_db_type=='.$s_db_type.'.');
					break;
			} // switch
			$this->exec_transaction_SQL_statement_compilation_params_cache_=&$arht_out;
			$this->b_exec_transaction_SQL_statement_compilation_params_cached_=True;
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // exec_transaction_SQL_statement_compilation_params


	// Returns an array of rows, which can be empty. It never returns
	// NULL.
	//
	// In general this method is used somewhat
	// as described in the following example:
	//
	// $parametrized_SQL_statement="insert into TypeTable (instance_ID,
	//     instance_type_name) values (:firstvalue, :secondvalue) ;";
	//
	// $array_of_parameters=array(":firstvalue"=> 69,
	//  ":secondvalue" => "Monroe");
	//
	// The colons are part of the parametrized SQL related convention
	// and another tricky thing is that it seems to be possible only to
	// "parametrize" the VALUES, not column names, table
	// names, etc.
	//
	// A peculiarity of the exec_transaction(...) is that the
	// $parametrized_SQL_statement is not allowed to contain multiple
	// SQL statements at once.
	public function exec_transaction(&$parametrized_SQL_statement,
			&$array_of_parameters) {
		try {
			// One of the reasons, but not the only one, for the single SQL
			// statement requirement is that due to the PHP PDO interface
			// the transaction is not allowed to contain a mixture of database
			// writing commands and the select commend.
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__,__CLASS__,__FUNCTION__,
						'sirelTD_is_mbstring',$parametrized_SQL_statement);
				sirelLang::assert_type(__FILE__, __LINE__,__CLASS__,__FUNCTION__,
						'sirelTD_is_array',$array_of_parameters);
			} // if
			$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
					__FUNCTION__);
			$statement;
			try {
				if($this->convert_to_UTF8_) {
					$statement=mb_convert_encoding($parametrized_SQL_statement,
							'UTF-8','auto');
				} else {
					$statement=&$parametrized_SQL_statement;
				} // else
				$this->apply_schema();
				$this->exec_transaction_debug_check1($statement,__FUNCTION__);
				$arht_statement_compilation_params=$this->exec_transaction_SQL_statement_compilation_params();
				$query=$this->pdodc_->prepare($statement,
						$arht_statement_compilation_params);
			} catch (Exception $err_exception) {
				sirelThrowLogicException(__FILE__,__LINE__,
						'The preparation of the SQL statement(==<br/>'.
						$statement.'<br/> within the '.
						__CLASS__.'->'.__FUNCTION__.': failed. '.
						'Message of the caught exception:<br/>'.
						$err_exception->getMessage());
			} // catch
			$x=True;
			try {
				$x=$this->pdodc_->beginTransaction();
				if(!$x) {
					throw new Exception( 'SQL query transaction '.
							'startup in '.__CLASS__.'->'.__FUNCTION__.
							'failed. Statement==<br/>'.$statement);
				} // if
			} catch (Exception $err_exception) {
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						$err_exception->getMessage());
			} // catch
			$x=True;
			try {
				if($this->convert_to_UTF8_) {
					$keys=array_keys($array_of_parameters);
					foreach($keys as $key) {
						$array_of_parameters[$key]=mb_convert_encoding($array_of_parameters[$key],
								'UTF-8','auto');
					} // foreach
				} //if
				$x=$query->execute($array_of_parameters);
				if(!$x) {
					throw new Exception( 'SQL query execution in '.
							__CLASS__.'->'.__FUNCTION__.': failed.
					Statement==<br/>'.$statement);
				} // if
			} catch (Exception $err_exception) {
				$this->pdodc_->rollBack();
				$s="";
				if($x) {
					$s='SQL query execution in '.
							__CLASS__.'->'.__FUNCTION__.': failed.
					Statement==<br/>'.$statement.
							"\n".'<br/><br/>'."\n";
				} //
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':  '.$s.
						$err_exception->getMessage());
			} // catch
			try {
				$x=$this->pdodc_->commit();
				if(!$x) {
					throw new Exception( 'SQL query commit in '.
							__CLASS__.'->'.__FUNCTION__.
							' failed. Statement==<br/>'.$statement);
				} // if
			} catch (Exception $err_exception) {
				$this->pdodc_->rollBack();
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.':  '.
						$err_exception->getMessage());
			} // catch
			$array_of_query_output_rows=$query->fetchAll();
			if(is_null($array_of_query_output_rows)) {
				$array_of_query_output_rows=array();
			} // if
			return $array_of_query_output_rows;
		} catch (Exception $err_exception) {
			if(sirelSiteConfig::$debug_PHP) {
				echo('GUID="4c5244e5-73d7-430d-b2e6-f2006080bcd7" '.
						$err_exception->getMessage());
			} // if
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': '.
					$err_exception->getMessage());
		} // catch
	} // exec_transaction

	// Returns True, if the table exists. Otherwise returns False.
	// It is influenced by the schema settings.
	private function table_exists_PostgreSQL(&$table_name) {
		try {
			$this->apply_schema();
			$schemas=$this->get_schema_search_path_PostgreSQL();
			if(is_null($schemas)) {
				$msg='PostgreSQL search path has not been set';
				if(!$this->skip_existence_checks_) {
					$msg=$msg.', nor is '.
							'there a valid schema search_path setting present '.
							'in the site configuration. ';
				} else {
					$msg=$msg.'.';
				} // else
				sirelThrowLogicException(__FILE__, __LINE__,$msg);
			} // if
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$params=array();
			$answer=False;
			$stm0= 'SELECT table_name FROM information_schema.tables WHERE '.
					'table_catalog=\''.$this->db_descriptor_->db_name_.
					'\' AND table_name=\'';
			foreach($schemas as $schema) {
				$stm= $stm0.$table_name.'\' AND table_schema=\''.$schema.'\' ;';
				$rows=$this->exec_transaction($stm,$params);
				if (0<count($rows)) {
					$answer=True;
					break;
				} // if
			} // foreach
			$this->skip_existence_checks_=$b;
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // table_exists_PostgreSQL

	private function table_exists_MySQL(&$table_name) {
		// In the MySQL the table_catalog==NULL.
		$stm='SELECT table_name FROM information_schema.tables WHERE '.
				'table_schema = :databasename AND table_name = :tablename ;';
		$params=array();
		$params[':databasename']=$this->db_descriptor_->db_name_;
		$params[':tablename']=$table_name;
		$rows=$this->exec_transaction($stm, $params);
		$answer=False;
		if (0<count($rows)) {
			$answer=True;
		}
		return $answer;
	} // table_exists_MySQL

	// Returns True, if the $table_name exists
	// in the database. Returns False otherwise.
	public function table_exists($table_name) {
		sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,__LINE__,
				__CLASS__,__FUNCTION__,$table_name);
		$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
				__FUNCTION__);
		$answer=False;
		try {
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					$answer=$this->table_exists_PostgreSQL($table_name);
					break;
				case 'mysql':
					$answer=$this->table_exists_MySQL($table_name);
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.'::  database type '.
							$this->db_descriptor_->db_type_." ".
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...) and
						the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
		} catch (Exception $err_exception) {
			sirelThrowLogicException(__FILE__,__LINE__,
					$err_exception->getMessage());
		} // catch
		return $answer;
	} // table_exists(...)

	private function get_column_names_PostgreSQL(&$table_name) {
		try {
			$this->apply_schema();
			$schemas=$this->get_schema_search_path_PostgreSQL();
			if(is_null($schemas)) {
				$msg='PostgreSQL search path has not been set';
				if(!$this->skip_existence_checks_) {
					$msg=$msg.', nor is '.
							'there a valid schema search_path setting present '.
							'in the site configuration. ';
				} else {
					$msg=$msg.'.';
				} // else
				sirelThrowLogicException(__FILE__, __LINE__,$msg);
			} // if
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$stm0= 'SELECT column_name FROM information_schema.columns WHERE '.
					'table_catalog=\''.$this->db_descriptor_->db_name_.
					'\' AND table_name=\'';
			// Warning: it only looks for tables from the first schema.
			// That's for compatibility with the MySQL.
			$stm= $stm0.$table_name.'\' AND table_schema=\''.$schemas[0].'\' ;';
			$params=array();
			$rows=$this->exec_transaction($stm,$params);
			$this->skip_existence_checks_=$b;
			return $rows;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_column_names_PostgreSQL

	private function get_column_names_MySQL(&$table_name) {
		// In the MySQL the table_catalog==NULL.
		$stm='SELECT column_name FROM information_schema.columns WHERE '.
				'table_schema = :databasename AND table_name = :tablename ;';
		$params=array();
		$params[':databasename']=$this->db_descriptor_->db_name_;
		$params[':tablename']=$table_name;
		$rows=$this->exec_transaction($stm, $params);
		return $rows;
	} // get_column_names_MySQL


	// private function get_column_names_SQLite3(&$table_name) {
	// $stm='SELECT sql FROM sqlite_master WHERE '.
	// 'type = \'table\' AND tbl_name = :tablename; ';
	// $params=array();
	// $params[':tablename']=$table_name;
	// $rows=$this->exec_transaction($stm, $params);
	// if(count($rows)==0) { // === wrong table name
	// return $rows;
	// } // if
	// // The $s_sql===
	// // === 'CREATE TABLE tablename (columname_1 int, columname_2 text, columname_3 real)'
	// $s_sql=&$rows[0];
	// // On sqlite3 SQL-console it was not possible to create a columness
	// // table, but one might want to throw an exception, if the $rows[0]
	// // does not match with the regex.
    // //
	// throw(new Exception('everything above this line in this func is OK, but'.
	// 'untested. This function is subject to completion.' ));
	// return $rows;
	// } // get_column_names_SQLite3


// Returns an array of column names.
	public function get_column_names($table_name) {
		sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,__LINE__,
				__CLASS__,__FUNCTION__,$table_name);
		$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
				__FUNCTION__);
		$rows_of_column_names;
		try {
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					$rows_of_column_names=$this->get_column_names_PostgreSQL(
							$table_name);
					break;
				case 'mysql':
					$rows_of_column_names=$this->get_column_names_MySQL(
							$table_name);
					break;
				//case 'sqlite3':
				//	$rows_of_column_names=$this->get_column_names_SQLite3(
				//			$table_name);
				//	break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.'::  database type '.
							$this->db_descriptor_->db_type_." ".
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...) and
						the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
			$ar_column_names=array();
			foreach ($rows_of_column_names as $a_row) {
				$ar_column_names[]=$a_row[0];
			} // foreach
			return $ar_column_names;
		} catch (Exception $err_exception) {
			sirelThrowLogicException(__FILE__,__LINE__,
					$err_exception->getMessage());
		} // catch
		return $ar_column_names;
	} // get_column_names

//-------------------------------------------------------------------------
	private function ar_get_table_names_PostgreSQL() {
		try {
			$stm='SELECT tablename FROM pg_tables WHERE '.
					'schemaname = :s_schemaname ; ';
			$s_schema=$this->db_descriptor_->various_['schema'];
			$params=array();
			$params[':s_schemaname']=$s_schema;
			$rows=$this->exec_transaction($stm,$params);
			return $rows;
		} catch (Exception $err_exception) {
			sirelThrowLogicException(__FILE__,__LINE__,
					$err_exception->getMessage());
		} // catch
	} // ar_get_table_names_PostgreSQL

	private function ar_get_table_names_MySQL() {
		try {
			$stm='SELECT table_name FROM information_schema.tables WHERE '.
					'table_schema = :s_schemaname ; ';
			// In MySQL the database name is equal to the database schema.
			$s_schema=$this->db_descriptor_->db_name_;
			$params=array();
			$params[':s_schemaname']=$s_schema;
			$rows=$this->exec_transaction($stm,$params);
			return $rows;
		} catch (Exception $err_exception) {
			sirelThrowLogicException(__FILE__,__LINE__,
					$err_exception->getMessage());
		} // catch
	} // ar_get_table_names_MySQL

	public function ar_get_table_names() {
		try {
			$ar_rows=NULL;
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					$ar_rows=$this->ar_get_table_names_PostgreSQL();
					break;
				case 'mysql':
					$ar_rows=$this->ar_get_table_names_MySQL();
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.'::  database type '.
							$this->db_descriptor_->db_type_." ".
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...) and
						the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
			$ar_table_names=array();
			foreach ($ar_rows as $a_row) {
				$ar_table_names[]=$a_row[0];
			} // foreach
			return $ar_table_names;
		} catch (Exception $err_exception) {
			sirelThrowLogicException(__FILE__,__LINE__,
					$err_exception->getMessage());
		} // catch
	} // ar_get_table_names

//-----------------------------------------------------------------

	private function get_column_types_normalization(
			&$rows_with_db_specific_type_names) {
		try {
			$arht_normalized=array();
			$s_column_name='';
			$s_type_name_native='';
			$arht_native2norm=$this->get_ht_data_types_native2norm();
			if(sirelSiteConfig::$debug_PHP) {
				foreach ($rows_with_db_specific_type_names as $a_row) {
					$s_column_name=$a_row[0];
					$s_type_name_native=$a_row[1];
					if(!array_key_exists($s_type_name_native, $arht_native2norm)) {
						sirelThrowLogicException(__FILE__, __LINE__,
								__CLASS__.'->'.__FUNCTION__.': '.
								'There\'s no relation for native type of "'.
								$s_type_name_native.'" in the set '.
								'of relations for database type of "'.
								$this->db_descriptor_->db_type_.'".');
					} // if
				} // foreach
			} // if
			foreach ($rows_with_db_specific_type_names as $a_row) {
				$s_column_name=$a_row[0];
				$s_type_name_native=$a_row[1];
				$arht_normalized[$s_column_name]=$arht_native2norm[$s_type_name_native];
			} // foreach
			return $arht_normalized;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_column_types_normalization

	private function get_column_types_PostgreSQL(&$table_name) {
		try {
			$this->apply_schema();
			$schemas=$this->get_schema_search_path_PostgreSQL();
			if(is_null($schemas)) {
				$msg='PostgreSQL search path has not been set';
				if(!$this->skip_existence_checks_) {
					$msg=$msg.', nor is '.
							'there a valid schema search_path setting present '.
							'in the site configuration. ';
				} else {
					$msg=$msg.'.';
				} // else
				sirelThrowLogicException(__FILE__, __LINE__,$msg);
			} // if
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$stm='SELECT column_name, data_type FROM '.
					'information_schema.columns WHERE '.
					'table_schema = :a_schema AND table_name = :tablename ;';
			// Warning: it only looks for tables from the first schema.
			// That's for compatibility with the MySQL.
			$params=array();
			$params[':a_schema']=$schemas[0];
			$params[':tablename']=$table_name;
			$rows_with_db_specific_type_names=$this->exec_transaction($stm,$params);
			$this->skip_existence_checks_=$b;
			return $rows_with_db_specific_type_names;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_column_types_PostgreSQL

	private function get_column_types_MySQL(&$table_name) {
		try {
			$stm='SELECT column_name, data_type FROM '.
					'information_schema.columns WHERE '.
					'table_schema = :databasename AND table_name = :tablename ;';
			$params=array();
			$params[':databasename']=$this->db_descriptor_->db_name_;
			$params[':tablename']=$table_name;
			$rows_with_db_specific_type_names=$this->exec_transaction($stm,$params);
			return $rows_with_db_specific_type_names;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_column_types_MySQL

	// Returns a hashtable, where the key is a column name and
	// the value is a string that describes the column type.
	public function get_column_types($table_name) {
		sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,__LINE__,
				__CLASS__,__FUNCTION__,$table_name);
		$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
				__FUNCTION__);
		$rows_with_db_specific_type_names;
		try {
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					$rows_with_db_specific_type_names=$this->get_column_types_PostgreSQL(
							$table_name);
					break;
				case 'mysql':
					$rows_with_db_specific_type_names=$this->get_column_types_MySQL($table_name);
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.'::  database type '.
							$this->db_descriptor_->db_type_." ".
							'is not yet supported by this method
						and an exception should have been thrown
						within the '.__CLASS__.'->connect(...) and
						the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
			$arht_normalized=$this->get_column_types_normalization(
					$rows_with_db_specific_type_names);
			return $arht_normalized;
		} catch (Exception $err_exception) {
			sirelThrowLogicException(__FILE__,__LINE__,
					$err_exception->getMessage());
		} // catch
		return $rows_with_db_specific_type_names;
	} // get_column_types

//-----------------------------------------------------------------
	private function create_sequence_PostgreSQL(&$sequence_name) {
		try {
			if(!$this->skip_existence_checks_) {
				$schemas=$this->get_schema_search_path_PostgreSQL();
				if(is_null($schemas)) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.
							'(...): The search_path does not contain any schemas.');
				} // if
			} // if
			$stm='CREATE SEQUENCE '.$this->generate_ID_tablename_.
					' maxvalue 2147483648 cache 1 cycle ;';
			$params=array();
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$this->exec_transaction($stm, $params);
			$this->skip_existence_checks_=$b;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': '.
					$err_exception->getMessage());
		} // catch
	} // create_sequence_PostgreSQL(...)

	private function generate_ID_PostgreSQL() {
		$answer=NULL;
		try {
			if(!$this->skip_existence_checks_) {
				$this->apply_schema();
				$schemas=$this->get_schema_search_path_PostgreSQL();
				if(is_null($schemas)) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.
							': The search_path does not contain any schemas.');
				} // if
				$sequences=$this->get_existing_sequence_names_PostgreSQL($schemas);
				$create_it=True;
				if($sequences!=NULL) {
					if(sirelLang::array_contains_an_element($sequences,
					$this->generate_ID_tablename_)) {
						$create_it=False;
					} // if
				} // if
				if($create_it) {
					$this->skip_existence_checks_=True;
					$this->create_sequence_PostgreSQL($this->generate_ID_tablename_);
					$this->skip_existence_checks_=False;
				} // if
			} // if
			$params=array();
			$stm='select nextval(\''.$this->generate_ID_tablename_.'\');';
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$rows=$this->exec_transaction($stm,$params);
			$this->skip_existence_checks_=$b;
			if(count($rows)<=0) {
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.
						'(): ID is missing from query output.');
			} // if
			$answer=$rows[0][0];
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
		return $answer;
	} // generate_ID_PostgreSQL()

	// The next 2 vars are for hacks that reduce the number of SQL statements.
	private $b_generate_ID_MySQL_table_cleanup_=False;
	private $i_generate_ID_MySQL_table_cleanup_cnt_=0;

	private function generate_ID_MySQL_table_cleanup() {
		try {
			$i_max_param=62;
			$this->i_generate_ID_MySQL_table_cleanup_cnt_=$this->i_generate_ID_MySQL_table_cleanup_cnt_+1;
			if($i_max_param<$this->i_generate_ID_MySQL_table_cleanup_cnt_) {
				$this->i_generate_ID_MySQL_table_cleanup_cnt_=0;
				$this->b_generate_ID_MySQL_table_cleanup_=False;
			} // if
			if($this->b_generate_ID_MySQL_table_cleanup_==True) {
				return;
			} // if
			$statement='DELETE FROM '.$this->generate_ID_tablename_.' ;';
			$an_empty_array=array();
			$this->exec_transaction($statement, $an_empty_array);
			$this->b_generate_ID_MySQL_table_cleanup_=True;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // generate_ID_MySQL_table_cleanup()


// As of 2009 the MySQL (MariaDB) does not have a
// proper sequence support, the MySQL implementation
// is a kind of hacky workaround. Just a reminder: one of the
// goals of the class sirelDBgate is to abstract away the
// database engine specific issues.
	private function generate_ID_MySQL() {
		//The connection existence verification is left to the generate_ID(...).
		//
		// The reason, why the implementation here is such a hack
		// is that the PHP PDO interface does not seem to allow a MySQL
		// transaction to be a mixture of database writing commands
		// and the select command.
		//
		// According to one of the "solutions" to the bug,
		// http://bugs.php.net/bug.php?id=47504
		// multiple SQL statements may return multiple sets of
		// results and anything that ends with a semicolon (;) is
		// considered an SQL statement.
		$answer=NULL;
		try {
			$array_of_parameters=array();
			if(!$this->skip_existence_checks_) {
				if(!$this->table_exists($this->generate_ID_tablename_)) {
					// TODO: write a single stored procedure for the
					// checking of the existance of the table, the
					// table creation and the ID retrieval.
					$statement='create table '.$this->generate_ID_tablename_.
							' (id int primary key auto_increment );';
					$this->exec_transaction($statement, $array_of_parameters);
				} // if
			} // if
			$this->generate_ID_MySQL_table_cleanup();
			$statement='insert into '.$this->generate_ID_tablename_.
					' (id) values (42) ;';
			$this->exec_transaction($statement, $array_of_parameters);
			$statement='select last_insert_id() from '.
					$this->generate_ID_tablename_.' ;';
			$rows=$this->exec_transaction($statement, $array_of_parameters);
			if(count($rows)<=0) {
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.
						'(): ID is missing from query output.');
			} // if
			$answer=$rows[0][0];
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
		return $answer;
	} // generate_ID_MySQL()


// Returns a string ID that is
// unique within the database. Initially this method was meant
// for abstracting away database objects called "sequences", but due to
// the fact that on 32bit systems the sequences returns only a 4 byte
// integer, which might lack a number of bits for
// some applications, a slower, string based, approach has been
// used in stead of the "classical", traditional, faster,
// "sequence" based approach.
//
// A string based ID-s also help the content
// of the database to outlive both, the hardware and the database
// engine. One also has to keep in mind that the database might be
// running on a 32-bit system and the web server might use
// 64-bit integers or vice-versa. Unlike integer based ID-s,
// string based ID-s overcome that issue.
	public function generate_ID() {
		$this->assert_connection_to_the_db_exists(__FILE__,__LINE__,
				__FUNCTION__);
		$answer='';
		try {
			$t=time();
			if($t<0) {
				$t=-$t; // We'll keep the "Year 2038 Problem" in mind.
			} // if
			switch ($this->db_descriptor_->db_type_) {
				case 'postgresql':
					$answer=$t.'_'.$this->generate_ID_PostgreSQL();
					break;
				case 'mysql':
					$answer=$t.'_'.$this->generate_ID_MySQL();
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.':: database type '.
							$this->db_descriptor_->db_type_.' '.
							'is not yet supported by this method
					and an exception should have been thrown
					within the '.__CLASS__.'->connect(...) and
					the '.__CLASS__.'->dbstring(...).');
					break;
			} // switch
// We'll stay one bit below the 2^31, as one does not know
// all of the internals of the mt_rand().
			$n=1073741823;
// The underschores ("_") are needed for making different ID-s
// from random numbers that woud yield a same sequence of characters
// if concatenated. For example: (10 134 12), (101 3 412), etc.
			$answer=$answer.'_'.mt_rand(0,$n);
			$answer=$answer.'_'.mt_rand(0,$n);
			$answer=$answer.'_'.mt_rand(0,$n);
// Don't forget to update the $this->get_ID_max_length(), if the
// formt of the ID got changed.
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
		return $answer;
	} // generate_ID()

// Returns the maximum number of characters that the string
// returned by sirelDBgate->generate_ID() contains.
	public function get_ID_max_length() {
// One will not run out of 10-base digits, if there are 2
// 10-base digits per 4 bits.
//
// For 64-bit systems it makes (64/4)*2=32 10-base digits per integer.
// 5*32+4=164
		return 164;
	} // get_ID_max_length(...)

// It won't throw an exception, if it is called with table names
// that do not exist. It checks the existence before trying to
// do anything.
	public function delete_table(&$table_name) {
		try {
			if (!$this->skip_existence_checks_) {
				$table_name=sirelLang::assert_is_string_nonempty_after_trimming(
						__FILE__,__LINE__,__CLASS__,__FUNCTION__,$table_name);
				$this->apply_schema();//It's OK to put it outside of the if block.
			} // if
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$params=array();
			$stm='DROP TABLE '.$table_name.' ;';
			$i=0;
			while($this->table_exists($table_name)) {
// Multiple schemas at the schema search path might contain
// a table named $table_name. In PostgreSQL only one
// of them is visible, the one that resides in the
// schema search path's first entry, but one never knows.
				$this->exec_transaction($stm, $params);
				if(300<$i++) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.':: '.
							'Table seems to be undeletable. ||| $table_name=='.
							$table_name);
				} // if
			} // while
			$this->skip_existence_checks_=$b;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // delete_table(...)

	private function ensure_table_existence_input_verification(&$table_name,
			&$column_descriptions,&$overwrite,$function_name,$line) {
		$table_name=sirelLang::assert_is_string_nonempty_after_trimming(
				__FILE__,$line, __CLASS__,$function_name,$table_name);
		$column_descriptions=sirelLang::assert_is_string_nonempty_after_trimming(
				__FILE__,$line,__CLASS__,$function_name,$column_descriptions);
		sirelLang::assert_type(__FILE__, $line, __CLASS__, $function_name,
				'sirelTD_is_bool', $overwrite);
		$this->assert_connection_to_the_db_exists(__FILE__,$line,
				$function_name);
// There's no point of checking the format of the $column_descriptions,
// because the location of the fault would be determined anyway and
// it would just add a bunch of string operations to the cost.
	} // ensure_table_existence_input_verification(...)

// If a table named $table_name does not exist, it is created. If it
// does exist and $overwrite==True, it is deleted and a new table
// is created. For a MySQL specific command like this:
//
//     CREATE TABLE awesome_table (n int, name text);
//
// The call would look like that:
// ensure_table_existence('awesome_table','n scty_int, name scty_txt');
//
// The scty_int and scty_txt are database independent,
// so called normalized, versions of the  database column types.
//
// The call to this method is not among the cheapest due to input
// verification and at least one database query.
	public function ensure_table_existence($table_name,$normalized_column_descriptions,
			$overwrite=False) {
		try {
			$this->ensure_table_existence_input_verification($table_name,
					$normalized_column_descriptions,$overwrite,
					__FUNCTION__,__LINE__);
			$native_column_descriptions=$this->convert_normalized_db_data_types_2_native(
					$normalized_column_descriptions);
			$this->apply_schema();
			$b=$this->skip_existence_checks_;
			$this->skip_existence_checks_=True;
			$b_create=True;
			if($this->table_exists($table_name)) {
				if($overwrite) {
					$this->delete_table($table_name);
				} else {
					$b_create=False;
				} // else
			} // if
			if ($b_create) {
				$stm='CREATE TABLE '.$table_name.
						' ('.$native_column_descriptions.');';
				$params=array();
				$this->exec_transaction($stm, $params);
			} // if
			$this->skip_existence_checks_=$b;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // ensure_table_existence(...)

// Converts the sirelDBgate->exec_transaction(...) output to a string.
// General usage scenario:
//
// $rows=$db->exec_transaction(...);
// $s=sirelDBgate::results2s($rows);
// echo $s;
	public static function results2s(&$array_of_exec_transaction_results) {
		$answer='';
		$ar=&$array_of_exec_transaction_results;
		try {
			sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
					'sirelTD_is_array',$ar);
			foreach($ar as $row) {
				foreach($row as $column) {
					$answer=$answer.$column.' | ';
				} // foreach
				$answer=$answer."\n----rowseparator------\n";
			} // foreach
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
		return $answer;
	} // results2s(...)


	function __destruct() {
	} // destructor

} // class sirelDBgate

// As the PHP code is single-threaded, it does not make sense to make
// more than one connection to a single database. So, connections to
// different databases can be used as  singletons.
// The sirelDBgate_pool is a pool of singletons.
class sirelDBgate_pool {
	private static $dbs_=array();

// The $database_descriptor is expected to be an instance of
// sirelDatabaseDescriptor
	public static function get_db(&$database_descriptor) {
		try {
			$hash_string=''.$database_descriptor->hostname_.'|||99999992'.
					$database_descriptor->port_.'|||;'.
					$database_descriptor->username_.';|||;'.
					$database_descriptor->db_name_;
			if(array_key_exists($hash_string,sirelDBgate_pool::$dbs_)) {
				return sirelDBgate_pool::$dbs_[$hash_string];
			}else {
				$db=new sirelDBgate();
				$db->connect($database_descriptor);
				sirelDBgate_pool::$dbs_[$hash_string]=$db;
				return $db;
			} // else
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.':');
		} // catch
	} // get_db

} // class sirelDBgate_pool


//---------------------------------------------------------
?>
