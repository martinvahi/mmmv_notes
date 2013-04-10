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
//-------------------------------------------------------------------------

require_once('sirel_core.php');

//-------------------------------------------------------------------------
// The class sirelLang is in a role of a namespace.
// (The PHP built in namespace support s__ks.)
//
// The sirelLang is a semirandom collection of functions that
// just seem to be missing from the PHP-5 standard Libraries or their
// standard version is too unconfortable to use.
class sirelLang {

//-------------------------------------------------------------------------
	// Returns a string that represents a type name.
	public static function type_2_s(&$var) {
		if(is_array($var)) {
			return 'sirelTD_is_array';
		} // if
		if(is_int($var)) {
			return 'sirelTD_is_int';
		} // if
		if(is_float($var)) {
			return 'sirelTD_is_float';
		} // if
		if(is_bool($var)) {
			return 'sirelTD_is_bool';
		} // if
		if(is_null($var)) {
			return 'sirelTD_is_null';
		} // if
		if(is_resource($var)) {
			return 'sirelTD_is_resource';
		} // if
		if(is_string($var)) {
			// If we're here, we've virtually implemented the is_mbstring(...)
			// or we have stumbled across a function, because there's no
			// such thing as a function instance in PHP userland and
			// the functions are looked up in a scope specific manner by
			// interpreting the string as a relative function search path.
			// http://php.net/manual/en/functions.variable-functions.php
			return 'sirelTD_is_mbstring';
		} // if
		if(is_numeric($var)) {
			// One should actually never reach this place, but reaching
			// this place is not that much of a fault, it's a kind of
			// "grey area", hence the logging in stead of an exception.
			sirelLogger::log(__FILE__,__LINE__,
				'is_numeric reaced. Value==|||'.$var);
			return 'sirelTD_is_numeric';
		} // if
		// The get_class has to be after the check
		// for strings, because otherwise a PHP
		// warning is displaied.
		$x=get_class($var);
		if($x!=NULL) {
			return 'sirelTD_is_class_'.$x;
		} // if
		sirelThrowLogicException(__FILE__, __LINE__,__CLASS__.'->'.
			__FUNCTION__.': Could not detect type for |||'.$var);
	}// type_2_s

//-------------------------------------------------------------------------
	// Throws a logic exception, if sirelLang::type_2_s($var)!=
	// $expected_type. Call example:
	// sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
	//         'sirelTD_is_mbstring',$my_array_candidate);
	public static function assert_type($file,$line,$a_class,
		$a_function,$s_commaseparated_list_of_expected_types,
		&$var,$s_error_message_complement='') {
		$ar_allowed_types=sirelLang::commaseparated_list_2_array($s_commaseparated_list_of_expected_types);
		$b_thorw=True;
		$s_type=sirelLang::type_2_s($var);
		$i_len=count($ar_allowed_types);
		$s_allowed_type=NULL;
		for($i=0;$i<$i_len;$i++) {
			$s_allowed_type=$ar_allowed_types[$i];
			if(sirelLang::str1EqualsStr2($s_type, $s_allowed_type)) {
				$b_thorw=False;
			} // if
		} // for
		if($b_thorw) {
			sirelThrowLogicException($file, $line,
				$a_class.'->'.$a_function.': Type mismatch. '.
				'The list of allowed types in the '.
				'sirelLang::type_2_s output format is '.
				$s_commaseparated_list_of_expected_types.
				', but the variable had a type of '.$s_type.'. '.
				'The variable had a value of '.$var.'. '.
				$s_error_message_complement);
		} // if
	} // assert_type

//-------------------------------------------------------------------------
	public static function assert_type_is_a_numeric($file,$line,$a_class,
		$a_function,&$var,$error_message_complement='') {
		$x=sirelLang::type_2_s($var);
		if($x!='sirelTD_is_int') {
			if($x!='sirelTD_is_float') {
				sirelThrowLogicException($file, $line,
					$a_class.'->'.$a_function.': Type mismatch. The required '.
					'sirelLang::type_2_s(...) output is '.
					'\'sirelTD_is_int\' or \'sirelTD_is_float\', '.
					'but the actual sirelLang::type_2_s(...) output is '.$x.'. '.
					'The variable had a value of '.$var.'. '.
					$error_message_complement);
			} // if
		} // if
	} // assert_type

//-------------------------------------------------------------------------
	// This function has been 99% written by a person, who
	// call him/her self Moriyoshi.
	// http://osdir.com/ml/php.internationalization/2003-05/msg00004.html
	public static function mb_trim(&$str, $spc='\t\s') {
		// Input verification omitted for speed.
		// TODO: test with \n and \r added to the space definition.
		try {
			return mb_ereg_replace("[$spc]*$", '',
				mb_ereg_replace("^[$spc]*", '', $str));
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // mb_trim
//-------------------------------------------------------------------------

	// Returns a string. Applies the mb_ereg_replace till the
	// string does not change any more or the maximum allowed
	// number of replacement iterations is reached.
	public static function mb_ereg_replace_till_no_change(&$s_regex,
		&$s_substitution,&$s_haystack,
		$i_max_number_of_iterations) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				// Due to dependencies the use of the
				// sirelLang::assert_type here introduces an infinite recursion.
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_regex);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_substitution);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_haystack);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',
					$i_max_number_of_iterations);
				if($i_max_number_of_iterations<1) {
					sirelBubble(__FILE__,__LINE__,$err_exception,
						__CLASS__.'->'.__FUNCTION__.
						': $i_max_number_of_iterations == '.
						$i_max_number_of_iterations.' < 1');
				} // if
			} // if
			$s_1=$s_haystack;
			$s_2=NULL;
			$i_n=0;
			$b_go_on=True;
			if(sirelSiteConfig::$debug_PHP) {
				while($b_go_on) {
					$s_2=mb_ereg_replace($s_regex, $s_substitution, $s_1);
					if(sirelLang::str1EqualsStr2($s_1, $s_2)) {
						$b_go_on=False;
					} else {
						$s_1=$s_2; // Using a reference here introduces a flaw.
					} // else
					$i_n++;
					if($i_max_number_of_iterations<=$i_n) {
						$b_go_on=False;
						sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.
							': $i_max_number_of_iterations=='.
							$i_max_number_of_iterations.
							' number of iterations have been performed,'.
							'but that means that either the '.
							'regular expression allows infinite number '.
							'substitution iterations or the value of the '.
							'$i_max_number_of_iterations has been set '.
							'too low.');
					} // if
				} // while
			} else {
				while($b_go_on) {
					$s_2=mb_ereg_replace($s_regex, $s_substitution, $s_1);
					if(sirelLang::str1EqualsStr2($s_1, $s_2)) {
						$b_go_on=False;
					} else {
						$s_1=$s_2; // Using a reference here introduces a flaw.
					} // else
					$i_n++;
					if($i_max_number_of_iterations<=$i_n) {
						$b_go_on=False;
					} // if
				} // while
			} // else
			return $s_2;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // mb_ereg_replace_till_no_change

