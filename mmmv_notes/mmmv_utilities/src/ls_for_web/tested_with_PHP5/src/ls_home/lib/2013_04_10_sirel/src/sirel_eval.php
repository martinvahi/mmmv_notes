<?php
//=========================================================================
// Copyright 2012, martin.vahi@softf1.com that has an
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
require_once('sirel_fs.php');
//=========================================================================

class sirel_eval {

	private static function eval_t1(&$s_cmd_prefix, &$s_src) {
		try {
			$s_fp_tmp_file=sirelFS::s_gen_tmpfilename();
			$f_tmp=fopen($s_fp_tmp_file,'w+');
			fwrite($f_tmp,$s_src);
			fclose($f_tmp);
			$s_stdout=NULL;
			try {
				$s_cmd=($s_cmd_prefix.' ').($s_fp_tmp_file.' ;');
				$s_stdout=shell_exec($s_cmd);
				unlink($s_fp_tmp_file);
			}catch (Exception $err_exception) {
				unlink($s_fp_tmp_file);
				sirelBubble(__FILE__,__LINE__,$err_exception,
						__CLASS__.'->'.__FUNCTION__.': ');
			} // catch
			$s_stdout=utf8_encode($s_stdout);
			return $s_stdout;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // eval_t1

	//--------------------------------------------------------------------

	public static function s_php(&$s_src) {
		try {
			$s_fp_php_ini=sirelSiteConfig::$various['sirel_impl_s_fp_php_ini'];
			// The command-line executable has to be "php", not "php5",
			// because servers tend to have just "php" available.
			$s_cmd_prefix='php --php-ini '.$s_fp_php_ini;
			$s_stdout=sirel_eval::eval_t1($s_cmd_prefix, $s_src);
			return $s_stdout;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_php

	//--------------------------------------------------------------------

	public static function s_ruby(&$s_src) {
		try {
			$s_cmd_prefix='ruby -Ku ';
			$s_stdout=sirel_eval::eval_t1($s_cmd_prefix, $s_src);
			return $s_stdout;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_ruby

	//---------------------------------------------------------------------
} // class sirel_eval
//=========================================================================
?>
