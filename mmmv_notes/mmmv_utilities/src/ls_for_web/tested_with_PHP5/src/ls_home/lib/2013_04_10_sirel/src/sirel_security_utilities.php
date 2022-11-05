<?php
//=========================================================================
// Copyright (c) 2012, martin.vahi@softf1.com that has an
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
require_once('sirel_lang.php');

//-------------------------------------------------------------------------

class sirel_security_utilities {

//-------------------------------------------------------------------------

	//  0 < $i_length < infinity
	//
	// As the output of this method is random,
	// the output can contain vulgar expressions. For example,
	// if one uses this method for automatically generating
	// passwords, then one should apply a directory filter to
	// the generated strings prior to sending them to the end users.
	public static function s_generate_random_ASCIIstyle_string($i_length) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_int',$i_length);
				sirelLang::assert_range(0,'<',$i_length,'*',42,'$i_length');
			} // if
			$arht=array();
			$i_range=NULL;
			for($i=0;$i<$i_length;$i++) {
				$i_range=mt_rand(1,3);
				if($i_range==1) {
					$arht[]=chr(mt_rand(48,57));      // 0..9
				} else {
					if($i_range==2) {
						$arht[]=chr(mt_rand(65,90));  // A..Z
					} else { // $i_range==3
						$arht[]=chr(mt_rand(97,122)); // a..z
					} // else
				} // else
			} // for
			$s_out=s_concat_array_of_strings($arht);
			return $s_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_generate_random_ASCIIstyle_string


//-------------------------------------------------------------------------
} // sirel_security_utilities
//=========================================================================
?>