//-------------------------------------------------------------------------
	// Example of (44.5,55]:
	// sirelLang::assert_range(44.5,'<',$x,'<=',55,'$x');
	//
	// An example of (-infinity,5]:
	// sirelLang::assert_range(42,'*',$x,'<=',5,'$x');
	//
	// An example of [24,infinity):
	// sirelLang::assert_range(24,'<=',$x,'*',42,'$x');
	public static function assert_range($i_or_fd_low,$s_mark1,$x,
		$s_mark2,$i_or_fd_high,$s_x_name) {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring', $s_mark1);
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring', $s_mark2);
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring', $s_x_name);
			sirelLang::assert_type_is_a_numeric(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,$i_or_fd_low);
			sirelLang::assert_type_is_a_numeric(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,$i_or_fd_high);
			$b_i_low_is_in_use=False;
			$b_i_high_is_in_use=False;
			if($s_mark1!='*') {
				$b_i_low_is_in_use=True;
				if($s_mark1!='<') {
					if($s_mark1!='<=') {
						throw new Exception('$s_mark1==\''.$s_mark1.
							'\', but it is allowed to be only '.
							'\'<\' or \'<=\' or \'*\'.');
					} // if
				} // if
			} // if
			if($s_mark2!='*') {
				$b_i_high_is_in_use=True;
				if($s_mark2!='<') {
					if($s_mark2!='<=') {
						throw new Exception('$s_mark2==\''.$s_mark2.
							'\', but it is allowed to be only '.
							'\'<\' or \'<=\' or \'*\'.');
					} // if
				} // if
			} // if
			if($b_i_low_is_in_use&&$b_i_high_is_in_use) {
				if($i_or_fd_high<$i_or_fd_low) {
					throw new Exception('$i_or_fd_high=='.$i_or_fd_high.
						' < $i_or_fd_low=='.$i_or_fd_low);
				} // if
			} // if
		} // if debug
		if($s_mark1!='*') {
			if($s_mark1=='<') { // $i_or_fd_low < $x
				if($x<=$i_or_fd_low) {
					throw new Exception($s_x_name.'=='.$x.
						' <= $i_or_fd_low=='.$i_or_fd_low);
				} // if
			} else { // $i_or_fd_low <= $x
				if($x<$i_or_fd_low) {
					throw new Exception($s_x_name.'=='.$x.
						' < $i_or_fd_low=='.$i_or_fd_low);
				} // if
			} // else
		} // if
		if($s_mark2!='*') {
			if($s_mark2=='<') { // $x < $i_or_fd_high
				if($i_or_fd_high<=$x) {
					throw new Exception('$i_or_fd_high=='.$i_or_fd_high.
						' <= $x=='.$x);
				} // if
			} else { // $x <= $i_or_fd_high
				if($i_or_fd_high<$x) {
					throw new Exception('$i_or_fd_high=='.$i_or_fd_high.
						' < $x=='.$x);
				} // if
			} // else
		} // if
	} // assert_range

//-------------------------------------------------------------------------
	// It does not return anything, but it does alter the string
	// typed fields of the $a_hashtable
	public static function trim_all_string_fields(&$a_PHP_array_as_a_hashtable) {
		try {
			$x=array();
			$ar_keys=array_keys($a_PHP_array_as_a_hashtable);
			foreach($ar_keys as $a_key) {
				$elem=$a_PHP_array_as_a_hashtable[$a_key];
				$elem_type=sirelLang::type_2_s($elem);
				if($elem_type=='sirelTD_is_mbstring') {
					$s_n=sirelLang::mb_trim($elem);
					$a_PHP_array_as_a_hashtable[$a_key]=$s_n;
				} // if
			} // foreach
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // trim_all_string_fields

	// It duplicates the  mb_substr_count but with a difference
	// that it accepts also empty strings. So, unlike the
	// mb_substr_count, the  mb_count acts as a complete function.
	//
//	public static function mb_count($needle, &$haystack){
//		// Input verification omitted for speed.
//		try {
//			return mb_ereg_replace("[$spc]*$", '',
//					mb_ereg_replace("^[$spc]*", '', $str));
//		} catch (Exception $err_exception) {
//			sirelBubble(__FILE__,__LINE__,$err_exception,
//					__CLASS__.'->'.__FUNCTION__.': ');
//		} // catch
//	} // mb_count

//-------------------------------------------------------------------------
	// Returns a trimmed version of the string. Call example:
	// sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
	//         __LINE__,__CLASS__,__FUNCTION__,$variable_to_verify);
	public static function assert_is_string_nonempty_after_trimming($file,
		$line,$a_class, $a_function,&$var,$error_message_complement='') {
		sirelLang::assert_type_CSL_free($file, $line, $a_class, $a_function,
			'sirelTD_is_mbstring', $var, $error_message_complement);
		$s=sirelLang::mb_trim($var);
		if($s=='') {
			sirelThrowLogicException($file, $line,
				$a_class.'->'.$a_function.
				': String consisted of only spaces or tabs.');
		} // if
		return $s;
	} // assert_is_string_nonempty_after_trimming(...)

//-------------------------------------------------------------------------
	public static function assert_sirel_Memcached_is_in_use($file,$line,
		$class,$function) {
		if(sirelSiteConfig::$memcached_in_use!=True) { // Might be also NULL.
			sirelThrowLogicException($file, $line,$class.'->'.
				$function.': sirelSiteConfig::$memcached_in_use!=True');
		} // if
	} // assert_sirel_Memcached_is_in_use(...)

//-------------------------------------------------------------------------
	public static function assert_string_does_not_contain_substrings($file,$line,
		$class,$function,$a_string,$a_commaseparated_list_of_forbidden_strings) {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring',$a_string);
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring',
				$a_commaseparated_list_of_forbidden_strings);
		} // if
		$ar_forbidden_strings=sirelLang::commaseparated_list_2_array($a_commaseparated_list_of_forbidden_strings);
		mb_ereg_search_init($a_string);
		foreach($ar_forbidden_strings as $s_forbidden) {
			if(mb_ereg_search($s_forbidden)) {
				sirelThrowLogicException($file, $line,$class.'->'.$function.
					': string "'.$a_string.'" contained substring "'.$s_forbidden.'"');
			} // if
		} // foreach
	} // assert_string_does_not_contain_substrings

//-------------------------------------------------------------------------
	// A debugging function that converts an ordinary UTF-8 string
	// to a html-suitable form. It returns a string.
	public static function htmlize($a_string) {
		$answer='';
		try {
			sirelLang::assert_type_CSL_free(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
				'sirelTD_is_mbstring',$a_string);
			$answer=htmlentities($a_string, ENT_QUOTES,'UTF-8');
			$answer=str_replace("\n",'<br/>',$answer);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
		return $answer;
	} // htmlize


//-------------------------------------------------------------------------
	// It's the same as the assert_type, except that it's without
	// the support for the comma separated list of expected types, i.e.
	// accepts only one expected type, and it's meant to be used
	// only within the sirelLang.
	private static function assert_type_CSL_free($file,$line,$a_class,
		$a_function,$expected_type,&$var,$error_message_complement='') {
		$x=sirelLang::type_2_s($var);
		if($x!=$expected_type) {
			sirelThrowLogicException($file, $line,
				$a_class.'->'.$a_function.': Type mismatch. The required '.
				'sirelLang::type_2_s(...) output ||| is '.$expected_type.
				' but the actual sirelLang::type_2_s(...) output is '.$x.'. '.
				'The variable had a value of '.$var.'. '.
				$error_message_complement);
		} // if
	} // assert_type_CSL_free

//-------------------------------------------------------------------------
	// Always retunrs an array that has at least one element in it.
	//
	// If the $b_trim==True, all of the strings within the array are trimmed
	// according to the $s_trimming_regex. If the $s_trimming_regex==NULL,
	// tabs and spaces are trimmed. The value NULL is used for the
	// $s_trimming_regex due to speed considerations.
	public static function mb_explode(&$s_haystack,&$s_needle,
		$b_trim=False,$s_trimming_regex=NULL) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_haystack);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_needle);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_bool',$b_trim);
				if($s_trimming_regex!=NULL) {
					sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_trimming_regex);
				} // if
			} // if
			if($b_trim) {
				if(is_null($s_trimming_regex)) {
					// (^[\t\s]+)|([\t\s]+$)
					$s_trimming_regex='(^[\t\s]+)|([\t\s]+$)';
				} // if
			} // if
			//$s_1=sirelLang::mb_trim($s_haystack);
			$ar_out=array();
			$s_hay=$s_haystack;
			$b_go_on=True;
			$ar=NULL;
			$i_len=NULL;
			$s_leftside=NULL;
			$s_lc_emptystring='';
			if($b_trim) { // to get the if-statement outside of the loop
				$s_trimmed=NULL;
				while($b_go_on) {
					$ar=sirelLang::bisectStr($s_hay, $s_needle);
					$i_len=count($ar);
					if($i_len==1) {
						$b_go_on=False;
						$s_leftside=$ar[0];
					} else {
						$s_leftside=$ar[1];
						$s_hay=$ar[2];
					} // else
					$s_trimmed=sirelLang::mb_ereg_replace_till_no_change($s_trimming_regex,
						$s_lc_emptystring,$s_leftside,3);
					$ar_out[]=$s_trimmed;
				} // while
			} else {
				while($b_go_on) {
					$ar=sirelLang::bisectStr($s_hay, $s_needle);
					$i_len=count($ar);
					if($i_len==1) {
						$b_go_on=False;
						$s_leftside=$ar[0];
					} else {
						$s_leftside=$ar[1];
						$s_hay=$ar[2];
					} // else
					$ar_out[]=$s_leftside;
				} // while
			} // else
			return $ar_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	}// mb_explode

