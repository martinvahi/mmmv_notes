<?php
//=========================================================================
// Copyright 2011, martin.vahi@softf1.com that has an
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
//=========================================================================
require_once('sirel_lang.php');
//=========================================================================
class sirelDBcalc {

	public function calc_and_add_or_update_cache_fields(&$arht_row,
			$s_key, $s_cache_field_name_core, $s_interpretation) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$arht_row);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_key);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_cache_field_name_core);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_interpretation);
			} // if
			$x_interpr=NULL;
			$b_interpr_failure=True;
			switch ($s_interpretation) {
				case 'fd':
					$x=$arht_row[$s_key];
					$a_pair=sirelLang::str2float($x);
					$b_interpr_failure=$a_pair->a_;
					if($b_interpr_failure) {
						$x_interpr=0;
					} else {
						$x_interpr=$a_pair->b_;
					} // else
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'$s_interpretation=='.$s_interpretation.'.');
					break;
			} // switch
			$s_cache_field_name='dbf_cache_'.$s_interpretation.'_'.
					$s_cache_field_name_core;
			$s_cache_field_name_sb='dbf_cache_sb_'.$s_interpretation.'_'.
					$s_cache_field_name_core.'_set';
			if($b_interpr_failure) {
				$arht_row[$s_cache_field_name_sb]='f';
			} else {
				$arht_row[$s_cache_field_name_sb]='t';
			} // else
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // calc_and_add_or_update_cache_fields


	//------------------------------------------------------------------
	public static function selftest() {
		try {
			$ar_test_results=array();
			//$ar_test_results[]=sirelDBcalc::selftest_awsome();
			return $ar_test_results;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest

} // class sirelDBcalc

?>
