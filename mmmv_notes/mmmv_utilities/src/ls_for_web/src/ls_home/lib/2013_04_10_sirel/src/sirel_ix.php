<?php
//=========================================================================
// Copyright (c) 2011, martin.vahi@softf1.com that has an
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
//=========================================================================
require_once('sirel_type_normalizations.php');

//-------------------------------------------------------------------------

// The class sirel_ix is a namespace for various hashtable, array
// and otherwise indexing related routines.
class sirel_ix {

//-------------------------------------------------------------------------
// There must be at least 2 arguments.
// The first argument has to be a hashtable and
	private static function verifications_1(&$arht_in,&$arht_funcargs) {
		try {
			$i_n_of_args=count($arht_funcargs);
			$s_key=NULL;
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$arht_in);
			if($i_n_of_args<2) {
				throw new Exception(' '.__CLASS__.'->'.__FUNCTION__.
						': This function takes at least '.
						'2 arguments, of the first one is '.
						'a hashtable and the rest are strings that '.
						'belong to the set of keys of the '.
						'hashtable. func_num_args()=='.$i_n_of_args);
			} // if
			// The $arht_funcargs[0]==$arht_in, hence
			// the $i=1; in stead of the $i=0;
			for($i=1;$i<$i_n_of_args;$i++) {
				$s_key=$arht_funcargs[$i];
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_key);
			} // for
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verifications_1

//-------------------------------------------------------------------------
	// There must be at least 2 arguments.
	// The first argument has to be a hashtable and the
	// rest of the arguments are the keys.
	public static function arht_has_keys(&$arht_in) {
		try {
			$arht_funcargs=func_get_args();
			$i_n_of_args=func_num_args();
			$s_key=NULL;
			if(sirelSiteConfig::$debug_PHP) {
				sirel_ix::verifications_1($arht_in,$arht_funcargs);
			} // if
			$b_out=True;
			// The $arht_funcargs[0]==$arht_in, hence
			// the $i=1; in stead of the $i=0;
			for($i=1;$i<$i_n_of_args;$i++) {
				$s_key=$arht_funcargs[$i];
				$b_out=$b_out&&array_key_exists($s_key, $arht_in);
				if($b_out==False) {
					$i=$i_n_of_args; // ==break in a conservative manner
				} // if
			} // for
			return $b_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_has_keys

//-------------------------------------------------------------------------
	// There must be at least 2 arguments.
	// The first argument has to be a hashtable and
	// rest of the arguments are the keys.
	// It throws, if any of the keys is missing from the $arht_in.
	public static function assert_arht_keys(&$arht_in) {
		try {
			$arht_funcargs=func_get_args();
			$i_n_of_args=func_num_args();
			$s_key=NULL;
			if(sirelSiteConfig::$debug_PHP) {
				sirel_ix::verifications_1($arht_in,$arht_funcargs);
			} // if
			$b_ok=True;
			// The $arht_funcargs[0]==$arht_in, hence
			// the $i=1; in stead of the $i=0;
			for($i=1;$i<$i_n_of_args;$i++) {
				$s_key=$arht_funcargs[$i];
				if(!array_key_exists($s_key, $arht_in)) {
					throw new Exception('The key "'.$s_key.'" is '.
							'missing from the $arht_in.');
				} // if
			} // for
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // assert_arht_keys

//-------------------------------------------------------------------------
	// Returns a hashtable of integers, where the keys are the same
	// as in the $arht_in. For example:
	//
	public static function arht_of_arht_2_arht_of_elemcounts(&$arht_in) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				foreach ($arht_in as $x_elem) {
					sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
							__FUNCTION__,'sirelTD_is_array',$x_elem);
				} // foreach
			} // if
			$arht_out=array();
			$ar_keys=array_keys($arht_in);
			$i_len=count($ar_keys);
			$x_key=NULL;
			for($i=0;$i<$i_len;$i++) {
				$x_key=$ar_keys[$i];
				$arht_out[$x_key]=count($arht_in[$x_key]);
			} // for
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_of_arht_2_arht_of_elemcounts

//-------------------------------------------------------------------------
	// Returns a hashtable, where the values of the $arht_in
	// are the keys and the keys of the $arht_in are the values.
	//
	// It's possible that the $arht_in has collisions among
	// its values. In that case the output hashtable will
	// have less key-value pairs than the $arht_in.
	public static function arht_swap_keys_and_values(&$arht_in) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$arht_in);
			} // if
			$arht_out=array();
			$ar_keys_in=array_keys($arht_in);
			$x_value_in=NULL;
			foreach ($ar_keys_in as $x_key_in) {
				$x_value_in=$arht_in[$x_key_in];
				$arht_out[$x_value_in]=$x_key_in;
			} // foreach
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_swap_keys_and_values

//-------------------------------------------------------------------------

	private static function arht_to_s_mode_debug_1(&$arht_in) {
		try {
			$s_out='';
			$ar_keys=array_keys($arht_in);
			$i_len=count($ar_keys);
			$x_key=NULL;
			$x_value=NULL;
			$s_type=NULL;
			$s_line='';
			for($i=0;$i<$i_len;$i++) {
				$x_key=$ar_keys[$i];
				$x_value=$arht_in[$x_key];
				$s_line=sirelLang::type_2_s($x_key).' '.$x_key.' ';
				$s_line=$s_line.sirelLang::type_2_s($x_value).' '.$x_value;
				$s_out=$s_out.$s_line."\n";
			} // for
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_to_s_mode_debug_1

//-------------------------------------------------------------------------
	// Returns a string representation of a hashtable.
	// For a structured formats one might be interested in:
	//     sirelLang::ht2ProgFTE
	//             and
	//     sirelLang::ProgFTE2ht
	public static function arht_to_s(&$arht_in,$s_output_format='debug_1') {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$arht_in);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_output_format);
			} // if
			$s_out='';
			switch ($s_output_format) {
				case 'debug_1':
					$answer='A';
					$s_out=sirel_ix::arht_to_s_mode_debug_1($arht_in);
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_output_format=='.$s_output_format.'.');
					break;
			} // switch
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_to_s

//-------------------------------------------------------------------------
	// Takes an array of hashtables and returns a hashtable of strings,
	// where the keys are row numbers in string format.
	public static function ar_of_arht_2_arht_of_progftes(&$ar_of_arht_in) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$ar_of_arht_in);
			} // if
			$arht_out=array();
			$i_len=count($ar_of_arht_in);
			$arht_row=NULL;
			$s_1=NULL;
			for($i=0;$i<$i_len;$i++) {
				$arht_row=$ar_of_arht_in[$i];
				$s_1=sirelLang::ht2ProgFTE($arht_row);
				$arht_out[strval($i)]=$s_1;
			} // for
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_of_arht_2_arht_of_progftes

//-------------------------------------------------------------------------
} // sirel_ix


?>