//-------------------------------------------------------------------------
	// Always retunrs an array that has at least one element in it.
	// The strings within the array are trimmed.
	public static function commaseparated_list_2_array(&$s_commaseparated_list) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
					'sirelTD_is_mbstring',$s_commaseparated_list);
			} // if
			$s_needle=',';
			$b_trim=True;
			$ar=sirelLang::mb_explode($s_commaseparated_list, $s_needle,
				$b_trim);
			$ar_out=array();
			$i_len=count($ar);
			$x_elem=NULL;
			$i_s_len=NULL;
			for($i=0;$i<$i_len;$i++) {
				$x_elem=$ar[$i];
				$i_s_len=mb_strlen($x_elem);
				if(0<$i_s_len) {
					$ar_out[]=$x_elem;
				} // if
			} // for
			return $ar_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	}// commaseparated_list_2_array

//-------------------------------------------------------------------------
	// Returns True, if the element_candidate is within the array.
	// Otherwise returns False.
	public static function array_contains_an_element($an_array,$element_candidate) {
		sirelLang::assert_type_CSL_free(__FILE__,__LINE__,__CLASS__,__FUNCTION__,
			'sirelTD_is_array',$an_array);
		$answer=False;
		foreach($an_array as $ar_elem) {
			if($ar_elem==$element_candidate) {
				$answer=True;
				break;
			} // if
		} // foreach
		return $answer;
	} // array_contains_an_element

//-------------------------------------------------------------------------
	public static function YAML2array($file_path) {
		sirelLang::assert_is_string_nonempty_after_trimming(__FILE__, __LINE__, __CLASS__,
			__FUNCTION__, $file_path);
		try {
			require_once('lib/spyc/spyc.php');
			return Spyc::YAMLLoad($file_path);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // YAML2array

//-------------------------------------------------------------------------
	// Returns a string representatopm of the JavaScript/Ruby
	// version of the boolean.
	public static function str1ContainsStr2(&$haystack_string,$needle_string,
		$index_of_the_first_haystack_character_included_into_the_search_starting_from_zero) {
		try {
			$srchpos=&$index_of_the_first_haystack_character_included_into_the_search_starting_from_zero;
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$haystack_string);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$needle_string);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',
					$srchpos);
			} // if
			$hay_len=mb_strlen($haystack_string);
			$needle_len=mb_strlen($needle_string);
			if(($needle_len==0)&&($hay_len==0)) { // Semantics: '' contains ''
				return True;
			} // if
			if($hay_len==0) {//Semantics: '' can't contain anything other than ''
				return False;
			} // if
			if(!(($srchpos+$needle_len)<=$hay_len)) {
				return False;
			} // if
			if($needle_len==0) {
				return True;
			} // if
			$x=mb_strpos($haystack_string, $needle_string,$srchpos);
			if(!is_bool($x)) {
				return True;
			} // if
			return False;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str1ContainsStr2


//-------------------------------------------------------------------------
	// Returns True, if $str1 is a substring of $str2 or $str2 is a
	// substring of $str1.
	public static function str1OrStr2ContainsOther(&$str1,&$str2) {
		try {
			$srchpos=&$index_of_the_first_haystack_character_included_into_the_search_starting_from_zero;
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$str1);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$str2);
			} // if
			if(sirelLang::str1ContainsStr2($str1, $str2, 0)) {
				return True;
			} // if
			if(sirelLang::str1ContainsStr2($str2, $str1, 0)) {
				return True;
			} // if
			return False;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str1OrStr2ContainsOther

//-------------------------------------------------------------------------
	public static function str1EqualsStr2(&$str1,$str2) {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring',$str1);
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring',$str2);
		} // if
		try {
			if(mb_strlen($str1)!=mb_strlen($str2)) {
				return False;
			}
			$answer=sirelLang::str1ContainsStr2($str1, $str2, 0);
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str1EqualsStr2

//-------------------------------------------------------------------------
	public static function boolean2str(&$b_subject_to_conversion) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_bool',
					$b_subject_to_conversion);
			} // if
			$answer;
			if($b_subject_to_conversion==True) $answer='t';
			else $answer='f';
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // boolean2str

//-------------------------------------------------------------------------
	// Returs a boolean value, if the $s_bool can be
	// interpreted as a boolean value. It throws an exception,
	// if the conversion fails. Empty strings trigger an exception.
	// Valid values are "true","false","trUe","faLse", i.e.
	// case does not matter, but spaces/tabs/linebreaks are not allowed.
	public static function str2boolean(&$s_subject_to_conversion) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',
					$s_subject_to_conversion);
			} // if
			$s=mb_convert_case($s_subject_to_conversion, MB_CASE_LOWER);
			$b_out=NULL;
			if(sirelLang::str1EqualsStr2($s,'t')==True) {
				$b_out=True;
				return $b_out;
			} // if
			if(sirelLang::str1EqualsStr2($s,'f')==True) {
				$b_out=False;
				return $b_out;
			} // if
			if(sirelLang::str1EqualsStr2($s,'true')==True) {
				$b_out=True;
				return $b_out;
			} // if
			if(sirelLang::str1EqualsStr2($s,'false')==True) {
				$b_out=False;
				return $b_out;
			} // if
			throw(new Exception('Failed to interpret string as a boolean. '.
				's_subject_to_conversion=="'.
				$s_subject_to_conversion.'".'));
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str2boolean

