<?php
//=========================================================================
// Copyright 2010, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
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
require_once('sirel_internet_verifications.php');
//=========================================================================
class sirelTXTnorm {



	// Returns a hashtable
	// ht[(string)'failure']==(boolean)<True/False>
	// ht[(string)'msg']==(string)<failure message>
	// ht[(string)'normalized']==(string)<normalized emali address or
	//                            an empty string>
	// ht[(string)'failure_code']==(int)<0 for success>
	public static function emailaddress($an_email_address_candidate) {
		try {
			// A citation from RFC 1034, copy-pasted from
			// http://www.faqs.org/rfcs/rfc1034.html#ixzz0q5aszOlY :
			// " When you receive a domain name or
			//   label, you should preserve its case.
			//   The rationale for this choice is
            //   that we may someday need to add full binary
			//   domain names for new services; existing services
			//   would not be changed. "
			//
			// However, that time will probably never come and I'll still
			// normalize the domain names.
			$arht_out=array();
			$arht['failure']=True;
			$arht['msg']='$an_email_address_candidate=="'.
					$an_email_address_candidate.'" ';
			$arht['normalized']='';
			$arht['failure_code']=0;
			$s0=sirelLang::mb_trim($an_email_address_candidate);
			//$arht0=sirelInternetVerifications::emailaddress($s0);
			if($arht0['failure']){
				$arht['failure_code']=$arht0['failure_code'];
				$arht['msg']=$arht['msg'].' '.$arht0['msg'];
				return $arht;
			} // if

			$arht['failure']=False;
			$arht['msg']='';
			return $arht;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // emailaddress


	private static function selftest_emailaddress() {
		try {
			$test_result=array();
			$ar_tc=array();
			//----tests-cases-start----------------------
			$arht=sirelTXTnorm::emailaddress('    ');
			if(!$arht['failure']) {
				$test_case['msg']='An empty email address tolerated. 1';
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$eac='dotless@females';
			$arht=sirelTXTnorm::emailaddress($eac);
			if(!$arht['failure']) {
				$test_case['msg']='Tolearation of '.$eac;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$eac='   all@of.us';
			$arht=sirelTXTnorm::emailaddress($eac);
			if($arht['failure']) {
				$test_case['msg']='Failure to accept '.$eac;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$eac='our@ma.de  ';
			$arht=sirelTXTnorm::emailaddress($eac);
			if($arht['failure']) {
				$test_case['msg']='Failure to accept '.$eac;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$eac='truly@jui.cy';
			$arht=sirelTXTnorm::emailaddress($eac);
			if($arht['failure']) {
				$test_case['msg']='Failure to accept '.$eac;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			if(!sirelLang::str1EqualsStr2($arht['normalized'],$eac)) {
				$test_case['msg']='Malnormalization. $arht[\'normalized\']=='.
						$arht['normalized'];
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			//----tests-cases-end------------------------
			$test_result['test_cases']=$ar_tc;
			$test_result['file_name']=__FILE__;
			return $test_result;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest_emailaddress

	//------------------------------------------------------------------
	public static function selftest() {
		try {
			$ar_test_results=array();
			$ar_test_results[]=sirelTXTnorm::selftest_emailaddress();
			return $ar_test_results;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest

} // class sirelTXTnorm

?>
