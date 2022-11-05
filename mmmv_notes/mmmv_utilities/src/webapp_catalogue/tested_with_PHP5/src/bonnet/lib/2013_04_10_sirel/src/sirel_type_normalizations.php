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
require_once('sirel_lang.php');

// ---------------------------------------------------------

class sirel_type_normalizations {

//--------------------------------------------------------------------
	// Returns an integer. If the origin type is not supported
	// or the conversion is not possible, an exception will be thrown.
	public static function to_i(&$i_or_s_or_fd) {
		try {
			$s_type=sirelLang::type_2_s($i_or_s_or_fd);
			$i_out=0;
			if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_mbstring')) {
				$x=sirelLang::mb_trim($i_or_s_or_fd);
				$i_out=(int)$x;
			} else {
				if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_int')) {
					$i_out=$i_or_s_or_fd;
				} else {
					if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_float')) {
						$x=abs($i_or_s_or_fd);
						$i_floor=floor($x);
						$i_diff=$x-$i_floor;
						if(0<$i_diff) {
							throw new Exception(
							__CLASS__.'->'.__FUNCTION__.
									': It\'s not possible to convert a '.
									'floating point value of '.$i_or_s_or_fd.
									' to an integer without rounding.');
						} // if
						$i_out=(int)$i_or_s_or_fd;
					} else {
						throw new Exception(
						__CLASS__.'->'.__FUNCTION__.
								': There\'s no branch for type '.
								'$s_type=='.$s_type.
								'  $i_or_s_or_fd=='.$i_or_s_or_fd.'.');
					} // else
				} // else
			} // else
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': '.
					'$i_or_s_or_fd=='.$i_or_s_or_fd);
		} // catch
	} // to_i

//--------------------------------------------------------------------
	// Returns a float.  If the origin type is not supported or
	// the conversion is not possible, an exception will be thrown.
	public static function to_fd(&$i_or_s_or_fd) {
		try {
			$s_type=sirelLang::type_2_s($i_or_s_or_fd);
			$fd_out=0.0;
			if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_float')) {
				$fd_out=$i_or_s_or_fd;
				return $fd_out;
			} // if
			if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_mbstring')) {
				$s1=mb_ereg_replace(' ','',$i_or_s_or_fd);
				$s2=mb_ereg_replace('[,]','.', $s1);
				if(sirelSiteConfig::$debug_PHP) {
					$i_n=mb_substr_count($s2, '.');
					if(1<$i_n) {
						throw new Exception('The $i_or_s_or_fd was of type '.
								'string and after converting all of the '.
								'commas to dots it contained more than '.
								'one dot. $i_or_s_or_fd=="'.$i_or_s_or_fd.'"');
					} // if
				} // if
				$fd_out=floatval($s2);
				return $fd_out;
			} // if
			if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_int')) {
				$fd_out=(float)$i_or_s_or_fd;
				return $fd_out;
			} // if
			throw new Exception(
			__CLASS__.'->'.__FUNCTION__.
					': There\'s no branch for type $s_type=='.$s_type.
					'  $i_or_s_or_fd=='.$i_or_s_or_fd.'.');
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': '.
					'$i_or_s_or_fd=='.$i_or_s_or_fd);
		} // catch
	} // to_fd


//--------------------------------------------------------------------
	// Accepts a boolean or a string, which equals 't' or 'f'.
	// Throws or returns a boolean.
	public static function to_b(&$b_or_sb) {
		try {
			$s_type=sirelLang::type_2_s($b_or_sb);
			$b_out=NULL;
			if(sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_bool')) {
				$b_out=$b_or_sb;
			} elseif (sirelLang::str1EqualsStr2($s_type, 'sirelTD_is_mbstring')) {
				if(sirelLang::str1EqualsStr2($b_or_sb, 't')) {
					$b_out=True;
				} elseif(sirelLang::str1EqualsStr2($b_or_sb, 'f')) {
					$b_out=False;
				} else {
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': This method does not contain a '.
							'boolean interpretation of string "'.
							$b_or_sb.'" ');
				} // else
			} else {
				throw new Exception(
				__CLASS__.'->'.__FUNCTION__.
						': There\'s no branch for type '.
						'$s_type=='.$s_type.
						'  $b_or_sb=='.$b_or_sb.'.');
			} // else
			return $b_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': '.
					'$i_or_s_or_fd=='.$b_or_sb);
		} // catch
	} // to_b

} // sirel_type_normalizations


// ---------------------------------------------------------

?>