//-------------------------------------------------------------------------
	public static function generateMissingNeedlestring_t1(&$haystack_string) {
		try {
			$s_needle='∇'.mt_rand(0,999);
			$pos1;
			// The mb_strpos stops at the linebreak.
			$s_all=mb_ereg_replace('[\n\r]', '', $haystack_string);
			while(True) {
				$pos1=mb_strpos($s_all, $s_needle);
				if(is_bool($pos1)) {
					break;
				} // if
				$s_needle=($s_needle.'«').(mt_rand(0,999).'¬');
			} // while
			return $s_needle;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // generateMissingNeedlestring_t1

//-------------------------------------------------------------------------
	// Returns a string that starts with $needle_start_str, then
	// has at one or more $needle_middle_element-s and ends with
	// $needle_end_str.  The generateMissingNeedlestring_t2 is
	// computationally more expensive than the
	// sirelLang::generateMissingNeedlestring_t1 and the main
	// motivation for creating it is that sometimes it is necessary
	// to determine the characters that are used within the
	// generated needle string.
	public static function generateMissingNeedlestring_t2(&$haystack_string,
		$needle_start_str, $needle_middle_element, $needle_end_str) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$haystack_string);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$needle_start_str);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$needle_middle_element);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$needle_end_str);
				if((mb_strlen($needle_start_str)==0)||(mb_strlen($needle_middle_element)==0)||(mb_strlen($needle_end_str)==0)) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Empty strings are not allowed to be used for '.
						'composing the needle string.'.
						'$needle_start_str=="'.$needle_start_str.'" '.
						'$needle_middle_element=="'.$needle_middle_element.'" '.
						'$needle_end_str=="'.$needle_end_str.'" ');
				} // if
				// To avoid collisions at the extraction of the
				// generated needle string from a haystack that contains
				// expectedly different needles, the $needle_start_str,
				// the $needle_middle_element and the $needle_end_str
				// must not pairwise contain eachother. A graph with
				// 3 vertices has at most 3 edges. :-)
				if(sirelLang::str1OrStr2ContainsOther($needle_start_str, $needle_middle_element)) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'One string has anothr as its substring. '.
						'$needle_start_str=="'.$needle_start_str.'" '.
						'$needle_middle_element=="'.$needle_middle_element.'" ');
				} // if
				if(sirelLang::str1OrStr2ContainsOther($needle_start_str, $needle_end_str)) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'One string has anothr as its substring. '.
						'$needle_start_str=="'.$needle_start_str.'" '.
						'$needle_end_str=="'.$needle_end_str.'" ');
				} // if
				if(sirelLang::str1OrStr2ContainsOther($needle_end_str, $needle_middle_element)) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'One string has anothr as its substring. '.
						'$needle_end_str=="'.$needle_end_str.'" '.
						'$needle_middle_element=="'.$needle_middle_element.'" ');
				} // if
			} // if
			$s0=$needle_start_str;
			$s_needle_candidate=$s0.$needle_end_str;
			$pos1;
			// The mb_strpos stops at the linebreak.
			$s_all=mb_ereg_replace('[\n\r]', '', $haystack_string);
			while(True) {
				$pos1=mb_strpos($s_all, $s_needle_candidate);
				if(is_bool($pos1)) {
					break;
				} // if
				$s0=$s0.$needle_middle_element;
				$s_needle_candidate=$s0.$needle_end_str;
			} // while
			return $s_needle_candidate;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // generateMissingNeedlestring_t2

//-------------------------------------------------------------------------
	// If the $s_haystack==' welcome|||  to|||Mars' and
	// the $s_needle=='|||', then the sirelLang::bisectStr
	// bisects a the haystack to ' welcome' and '  to|||Mars'. It
	// returns an array, where array[0]==' welcome|||  to|||Mars',
	// array[1]==' welcome' and array[2]=='  to|||Mars'.
	//
	// If there's no delimiter, $s_needle, in the $s_haystack,
	// it returns an array, where the only element is the $s_haystack.
	// It returns NULL, if the $s_haystack==NULL.
	public static function bisectStr(&$s_haystack,&$s_needle) {
		try {
			// A trick here is that if $s_haystack=='',
			// ($s_haystack==NULL)==True, i.e. an empty string is
			// equivalent to NULL from PHP == operator point of view.
			if(is_null($s_haystack)) {
				return NULL;
			} // if
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_haystack);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_needle);
				$i_len=mb_strlen($s_needle);
				if($i_len==0) {
					// The idea is that it's not possible to determine,
					// how many empty strings have been concated
					// to string "A" before concating string "B"
					// to form a string like "AB".
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'The length of the $s_needle is 0, but '.
						'needle strings are not allowed to be '.
						'empty strings.');
				} // if
			} // if
			$ar_out=array();
			$ar_out[]=$s_haystack;
			$xx=mb_strpos($s_haystack, $s_needle);
			if(is_bool($xx)) {
				return $ar_out;
			} // if
			$s_first=&mb_substr($s_haystack,0,$xx);
			$s_last=&mb_substr($s_haystack,$xx+mb_strlen($s_needle));
			$ar_out[1]=&$s_first;
			$ar_out[2]=&$s_last;
			return $ar_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // bisectStr

//-------------------------------------------------------------------------
	// Applies the sirelLang::bisectStr N times and returns
	// an array of the prefix sides of the bisections. If it is
	// not possible to bisect the string N times, an exception is thrown.
	public static function snatchNtimes(&$haystack_string,&$needle_string,$n) {
		try {
			if($n<1) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'$n=='.$n.'<1');
			} // if
			$s_hay=$haystack_string;
			$modulus=$n%2;
			$ar_tmp;
			$ar_tmp1;
			$ar=array();
			if(2<=$n) {
				$nn=$n;
				if($modulus==1) {
					$nn=$nn-1;
				} // if
				$nnn=$nn/2;
				$i=0;
				for($i=0;$i<$nnn;$i++) {
					$ar_tmp=sirelLang::bisectStr($s_hay, $needle_string);
					if(count($ar_tmp)<3) {
						sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'count($ar_tmp)=='.count($ar_tmp).'<3 '.
							'$haystack_string=='.$haystack_string.
							'$needle_string=='.$needle_string.' $n=='.$n.' ');
					} // if
					$ar[]=$ar_tmp[1];
					$ar_tmp1=sirelLang::bisectStr($ar_tmp[2], $needle_string);
					if(count($ar_tmp1)<3) {
						sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'count($ar_tmp1)=='.count($ar_tmp1).'<3 '.
							'$haystack_string=='.$haystack_string.
							' <\br>$needle_string=='.$needle_string.' $n=='.$n.
							' <br/>$ar_tmp[2]=='.$ar_tmp[2]);
					} // if
					$ar[]=$ar_tmp1[1];
					$s_hay=$ar_tmp1[2];
				} // for
			} // if
			if($modulus==1) {
				$ar_tmp=sirelLang::bisectStr($s_hay, $needle_string);
				if(count($ar_tmp)<3) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'count($ar_tmp)=='.count($ar_tmp).'<3 '.
						'$haystack_string=='.$haystack_string.
						'$needle_string=='.$needle_string.' $n=='.$n.' ');
				} // if
				$ar[]=$ar_tmp[1];
			} // if
			return $ar;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // snatchNtimes

//-------------------------------------------------------------------------
	public static function file2str($file_path) {
		$file_path=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
			__LINE__,__CLASS__,__FUNCTION__, $file_path);
		try {
			$first_char=mb_substr($file_path, 0, 1);
			if(!mb_ereg_match('/', $first_char)) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'Full path expected, but the received path candidate is '.
					$file_path.'.');
			} // if
			$answer;
			$fl=fopen($file_path, 'r');
			$answer = fread($fl, filesize($file_path));
			fclose($fl);
			if(is_bool($answer)) {
				throw new Exception('File reading for path '.
					$file_path.' failed.');
			} // if
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // file2str

//-------------------------------------------------------------------------
	public static function extractColumn($column_index_starting_from_0,
		&$array_of_rows) {
		sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
			__FUNCTION__,'sirelTD_is_array',$array_of_rows);
		try {
			$column=array();
			$ci=&$column_index_starting_from_0;
			foreach($array_of_rows as $row) {
				if(sirelSiteConfig::$debug_PHP) {
					sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$row);
				} // if
				if(count($row)<$ci) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'count($row)=='.count($row).'<$ci=='.$ci);
				}
				$column[]=$row[$ci];
			} // foreach
			return $column;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // extractColumn

