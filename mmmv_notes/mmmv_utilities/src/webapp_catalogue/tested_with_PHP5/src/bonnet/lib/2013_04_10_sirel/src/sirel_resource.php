<?php
//--------------------------------------------------------------
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
//--------------------------------------------------------------

require_once('sirel_lang.php');

class sirelResource {

	public static $UI_message_files_=array();

	private static function get_text_get_file_name($text_number) {
		try {
			if($text_number<1) {
				throw new Exception('$text_number(=='.$text_number.') < 1');
			}
			$keys=array_keys(sirelResource::$UI_message_files_);
			sort($keys,SORT_REGULAR);
			$answer;
			foreach($keys as $x) {
				if($text_number<($x+1)) {
					$answer=sirelResource::$UI_message_files_[$x];
					break;
				} // if
			} // foreach
			if(is_null($answer)) {
				sirelThrowResourceException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'$text_number(=='.$text_number.') '.
						'did not fit to any available interval.');
			} // if
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_text_get_file_name

	// The $get_text_from_HDD_cache is assumed to always
	// reflect the content of the YAML file. If it doesn't, then
	// so be it. It's also read and written by the
	// get_text_HDD2Memcacheable().
	private static $get_text_from_HDD_cache=array();

	private static function get_text_from_HDD(&$yaml_file_name,
			$text_number, &$language) {
		try {
			$x=NULL;
			if (!array_key_exists($yaml_file_name,sirelResource::$get_text_from_HDD_cache)) {
				$x=sirelLang::YAML2array(sirelSiteConfig::$ui_messages_folder.
						'/'.$yaml_file_name);
				sirelResource::$get_text_from_HDD_cache[$yaml_file_name]=$x;
			} else {
				$x=sirelResource::$get_text_from_HDD_cache[$yaml_file_name];
			} // if
			$ar_msg=$x['msg_'.$text_number];
			if(is_null($ar_msg)) {
				sirelThrowResourceException(__FILE__, __LINE__, 'The '.
						$yaml_file_name.' did not contain message number '.
						$text_number.'.');
			} // if
			$msg=$ar_msg[$language];
			if(is_null($msg)) {
				sirelThrowResourceException(__FILE__, __LINE__, 'The '.
						$yaml_file_name.' message number '.$text_number.
						' did not contain message in language '.$language.' .');
			} // if
			return $msg;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_text_from_HDD

	// Reads text in from a YAML file. The $language has to be a string.
	public static function get_text($i_or_si_text_number, $s_language=NULL) {
		// We'll rely on the operating system file buffer to
		// do the inter-session caching. Otherwise one would use
		// the Memcached.
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_int,sirelTD_is_mbstring',
						$i_or_si_text_number);
			} // if
			$i_text_number=(int)$i_or_si_text_number;
			if($i_text_number<1) {
				throw new Exception('$text_number(=='.$i_text_number.') < 1');
			} // if
			if(is_null($s_language)) {
				$s_language=sirelSiteConfig::$language;
			} else {
				$s_language=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
						__LINE__,__CLASS__,__FUNCTION__,$s_language);
			} // else
			require_once(sirelSiteConfig::$ui_messages_folder.
							'/ui_messages_configuration.php');
			$tf_name=sirelResource::get_text_get_file_name($i_text_number);
			$x=sirelResource::get_text_from_HDD($tf_name,$i_text_number,
					$s_language);
			return $x;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_text


} //class sirelResource

?>
