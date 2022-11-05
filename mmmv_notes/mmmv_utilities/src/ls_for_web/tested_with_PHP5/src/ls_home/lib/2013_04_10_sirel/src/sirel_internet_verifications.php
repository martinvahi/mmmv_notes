<?php
//=========================================================================
// Copyright 2010, martin.vahi@softf1.com that has an
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
class sirelInternetVerifications {

	// Returns a hashtable
	// ht[(string)'failure']==(boolean)<True/False>
	// ht[(string)'msg']==(string)<failure message>
	public static function absolute_domain_name_syntax(
			$absolute_domain_name_candidate) {
		try {
			// A short summary of the RFC 1034:
			//
			// The domain name has 2 forms: written form, the one with
			// the written dots, and a binary form, for routers, etc.
			//
			// Binary form:
			// <label1 length><label1>
			// <label2 length><label2>
			// ...
			// <root label length, which is zero><root label, which is "missing">
			//
			// Maximum label length is 63 ASCII characters and label
			// lengths have all the size of exactly 1B.
			// Given that the maximum allowed length of the
			// binary version of the domain name is 255B, the maximum
			// amount of ASCII characters in the binary version of the
			// domain name is:
			//      <label length byte> + 63B = 64B
			//      255B - <root label length byte> = 254B
			//      While trying to minimize the amount of bytes spent on
			//      label lengths, one minimizes the amount of labels.
			//      4 * 64B = 256B, but 254B < 256B
			//      3 * 64B = 192B,    254B - 192B = 62B
			//      One byte out of the 62B is spent on label length, which
			//      leads to the maximum number of ASCII characters within
			//      the binary form of a domain name:
			//                (3 * 63B) + (62B - 1B)=250B
			//
			// In written form, label lengths are not present and all of
			// the labels, includng the root lable, is separated from
			// eachother by the dot ("."). So, a valid absolute path ends
			// with a dot like:
			//            archive.org.
			//          wikipedia.org.
			//
			// Relative domain names have a written form that
			// does not end with the dot and it's up to the application
			// to complete the domain name.
			$dn_candidate=&$absolute_domain_name_candidate;
			$arht_out=array();
			$arht_out['failure']=True;
			$arht_out['msg']='$absolute_domain_name_candidate=='.dn_candidate.' ';
			// I'll add a few of my own, nonstandard, limitations.
			// For instance, the written form of hi..there.com.
			// does not make a difference between cases
			// "hi."+"there"+"com"+"" and "hi"+".there"+"com"+""
			// even though the binary domain name format supports
			// both of them.
			if(mb_strlen($dn_candidate)==0) {
				$arht_out['msg']=$arht_out['msg'].' is an empty string.';
				return $arht_out;
			} // if
			$s0=mb_ereg_replace("[\\s,;@!:\\(\\)\\[\\]]", "", $dn_candidate);
			if(mb_strlen($s0)!=mb_strlen($dn_candidate)) {
				$arht_out['msg']=$arht_out['msg'].
						' contained unaccepted characters.';
				return $arht_out;
			} // if
			$s1=mb_ereg_replace("[.]", "", $s0);
			if(250<mb_strlen($s1)) {
				$arht_out['msg']=$arht_out['msg'].
						' RFC 1034 allows at most 250 label characters per'.
						'domain name.';
				return $arht_out;
			} // if
			// TODO: siia j2i pooleli. nyyd on vaja veel see 63-m2rgine
			// yksiku m2rgendi piirangu suhtes kontroll teostada.
			$arht_out['failure']=False;
			$arht_out['msg']='';
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // absolute_domain_name_syntax

	private static function selftest_absolute_domain_name_syntax() {
		try {
			$test_result=array();
			$ar_tc=array();
			//----tests-cases-start----------------------
			$arht=sirelInternetVerifications::absolute_domain_name_syntax('    ');
			if(!$arht['failure']) {
				$test_case['msg']='An empty domain name tolerated. 1';
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$arht=sirelInternetVerifications::absolute_domain_name_syntax('');
			if(!$arht['failure']) {
				$test_case['msg']='An empty domain name tolerated. 2';
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='relative.path';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='wel;come.to.ee.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='very bad.treatment.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='(.com.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='hi.).com.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='be.[aware.com.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='junk].com.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc='artificial@limitation.com.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			//-------------
			$dnc='';
			for($i=0;$i<250;$i++) {
				$dnc=$dnc.'x';
			} // for
			$dnc=$dnc.'.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if($arht['failure']) {
				$test_case['msg']='Failed to accept $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			$dnc=$dnc.'X.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if(!$arht['failure']) {
				$test_case['msg']='Toleration of $dnc=='.$dnc;
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
			//-------------
			$dnc='.';
			$arht=sirelInternetVerifications::absolute_domain_name_syntax($dnc);
			if($arht['failure']) {
				$test_case['msg']='Failed to accept $dnc=='.$dnc;
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
	} // selftest_absolute_domain_name_syntax


//	// Returns a hashtable
//	// ht[(string)'failure']==(boolean)<True/False>
//	// ht[(string)'msg']==(string)<failure message>
//	// ht[(string)'failure_code']==(int)<0 for success>
//	public static function emailaddress($an_email_address_candidate) {
//		try {
//			// It is far from trivial to verify the syntax of an
//			// e-mail address. The amount of RFC's that it
//			// has to adhere to is quite unpleasent.
//			$arht_out=array();
//			$arht['failure']=True;
//			$arht['msg']='$an_email_address_candidate=="'.
//					$an_email_address_candidate.'" ';
//			$arht['normalized']='';
//			$arht['failure_code']=0;
//			$s0=sirelLang::mb_trim($an_email_address_candidate);
//
//
//
//			$s1=mb_ereg_replace("[\\s]*", '',$s0);
//			if(mb_strlen($s0)!=mb_strlen($s1)) {
//				$arht['failure_code']=1;
//				$arht['msg']='Spaces within email address.';
//				return $arht;
//			} // if
//			$s1=mb_ereg_replace("([.][.])+", '',$s0);
//			if(mb_strlen($s0)!=mb_strlen($s1)) {
//				$arht['failure_code']=2;
//				$arht['msg']='Doubledots.';
//				return $arht;
//			} // if
//
//			$arht['failure']=False;
//			$arht['msg']='';
//			return $arht;
//		}catch (Exception $err_exception) {
//			sirelBubble(__FILE__,__LINE__,$err_exception,
//					__CLASS__.'->'.__FUNCTION__.': ');
//		} // catch
//	} // emailaddress
//
//
//	private static function selftest_emailaddress() {
//		try {
//			$test_result=array();
//			$ar_tc=array();
//			//----tests-cases-start----------------------
//			// TODO: All of the test cases here are subject to
//			// update according to RFC-s.
//			$arht=sirelInternetVerifications::emailaddress('    ');
//			if(!$arht['failure']) {
//				$test_case['msg']='An empty email address tolerated. 1';
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$arht=sirelInternetVerifications::emailaddress('');
//			if(!$arht['failure']) {
//				$test_case['msg']='An empty email address tolerated. 2';
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='...@Mal.com';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='@';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='hi@.';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='.@.';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='.@gar.net';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='hi@@apog.ee';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='in @li.eu';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='never@s,ee';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='letter..with@boei.ng';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='@anonymo.us';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='SeeU@';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='dotless@females';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if(!$arht['failure']) {
//				$test_case['msg']='Tolearation of '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='   all@of.us';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if($arht['failure']) {
//				$test_case['msg']='Failure to accept '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='our@ma.de  ';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if($arht['failure']) {
//				$test_case['msg']='Failure to accept '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			$eac='truly@jui.cy';
//			$arht=sirelInternetVerifications::emailaddress($eac);
//			if($arht['failure']) {
//				$test_case['msg']='Failure to accept '.$eac;
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			if(!sirelLang::str1EqualsStr2($arht['normalized'],$eac)) {
//				$test_case['msg']='Malnormalization. $arht[\'normalized\']=='.
//						$arht['normalized'];
//				$test_case['line_number']=__LINE__;
//				$ar_tc[]=$test_case;
//			} // if
//			//----tests-cases-end------------------------
//			$test_result['test_cases']=$ar_tc;
//			$test_result['file_name']=__FILE__;
//			return $test_result;
//		}catch (Exception $err_exception) {
//			sirelBubble(__FILE__,__LINE__,$err_exception,
//					__CLASS__.'->'.__FUNCTION__.': ');
//		} // catch
//	} // selftest_emailaddress

	//------------------------------------------------------------------
	public static function selftest() {
		try {
			$ar_test_results=array();
			$ar_test_results[]=sirelInternetVerifications::selftest_absolute_domain_name_syntax();
			//$ar_test_results[]=sirelInternetVerifications::selftest_emailaddress();
			return $ar_test_results;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest

} // class sirelInternetVerifications

?>