//-------------------------------------------------------------------------
	public static function extractColumns($a_string_of_a_commaseparated_list_of_column_indices_starting_from_0,
		&$array_of_rows) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$array_of_rows);
				$a_string_of_a_commaseparated_list_of_column_indices_starting_from_0=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
					__LINE__,__CLASS__,__FUNCTION__, $a_string_of_a_commaseparated_list_of_column_indices_starting_from_0);
			} // if
			$ar_column_indices=sirelLang::commaseparated_list_2_array($a_string_of_a_commaseparated_list_of_column_indices_starting_from_0);
			$columns=array();
			$columns_of_a_singe_row;
			foreach($array_of_rows as $row) {
				if(sirelSiteConfig::$debug_PHP) {
					sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$row);
				} // if
				$columns_of_a_singe_row=array();
				foreach($ar_column_indices as $ci) {
					if(count($row)<$ci) {
						sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'count($row)=='.count($row).'<$ci=='.$ci);
					} // if
					$columns_of_a_singe_row[]=$row[$ci];
				} // foreach
				$columns[]=$columns_of_a_singe_row;
			} // foreach
			return $columns;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // extractColumns

//-------------------------------------------------------------------------
	private static function ht2ProgFTE_v1_impl_part_2(&$arht_in,
		&$string_to_substitute_single_pillars_within_the_ht_keys_and_values) {
		try {
			$s_triplepillar='|||';
			$s_emptystring='';
			$s_pillarsubst=&$string_to_substitute_single_pillars_within_the_ht_keys_and_values;
			$arht_s_out=array();
			$arht_s_out[]=(count($arht_in).$s_triplepillar).
				($s_pillarsubst.$s_triplepillar);
			$keys=array_keys($arht_in);
			$value;
			$s=NULL;
			$s_1=NULL;
			$s_regex_1='[|]{1}';
			// The preg_replace is not UTF-8 safe.
			foreach($keys as $key) {
				$s=mb_ereg_replace($s_regex_1, $s_pillarsubst, $key);
				if(is_bool($s)) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Pillar replacement failed. $key=="'.$key.
						'"  $s_trp=="'.$s_pillarsubst.'".');
				} // if
				$s_1=$s.$s_triplepillar;
				$arht_s_out[]=$s_1;
				$value=$arht_in[$key];
				$s=mb_ereg_replace($s_regex_1, $s_pillarsubst, $value);
				if(is_bool($s)) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Pillar replacement failed. $value=="'.$value.
						'"  $s_trp=="'.$s_pillarsubst.'".');
				} // if
				$s_1=$s.$s_triplepillar;
				$arht_s_out[]=$s_1;
			} // foreach
			$s_out=s_concat_array_of_strings($arht_s_out);
			return $s_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ht2ProgFTE_v1_impl_part_2

//-------------------------------------------------------------------------
	// The version 1 of the ProgFTE implementation is fundamentally flawed
	// and exists here only for backward compatibility reasons.
	//
	// If (Hash.new)["nice_key"]="Cariba|" and
	// the pillarSubstString=="baba", then the ProgFTE is
	//
	// 1|||baba|||"nice_key"|||Caribababa|||
	//
	// There is an issue, how to reverse-translate
	// the "bababa" part of the "Caribababa".
	// Should it be "Cari|ba" or "Cariba|".
	//
	// The good news is that one can distinguish
	// the version 1, of ProgFTE from the new one and simply improve
	// the ProgFTE libraries of the real world application,
	// without any need to convert saved data. The old version,
	// the one in this blog post, always starts with a number,
	// but the new version always starts with a letter "v",
	// like "v<format_version>".
	private static function ht2ProgFTE_v1_impl(&$arht_in) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__, 'sirelTD_is_array', $arht_in);
			} // if
			$keys=array_keys($arht_in);
			$value;
			$arht_s_all=array(); // only for a speed-hack
			foreach($keys as $key) {
				$value=$arht_in[$key];
				$arht_s_all[]=$key;
				$arht_s_all[]=$value;
			} // foreach
			$s_all=s_concat_array_of_strings($arht_s_all);
			$arht_s_all=array(); // To facilitate memory deallocation.
			$s_trpsubsts=sirelLang::generateMissingNeedlestring_t1($s_all);
			$s_progte=sirelLang::ht2ProgFTE_v1_impl_part_2($arht_in,$s_trpsubsts);
			return $s_progte;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ht2ProgFTE_v1_impl

//-------------------------------------------------------------------------
	// ProgFTE(Programmer Friendly Text Exchange) is a way to
	// serialize a hashtable that has strings as its keys and strings as
	// its values. The format in brief:
	// <number of hashtable entries>|||<triplepillars substitution string>|||<keyX>|||<valueX>|||<keyY>|||<valueY>|||etc.
	public static function ht2ProgFTE(&$a_hashtable) {
		try {
			if (sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__, 'sirelTD_is_array', $a_hashtable);
			} // if
			$s_progte=sirelLang::ht2ProgFTE_v1_impl($a_hashtable);
			return $s_progte;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ht2ProgFTE

//-------------------------------------------------------------------------
	// ht2ProgFTE application
	public static function htOfht_2ProgFTE(&$hashtable_of_hashtables) {
		try {
			$keys=array_keys($hashtable_of_hashtables);
			$elem_ht;
			$arht_sprogftes=array();
			foreach($keys as $key) {
				$elem_ht=$hashtable_of_hashtables[$key];
				$arht_sprogftes[$key]=sirelLang::ht2ProgFTE($elem_ht);
			} // foreach
			$s_progte=sirelLang::ht2ProgFTE($arht_sprogftes);
			return $s_progte;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // htOfht_2ProgFTE

//-------------------------------------------------------------------------
	public static function ProgFTE2ht(&$a_string) {
		try {
			$s_singlepillar='|';
			$s_triplepillar='|||';
			$ar1=sirelLang::snatchNtimes($a_string,$s_triplepillar, 2);
			$arht_length=(int)$ar1[0];
			$s_trp_regex=&$ar1[1];
			$ar=array();
			if($arht_length<1) {
				return $ar;
			} // if
			$i2=($arht_length+1)*2;
			$ar2=sirelLang::snatchNtimes($a_string,$s_triplepillar, $i2);
			$i1=0;
			$s_key=null;
			$s_value=null;
			// The preg_replace is not UTF-8 safe.
			for($i1=1;$i1<=$arht_length;$i1++) {
				$s_key=mb_ereg_replace($s_trp_regex,$s_singlepillar, $ar2[$i1*2]);
				$s_value=mb_ereg_replace($s_trp_regex,$s_singlepillar, $ar2[$i1*2+1]);
				$ar[$s_key]=$s_value;
			} // while
			return $ar;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.
				': $a_string=='.$a_string);
		} // catch
	} // ProgFTE2ht

//-------------------------------------------------------------------------
	// The hashtable is the PHP array. The problem is that
	// as of PHP 5.x the ScriptKiddie-mentality design of the PHP
	// does not allow the standard associative hashtable to have a
	// standard element removal function that would remove an
	// array entry by specifying an array key. Nice job by the architect!!!
	// And yes, one understands, that this implementation here beutifully
	// summarizes multiple stupidities within the PHP 5.x: lack of native
	// UTF-8 support, the ht issues, lack of type checks (I probably missed
	// something.)
	//
	// It's OK to call this version of removal function in cases, where
	// the key actually does not exist in the hashtable. However, there
	// is an assumption that all of the keys are of mb_string type.
	public static function remove_from_ht($a_key,&$a_hashtable) {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_mbstring',$a_key);
			sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
				__FUNCTION__,'sirelTD_is_array',$a_hashtable);
		} // if
		try {
			if(!array_key_exists($a_key,$a_hashtable)) {
				return;
			} // if
			// Yes, now comes the sluggish part!!!!
			$keys=array_keys($a_hashtable);
			$arht_new=array();
			foreach($keys as $a_key_in_ht) {
				if(!sirelLang::str1EqualsStr2($a_key,$a_key_in_ht)) {
					$arht_new[$a_key_in_ht]=$a_hashtable[$a_key_in_ht];
				} // if
			} // for
			$a_hashtable=$arht_new;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // remove_from_ht

//-------------------------------------------------------------------------
	// http://mathworld.wolfram.com/SetDifference.html
	// Hashtable keys are treated as set elements.
	// If $arht_A represents set A and $arht_B represents set B, then
	// the function set_difference returns a hashtable that represents
	// A\B.
	public static function set_difference(&$arht_A,&$arht_B) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_A);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_B);
			} // if
			$arht_diff=array();
			$arht_A_keys=array_keys($arht_A);
			foreach ($arht_A_keys as $key_A) {
				if(!array_key_exists($key_A, $arht_B)) {
					$arht_diff[$key_A]=$arht_A[$key_A];
				} // if
			} // foreach
			return $arht_diff;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_difference

