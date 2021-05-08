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

interface sirelOO2RDBmapping {

	// Returns True, if all of the necessary tables are present
	// in the database. Otherwise it returns False. It checks
	// the presence of the tables only by their names,
	// that is to say, it does not check, whether the tables
	// with required names actually have a valid number types of columns.
	public function tables_exist();

	// Destroys all of the tables that are maintained by the
	// current class.
	public function drop_tables();

	// Creates and initiates tables that are missing. It does not
	// overwrite existing tables. It's OK to call that method multiple
	// times, but this method might be relatively time consuming, because
	// it checks the existence of tables.
	public function ensure_tables_existence();

} // interface sirelOO2RDBmapping


// The idea is that the client sends one string, which is
// called a formscript, and then server responds to it in some
// manner.
interface sirelFormScriptProcessor {
	// Returns a name of the script processor.
	// The name is used for identifying the script processor type.
	public function type();

	// It returns a string that is the a response to a request.
	// In some cases the string is even the whole HTML document.
	//
	// $a_string_from_client is allowed to be an empty string, but it
	// is not allowed to be NULL.
	public function run(&$a_string_from_client);
} // interface sirelFormScriptProcessor

class sirelFormscriptDataPacket {
	public $phone_number_;
	public $session_id_;
	public $ticket_;
	public $checksum_;
	public $data_;
	public $authenticated_=False;
} //class sirelFormscriptDataPacket

// Every data set that the server side of a sirel based web
// application receives has been wrapped into a structured string
// that is called a formscript.
//
// Part of the formscript determins, which part of
// the server side application will process the received data.
// This also enables the implementation to avoid loading some
// of the PHP-files that are not needed for servicing the given request.
// The formscript has the following syntax:
// formscirpt_processor_type_name|||session_id||| whatever else
//
// An  example:
// "ajax_login|||44s|||joe|||password_hash"
// "ajax_session_page1|||1394k|||get_title|||
// The "|||" is a formscript reserved word.
//
// All of the formscript processors are expected to implement the
// sirelFormScriptProcessor interface.
//
// TODO: refactor it to use the ProgFTE based format.
// The descaping is due to a bug in the YUI library. the YUI
// library escapes all ", ', \ characters before posting.
class sirelFormscriptSupport {

/// Returns formscript, if it is wellformed, or exits the
/// application.
	public static function action_php_preprocess_formscript($formscript) {
		if(is_null($formscript)) {
			if(!$debug_mode) exit;
			echo('$formscript==NULL');
			exit;
		} // if
		if($formscript=='') {
			if(!$debug_mode) exit;
			$msg='Received an empty formscript'.$formscript;
			sirelLogger::log(__FILE__, __LINE__,$msg,'debug');
			echo $msg;
			exit;
		} // if
		$formscript=mb_convert_encoding($formscript,'UTF-8','auto');
		$formscript=sirelLang::mb_trim($formscript);
		if($formscript=='') {
			if(!$debug_mode) exit;
			$msg='Received a formscript that is empty after trimming.';
			sirelLogger::log(__FILE__, __LINE__,$msg,'debug');
			echo $msg;
			exit;
		} // if
		return $formscript;
	} // action_php_preprocess_formscript

	public static function action_php_bisect_formscript_t1(&$formscript) {
		$s_1='|||';
		$ar=sirelLang::bisectStr($formscript,$s_1);
		if(is_null($ar)) {
			if(!$debug_mode) exit;
			$msg='$ar==NULL';
			sirelLogger::log(__FILE__, __LINE__,$msg,'debug');
			echo $msg;
			exit;
		} // if
		if(count($ar)!=3) {
			if(!$debug_mode) exit;
			$msg='count($ar)=='.count($ar).'!=3';
			sirelLogger::log(__FILE__, __LINE__,$msg,'debug');
			echo $msg;
			exit;
		} // if
		$answer=new sirelPair();
		$answer->a_=$ar[1];
		$answer->b_=$ar[2];
		return $answer;
	} // action_php_bisect_formscript_t1

