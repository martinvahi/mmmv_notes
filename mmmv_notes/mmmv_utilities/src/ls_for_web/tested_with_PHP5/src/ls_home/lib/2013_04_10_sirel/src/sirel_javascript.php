<?php
//------------------------------------------------------------------------
// Copyright 2009, martin.vahi@softf1.com that has an
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
//
//------------------------------------------------------------------------
// As the code in this file is quite useless without an
// accompanying JavaScript code, the COMMENTS.txt next to the
// application's public JavaScript folder provides more
// insight to the code.
//------------------------------------------------------------------------

require_once('sirel_resource.php');
require_once('sirel_html.php');

// JavaScript support specific PHP code.
class sirelJavaScript {


	// Reads text in from a YAML file. The $language has to be a string.
	// It supplements the html-page with the messages listed in
	// the $commaseparated_list_of_text_numbers.
	// The Message numbers are encoded into HTML-element ID-s.
	public function add_texts_2_page(&$sirelHTMLPage_instance,
			$commaseparated_list_of_text_numbers,$language=NULL) {
		$s_csl=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
				__LINE__,__CLASS__,__FUNCTION__,
				$commaseparated_list_of_text_numbers);
		try {
			if(is_null($language)) {
				$language=sirelSiteConfig::$language;
			} else {
				$language=sirelLang::assert_is_string_nonempty_after_trimming(__FILE__,
						__LINE__,__CLASS__,__FUNCTION__,$language);
			} // else
			$s_fp=sirelSiteConfig::$ui_messages_folder.
					'/ui_messages_configuration.php';
			require_once($s_fp);
			$ar_text_numbers=sirelLang::commaseparated_list_2_array($s_csl);
			$answer='';
			$ob_html=&$sirelHTMLPage_instance;
			foreach($ar_text_numbers as $text_number) {
				$tn=(int)$text_number;
				$data=sirelResource::get_text($tn,$language);
				$arhtmlid_suffix='sirel_dictionary_msg_'.$text_number;
				$ob_html->add_2_arht_data_section($arhtmlid_suffix,$data);
			} // foreach
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // add_texts_2_page

} // class sirelJavaScript


?>