//-------------------------------------------------------------------------
	// http://mathworld.wolfram.com/SymmetricDifference.html
	// Hashtable keys are treated as set elements.
	// If $arht_A represents set A and $arht_B represents set B, then
	// the function set_symmetric_difference returns a hashtable
	// that represents  (A\B)U(B\A).
	public static function set_symmetric_difference(&$arht_A,&$arht_B) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_A);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_B);
			} // if
			$arht_diff_1=sirelLang::set_difference($arht_A, $arht_B);
			$arht_diff_2=sirelLang::set_difference($arht_B, $arht_A);
			$arht_symmetric_diff=array_merge($arht_diff_1, $arht_diff_2);
			return ht_symmetric_diff;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_symmetric_difference

//-------------------------------------------------------------------------
	// http://mathworld.wolfram.com/Intersection.html
	// Hashtable keys are treated as set elements.
	// If $arht_A represents set A and $arht_B represents set B, then
	// the function set_intersection_ht returns a hashtable
	// that contains only those keys that are present
	// in both of the hashtables.
	//
	// For arrays that have mb_strings as elements, one
	// should use sirelLang::set_intersection_ar_of_mbstrings
	public static function set_intersection_ht(&$arht_A,&$arht_B) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_A);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_B);
			} // if
			$arht_intersection=array();
			$arht_A_keys=array_keys($arht_A);
			foreach ($arht_A_keys as $key_A) {
				if (array_key_exists($key_A, $arht_B)==True) {
					$arht_intersection[$key_A]=$arht_B[$key_A];
				} // if
			} // foreach
			return $arht_intersection;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_intersection_ht

//-------------------------------------------------------------------------
	// http://mathworld.wolfram.com/Intersection.html
	public static function set_intersection_ar_of_mbstrings(&$ar_A,&$ar_B) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$ar_A);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$ar_B);
				foreach ($ar_A as $x) {
					sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$x);
				} // foreach
				foreach ($ar_B as $x) {
					sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$x);
				} // foreach
			} // if
			$ar_intersection=array();
			foreach ($ar_A as $s_a) {
				foreach ($ar_B as $s_b) {
					if(sirelLang::str1EqualsStr2($s_a,$s_b)) {
						array_push($ar_intersection,''.$s_a);
					} // if
				} // foreach
			} // foreach
			return $ar_intersection;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_intersection_ar_of_mbstrings

//-------------------------------------------------------------------------
	public static function descape(&$a_string) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$a_string);
			} // if
			$s_0=mb_ereg_replace('[\\\\]"', '"',$a_string);
			$s_1=mb_ereg_replace("[\\\\]'", '\'',$s_0);
			$s_0=mb_ereg_replace('[\\\\][\\\\]', '\\',$s_1);
			return $s_0;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // descape

//-------------------------------------------------------------------------
	// Returns a sirelPair, where a_pair->a_==True, if the operation
	// failed and a_pair->a_==False, if the operation succeeded. If the
	// operation succeeded, the
	// a_pair->b_==<The value in the PHP floating point type>.
	// Only the "." is accepted as a floating point delimiter. The
	// $a_string will be trimmed prior to processing.
	public static function str2float($a_string) {
		try {
			// TODO: refactor it and its client code so
			// that the str2float a sirelOP instance.
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring', $a_string, '');
			} // if
			$a_pair=new sirelPair();
			$a_pair->a_=True;
			$s0=sirelLang::mb_trim($a_string);
			if(mb_strlen($s0)==0) {
				return $a_pair;
			} // if
			$b_negative=False;
			$s1=$s0;
			if(1<mb_strlen($s0)) {
				$s_minus=mb_substr($s0,0,1);
				if(sirelLang::str1EqualsStr2($s_minus,'-')) {
					$b_negative=True;
					$s1=mb_substr($s0,1);
				} // if
			} // if
			// floatval('4.5') returns 4.5, but
			// floatval('4,5') returns 4 in stead of throwing an exception.
			// 'x' in stead of '.' is for distinquishing '4z5' from '4.5'
			$s0=mb_ereg_replace('[^.\d]','x', $s1);
			if(0<mb_substr_count($s0,'x')) {
				return $a_pair;
			} // if
			if(1<mb_substr_count($s0,'.')) {
				// For cases like "1..1" and "1.3.".
				return $a_pair;
			} // if
			$fl=floatval($s0);
			if($b_negative) {
				$fl=$fl*(-1);
			} // if
			$a_pair->b_=$fl;
			$a_pair->a_=False;
			return $a_pair;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str2float

//-------------------------------------------------------------------------
	// Changes $a_string syntax from ordinary string to a regex string.
	public static function mb_str2regexstr($a_string) {
		try {
			$s1=$a_string;
			// The "missing needle" generation part is due to collisions that
			// would occur due to the fact that the regex
			// syntax uses square brackets and backslashes.
			$arht_rpls=array();
			$arht_rpls['\\']=sirelLang::generateMissingNeedlestring_t2($s1,
				'sss','m','endd');

//			$s0=mb_ereg_replace('[\\\]', '[\\\]', $s1); // Wow, what a quirk.
//			$s1=mb_ereg_replace('[\\[]', '[\\[]', $s0);
//			$s0=mb_ereg_replace('[\\]]', '[\\]]', $s1);
//			$s1=mb_ereg_replace('[(]', '[(]', $s0);
//			$s0=mb_ereg_replace('[)]', '[)]', $s1);
//			$s1=mb_ereg_replace('[.]', '[.]', $s0);
//			$s0=mb_ereg_replace('[$]', '[$]', $s1);
//			$s1=mb_ereg_replace('[\^]', '[\^]', $s0);
//			$s0=mb_ereg_replace('[?]', '[?]', $s1);
//			$s1=mb_ereg_replace('[*]', '[*]', $s0);
//			$s0=mb_ereg_replace('[+]', '[+]', $s1);
//			$s1=mb_ereg_replace('[-]', '[-]', $s0);
//			$s0=mb_ereg_replace('[\t]', '[\t]', $s1);
//			$s1=mb_ereg_replace('[\n]', '[\n]', $s0);
//			$s0=mb_ereg_replace('[\r]', '[\r]', $s1);
//			$s1=mb_ereg_replace('[{]', '[{]', $s0);
//			$s0=mb_ereg_replace('[}]', '[}]', $s1);
			// TODO: complete it. The Raudrohi JavaScript library
			// already has a fucntion like that.
			return $s0;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // mb_str2regexstr

//-------------------------------------------------------------------------
	// It uses a reference for the $s_haystack, because this
	// function is extensively used in searchstree generation.
	public static function str2array_of_characters(&$s_haystack) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_haystack);
			} // if
			$ar_out=array();
			$i_ar_outlen=mb_strlen($s_haystack);
			$s=NULL;
			for ($i = 0; $i <$i_ar_outlen; $i++) {
				$s=mb_substr($s_haystack, $i, 1);
				array_push($ar_out, $s);
			} // for
			return $ar_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str2array_of_characters

//-------------------------------------------------------------------------
	// It's for facilitating instance reuse.
	public static function get_equivalent_or_store(&$x_instance,
		&$arht_storage) {
		try {
			$s_hash=serialize($x_instance);
			$b=array_key_exists($s_hash, $arht_storage);
			$x_out=NULL;
			if($b===True) {
				$x_out=&$arht_storage[$s_hash];
			} else {
				$arht_storage[$s_hash]=&$x_instance;
				$x_out=&$x_instance;
			} // else
			return $x_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_equivalent_or_store

//-------------------------------------------------------------------------
	// Returns a new array.
	public static function convert_all_strings_in_array_to_lowercase(&$ar) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$ar);
				foreach ($ar as $s_tmp) {
					sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_tmp);
				} // foreach
			} // if
			$ar_out=array();
			$i=0;
			$i_len=count($ar);
			$s1=NULL;
			$s2=NULL;
			for($i=0;$i<$i_len;$i++) {
				$s1=$ar[$i];
				$s2=mb_strtolower($s1);
				array_push($ar_out, $s2);
			} // for
			return $ar_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // convert_all_strings_in_array_to_lowercase

