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
require_once('sirel_type_normalizations.php');

// ---------------------------------------------------------

class sirel_math_boolean {

//--------------------------------------------------------------------
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
				if(!array_key_exists($s_key, $arht_in)) {
					throw new Exception(' '.__CLASS__.'->'.__FUNCTION__.
							'The input array does not contain a '.
							'key that equals with "'.$s_key.'".');
				} // if
			} // for
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verifications_1

//--------------------------------------------------------------------
// There must be at least 2 arguments.
// The first argument has to be a hashtable and
	public static function conjunction_arht(&$arht_in) {
		try {
			$arht_funcargs=func_get_args();
			$i_n_of_args=func_num_args();
			$s_key=NULL;
			if(sirelSiteConfig::$debug_PHP) {
				sirel_math_boolean::verifications_1($arht_in,$arht_funcargs);
			} // if
			$b_or_sb=NULL;
			$b_out=True;
			// The $arht_funcargs[0]==$arht_in, hence
			// the $i=1; in stead of the $i=0;
			for($i=1;$i<$i_n_of_args;$i++) {
				$s_key=$arht_funcargs[$i];
				$b_or_sb=$arht_in[$s_key];
				$b_out=$b_out&&sirel_type_normalizations::to_b($b_or_sb);
				if($b_out==False) {
					$i=$i_n_of_args; // ==break in a conservative manner
				} // if
			} // for
			return $b_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // conjunction_arht

//--------------------------------------------------------------------
// There must be at least 2 arguments.
// The first argument has to be a hashtable and
	public static function disjunction_arht(&$arht_in) {
		try {
			$arht_funcargs=func_get_args();
			$i_n_of_args=func_num_args();
			$s_key=NULL;
			if(sirelSiteConfig::$debug_PHP) {
				sirel_math_boolean::verifications_1($arht_in,$arht_funcargs);
			} // if
			$b_or_sb=NULL;
			$b_out=False;
			// The $arht_funcargs[0]==$arht_in, hence
			// the $i=1; in stead of the $i=0;
			for($i=1;$i<$i_n_of_args;$i++) {
				$s_key=$arht_funcargs[$i];
				$b_or_sb=$arht_in[$s_key];
				$b_out=$b_out||sirel_type_normalizations::to_b($b_or_sb);
				if($b_out==True) {
					$i=$i_n_of_args; // ==break in a conservative manner
				} // if
			} // for
			return $b_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // disjunction_arht

//--------------------------------------------------------------------
} // sirel_math_boolean


?>