	// Returns a sirelPair instance, where
	// pair->a_==<the string before the first occurrence of '|||'> and
	// pair->b_==<the rest of the string after the first occurrence of '|||'
	private static function bisect(&$a_string) {
		try {
			// The bisectStr checks that the a_string is not empty
			$s_1='|||';
			$ar=&sirelLang::bisectStr($a_string, $s_1);
			if(is_null($ar)) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'$ar==NULL, GUID==8afc4df4-3d12-4576-b99a-5062c32302cb');
			} // if
			if(count($ar)!=3) {
				usleep(sirelSecurityArch_1::calculate_delay_in_microseconds());
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'count($ar)!=3, GUID==2b0fb4bb-6943-45ab-9ca3-9d7e076adf1c');
			} // if
			$pair=new sirelPair();
			$pair->a_=&$ar[1];
			$pair->b_=&$ar[2];
			return $pair;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // bisect

	// Input string: <response receiver phone number>|||<an array in JSON>
	// The array content: session_id, ticket, checksum, data.
	public static function deserialize(&$a_string) {
		try {
			$data_packet=new sirelFormscriptDataPacket();
			$a_pair=&sirelFormscriptSupport::bisect($a_string);
			$data_packet->phone_number_=$a_pair->a_;
			$arht=&sirelLang::ProgFTE2ht($a_pair->b_);
			if(count($arht)!=4) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.':: '.
						'count($ar)=='.count($arht).' !=4, '.
						'$a_string='.$a_string."  \n".
						'GUID==b8dbd149-8ae8-438a-9331-6d223066c51b');
			} // if
			$data_packet->session_id_=&$arht['session_id'];
			$data_packet->ticket_=&$arht['ticket'];
			$data_packet->checksum_=&$arht['checksum'];
			$data_packet->data_=&$arht['data'];
			return $data_packet;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // deserialize


	// For sake of reliability there's an artificial limitation imposed
	// by this method that after trimming the $response_as_a_string
	// may not be an empty string. Returns a string that conforms with sirel
	// specific AJAX response formatting. The file COMMENTS.txt within a
	// javascript folder tells more about the format.
	public static function AJAXformat(&$phone_number,&$response_as_a_string) {
		$rp=&sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
				__LINE__,__CLASS__,__FUNCTION__, $response_as_a_string);
		$phn=&sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
				__LINE__,__CLASS__,__FUNCTION__, $phone_number);
		try {
			//  sirelLogger::log(__FILE__, __LINE__,
			//   '$response_as_a_string==('.$response_as_a_string.')', 'debug');
			$answer='no_errors_occurred_at_server_side|||';
			if(sirelSiteConfig::$debug_PHP) {
				$s=sirelLogger::to_s('debug');
				if($s!='') {
					$answer=$answer.'with_debuglog|||';
					$ss=mb_ereg_replace('[|]{1}', 'SiNgLepILLAR4', $s);
					$answer=$answer.$ss.'|||';
				} else {
					$answer=$answer.'without_debuglog|||x|||';
				} // else
			} else {
				$answer=$answer.'without_debuglog|||y|||';
			} // else
			return $answer.$phn.'|||'.$rp;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // AJAXformat


	private static $protocol_1_b_authentication_failed_=False;
	private static $protocol_1_cache_s_answer_=NULL;
	private static $protocol_1_cache_dpckg_=NULL;
	public static function unpack_data_by_protocol_t1(&$s_string_from_client) {
		try {
			$dpckg=&sirelFormscriptSupport::deserialize($s_string_from_client);
			sirelFormscriptSupport::$protocol_1_cache_dpckg_=&$dpckg;
			$arht_data_in=&raudrohi_support::unpack_microsession_package($dpckg);
			return $arht_data_in;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // unpack_data_by_protocol_t1

	// It's compulsory to unpack by rpotocol_t1 priour to using this
	// packing method. One skips the check due to speed.
	public static function pack_data_by_protocol_t1(&$arht_data_out) {
		try {
			$s=NULL;
			if(sirelFormscriptSupport::$protocol_1_b_authentication_failed_) {
				$s=sirelFormscriptSupport::$protocol_1_cache_s_answer_;
			} else {
				$s=&raudrohi_support::pack_microsession_package($arht_data_out);
			} // else
			$dpckg=&sirelFormscriptSupport::$protocol_1_cache_dpckg_;
			$s_out=&sirelFormscriptSupport::AJAXformat($dpckg->phone_number_,
					$s);
			sirelFormscriptSupport::$protocol_1_cache_dpckg_=NULL;
			return $s_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // pack_data_by_protocol_t1


	// Returns false, if authentication failed.
	public static function authentication_by_protocol_t1_succeeds(&$auth) {
		try {
			$dpckg=&sirelFormscriptSupport::$protocol_1_cache_dpckg_;
			$b_out=$auth->packet_authentication_succeeds($dpckg,
					sirelFormscriptSupport::$protocol_1_cache_s_answer_);
			if($b_out===False) {
				sirelFormscriptSupport::$protocol_1_b_authentication_failed_=True;
			} // if
			return $b_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // pack_data_by_protocol_t1



} // class sirelFormscriptSupport

?>