//-------------------------------------------------------------------------
	// A word "sindex" stands for separator index.
	// One can read more about separator indices from
	// http://urls.softf1.com/a1/krl/frag4_array_indexing_by_separators/
	//
	// Explanation by pseudo-example:
	// sirelLang::bisect_by_sindex('abc',0) ->    ar[0]=='',    ar[1]=='abc'
	// sirelLang::bisect_by_sindex('abc',1) ->    ar[0]=='a',   ar[1]=='bc'
	// sirelLang::bisect_by_sindex('abc',3) ->    ar[0]=='abc', ar[1]==''
	//
	// The keys of the array-hashtable are integers in stead of strings
	// due to speed considerations.
	public static function ar_bisect_by_sindex(&$ar_or_s,$i_separator) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring,sirelTD_is_array',$ar_or_s);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_separator);
			} // if
			if($i_separator<0) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'$i_separator == '.$i_separator.' < 0');
			} // if
			$s_type=sirelLang::type_2_s($ar_or_s);
			$i_len=NULL;
			$ar_in=NULL;
			$s_in=NULL;
			$b_array_mode=False;
			if($s_type=='sirelTD_is_array') {
				$b_array_mode=True;
				$ar_in=&$ar_or_s;
				$i_len=count($ar_in);
				if($i_len<$i_separator) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'length(<input array>) == '.$i_len.
						' < $i_separator == '.$i_separator);
				} // if
			} else { // $s_type=='sirelTD_is_mbstring'
				$s_in=&$ar_or_s;
				$i_len=mb_strlen($s_in);
				if($i_len<$i_separator) {
					sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'length(<input string>) == '.$i_len.
						' < $i_separator == '.$i_separator);
				} // if
			} // if
			$i_len_left=$i_separator;
			$i_len_right=$i_len-$i_separator;
			$x_left=NULL;
			$x_right=NULL;
			if($b_array_mode) {
				$x_left=array();
				$x_elem=NULL;
				for($i=0;$i<$i_len_left;$i++) {
					$x_elem=$ar_in[$i];
					array_push($x_left,$x_elem);
				} // for
				$x_right=array();
				$x_elem=NULL;
				for($i=$i_separator;$i<$i_len;$i++) {
					$x_elem=$ar_in[$i];
					array_push($x_right,$x_elem);
				} // for
			} else { // string mode
				if($i_len_left==0) {
					$x_left=utf8_encode('');
				} else {
					$x_left=mb_substr($s_in, 0,$i_len_left);
				} // else
				if($i_len_right==0) {
					$x_right=utf8_encode('');
				} else {
					$x_right=mb_substr($s_in, $i_separator,$i_len_right);
				} // else
			} // else
			$arht_out=array();
			array_push($arht_out, $x_left);
			array_push($arht_out, $x_right);
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_bisect_by_sindex

//-------------------------------------------------------------------------
	// In more decent programming languages than the PHP
	// is, one would do something like this:
	//
	// my_UTF8_string="some"
	// my_UTF8_string[0]="c" # "some"->"come"
	//
	// But, in the PHP world, one has to use some sort of a function
	// like the sirelLang::s_set_char here is.
	public static function s_set_char(&$s_haystack,$i_char_index,$s_new_char) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_haystack);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_char_index);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_new_char);
			} // if
			if($i_char_index<0) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'All of the character indices in '.
					'strings are greater than or equal to 0, '.
					'but the ||| $i_char_index == '.$i_char_index);
			} // if
			if(mb_strlen($s_new_char)!=1) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'The $s_new_char is meant to consist of only '.
					'a single character, but the ||| '.
					'$s_new_char=='.$s_new_char);
			} // if
			$i_hay_len=mb_strlen($s_haystack);
			if(($i_hay_len-1)<$i_char_index) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'The length($s_haystack)=='.$i_hay_len.
					', but the $i_char_index == '.$i_char_index);
			} // if
			$ar_x=sirelLang::ar_bisect_by_sindex($s_haystack,$i_char_index);
			$s_left=&$ar_x[0];
			$s_x=&$ar_x[1];
			$s_separator_index=1;
			$ar_x1=sirelLang::ar_bisect_by_sindex($s_x,$s_separator_index);
			// $s_old_char=$ar_x1[0];
			$s_right=&$ar_x1[1];
			$s_out=NULL;
			$i_s_left_len=mb_strlen($s_left);
			$i_s_right_len=mb_strlen($s_right);
			// The next if-clause is a small speed improvement hack.
			//
			// Think of a situation, where the $i_s_left_len==999 and
			// the $i_s_right_len==3. If one were to write
			// $s_out=$s_left.$s_new_char.$s_right
			// Then one would allocate a temporary string,
			// $s_tmp=$s_left.$s_new_char, of length 999+1=1000
			// UTF-8 characters and then dismiss it after
			// concating it to the 3-character $s_right.
			// But, if one were to do it like: $s_tmp=$s_new_char.$s_left
			// and then $s_out=$s_right.$s_tmp, then the temporary
			// memory requirement would be only for 1+3=4 characters
			// and the likelyhood of CPU cache misses is smaller.
			if($i_s_left_len<$i_s_right_len) {
				$s_tmp=$s_left.$s_new_char;
				$s_out=$s_tmp.$s_right;
			} else {
				$s_tmp=$s_new_char.$s_right;
				$s_out=$s_left.$s_tmp;
			} // else
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_set_char

//-------------------------------------------------------------------------
	// In more decent programming languages than the PHP
	// is, one would do something like this:
	//
	// my_UTF8_string="some"
	// s_character=my_UTF8_string[0] # -> "s"
	//
	// But, in the PHP world, one has to use some sort of a function
	// like the sirelLang::s_get_char here is.
	public static function s_get_char(&$s_haystack,$i_char_index) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_haystack);
				sirelLang::assert_type_CSL_free(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_char_index);
			} // if
			if($i_char_index<0) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'All of the character indices in '.
					'strings are greater than or equal to 0, '.
					'but the ||| $i_char_index == '.$i_char_index);
			} // if
			$i_hay_len=mb_strlen($s_haystack);
			if(($i_hay_len-1)<$i_char_index) {
				sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'The length($s_haystack)=='.$i_hay_len.
					', but the $i_char_index == '.$i_char_index);
			} // if
			$ar_x=sirelLang::ar_bisect_by_sindex($s_haystack,$i_char_index);
			$s_x=&$ar_x[1];
			$ar_x1=sirelLang::ar_bisect_by_sindex($s_x,1);
			$s_char=&$ar_x1[0];
			return $s_char;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_get_char


//-------------------------------------------------------------------------
	public static function s_remove_all_spaces_tabs_linebreaks($s_in) {
		try {
			$s_1=mb_ereg_replace(' ', '', $s_in); // space
			$s_2=mb_ereg_replace('	', '', $s_1); // tab
			$s_1=mb_ereg_replace("\n", '', $s_2);
			$s_2=mb_ereg_replace("\r", '', $s_1);
			return $s_2;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_remove_all_spaces_tabs_linebreaks


//-------------------------------------------------------------------------
	public static function b_is_free_of_spaces_tabs_linebreaks($s_in) {
		try {
			$s_test=$s_in;
			$i_len_0=mb_strlen($s_test);
			// It's a fast-fast-fast, hurry-hurry-hurry hack.
			$s_2=sirelLang::s_remove_all_spaces_tabs_linebreaks($s_test);
			$b_is_stlfree=True;
			$i_len_1=mb_strlen($s_2);
			if($i_len_1!=$i_len_0) {
				$b_is_stlfree=False;
			} // if
			return $b_is_stlfree;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // b_is_free_of_spaces_tabs_linebreaks

//-------------------------------------------------------------------------
	public static function b_string_is_interpretable_as_a_positive_number($s_in,
		$b_true_for_int_false_for_float,
		$b_allow_comma_in_addition_to_the_point) {
		// TODO: test the PHP standard function, "is_numeric(...) and see,
		// if the standard function is faulty. If not, then may be it can
		// be used here.
		try {
			$b_is_a_number=False;
			$i_len_s_in=mb_strlen($s_in);
			$s_stlfree=sirelLang::s_remove_all_spaces_tabs_linebreaks(''.$s_in);
			$i_len_s_stlfree=mb_strlen($s_stlfree);
			if($i_len_s_in!=$i_len_s_stlfree) { // contained spacestabslbrs
				return $b_is_a_number;
			} // if
			if($i_len_s_stlfree==0) { // an empty string or only of stlrbs
				return $b_is_a_number;
			} // if
			$s_digitless=mb_ereg_replace('0|1|2|3|4|5|6|7|8|9', '', ''.$s_stlfree);
			$i_len_digitless=mb_strlen($s_digitless);
			if($i_len_digitless==0) { // an integer, which is also a float
				$b_is_a_number=True;
				return $b_is_a_number;
			} // if
			$b_int_required=$b_true_for_int_false_for_float;
			// It could be that $s_in=="." or $s_in=="..." or $s_in=="abba"
			if($b_int_required==True) {
				return $b_is_a_number; // === <not a number>
			} // if
			// Only floats below this line
			if($i_len_s_stlfree==$i_len_digitless) {
				//  The $s_in did not contain any digits at all.
				return $b_is_a_number;
			} // if
			if(1<$i_len_digitless) { // "." or "," is allowed, but ".." is not
				return $b_is_a_number;
			} // if
			if($s_digitless=='.') {
				$b_is_a_number=True;
				return $b_is_a_number;
			} // if
			if($b_allow_comma_in_addition_to_the_point==True) {
				if($s_digitless==',') {
					$b_is_a_number=True;
					return $b_is_a_number;
				} // if
			} // if
			return $b_is_a_number; // === <not a number>
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // b_string_is_interpretable_as_a_positive_number

//-------------------------------------------------------------------------
	public static function selftest() {
		try {
			$ar_test_results=array();
			return $ar_test_results;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest

} //class sirelLang

//-------------------------------------------------------------------------
// The whole reason for the existence of this wrapper class is
// that if the Memcached daemon becomes unaccessible
// duering the operation, then the PHP routines that interact with
// the Memcached daemon through this class can try to get by
// without using the Memcached.
//
// The wrapper class, sirelMemcached, is a singleton, because
// this way the web application creates only one connection to
// the Memcached per web browser sent request.
//
// From security point of view it might be useful to keep in mind
// that any application that has access to the Memcached daemon
// can read and overwrite anything stored to the daemon.
//
// This class is not thread-safe.
class sirelMemcached {

	private static $memcached_instance_;

//-------------------------------------------------------------------------
	// Implements a singleton pattern for a connection to the memcached
	// daemon. Returns NULL, if the memcached is not in use.
	// Retunrns the "raw" Memcached instance, if everything went well.
	private static function get_memcached() {
		// The current implementation assumes that there is only one thread per
		// page visit. This method has to be refactored, if that assumption
		// changes.
		try {
			if(!sirelSiteConfig::$memcached_in_use) {
				return NULL;
			} // if
			if(sirelMemcached::$memcached_instance_!=NULL) {
				return sirelMemcached::$memcached_instance_;
			}
			sirelMemcached::$memcached_instance_ = new Memcache;
			sirelMemcached::$memcached_instance_->connect(sirelSiteConfig::$memcached_host,
				sirelSiteConfig::$memcached_port);
			//
			// Some usage examples:
			// $s='blabla';
			// $memcache->set('lion',$s);
			// $s2=$memcache->get('lion');
			//
			//
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_memcached

//-------------------------------------------------------------------------
	private function __construct() {
		sirelLang::assert_sirel_Memcached_is_in_use(__FILE__,__LINE__,
			__CLASS__,__FUNCTION__);
		$x=sirelMemcached::get_memcached();
		if(is_null($x)) {
			sirelThrowLogicException(__FILE__, __LINE__,
				__CLASS__.' constructor: could not establish a '.
				'connection to the Memcached daemon.');
		} // if
	} // constructor

	private static $self_;

//-------------------------------------------------------------------------
	// Returns NULL, if an instance could not be created.
	// The idea is that if a connection to the Memcached daemon fails,
	// then the client code has an opportunity to do its job without
	// using the cache.
	public static function get_instance() {
		if(is_null($this->self_)) {
			try {
				$this->self_=new sirelMemcached();
			} catch (Exception $err_exception) {
				// It might be that the Memcached is not acessible.
				$this->self_=NULL;
			} // catch
		} // if
		return $this->self_;
	} // get_instance

//-------------------------------------------------------------------------
	// Returns True on success and False on failure.
	public function set($key,$value, $life_in_seconds_max=3600) {
		sirelLang::assert_sirel_Memcached_is_in_use(__FILE__,__LINE__,
			__CLASS__,__FUNCTION__);
		sirelLang::assert_type_CSL_free(__FILE__,__LINE__,__CLASS__,
			__FUNCTION__, 'sirelTD_is_int', $life_in_seconds_max);
		$success=False;
		try {
			sirelMemcached::$memcached_instance_->set($key,$value);
			$success=True;
		} catch (Exception $err_exception) {
			// It might be that the Memcached is not acessible.
		} // catch
		return $success;
	} // set

//-------------------------------------------------------------------------
	// Returns its value by modifying the sirelop_instance.
	public function get($key,&$sirelop_instance) {
		sirelLang::assert_sirel_Memcached_is_in_use(__FILE__,__LINE__,
			__CLASS__,__FUNCTION__);
		sirelOPInit($sirelop_instance);
		try {
			$sirelop_instance->value=sirelMemcached::$memcached_instance_->get($key);
			$sirelop_instance->sb_failure='f';
		} catch (Exception $err_exception) {
			// It might be that the Memcached is not acessible.
			$sirelop_instance->value=NULL;
		} // catch
	} // get

//-------------------------------------------------------------------------
	// Returns True on success and False on failure.
	public function delete($key) {
		sirelLang::assert_sirel_Memcached_is_in_use(__FILE__,__LINE__,
			__CLASS__,__FUNCTION__);
		$success=False;
		try {
			sirelMemcached::$memcached_instance_->delete($key);
			$success=True;
		} catch (Exception $err_exception) {
			// It might be that the Memcached is not acessible.
		} // catch
		return $success;
	} // delete

//-------------------------------------------------------------------------
} // class sirelMemcached
//-------------------------------------------------------------------------

?>
