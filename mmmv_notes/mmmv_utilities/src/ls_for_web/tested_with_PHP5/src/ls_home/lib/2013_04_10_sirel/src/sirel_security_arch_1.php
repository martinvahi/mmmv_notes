<?php
//------------------------------------------------------------------------
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
//
//------------------------------------------------------------------------
// A bunch of convenience routines that are specific to the
// security architecture that the sirel library supports.
//------------------------------------------------------------------------

require_once("sirel_lang.php");

class sirelSecurityArch_1 {

	private static function calculate_delay_acquire_value($keyname,
			$default_value) {
		$answer=$default_value*1.0;
		if(array_key_exists($keyname, sirelSiteConfig::$various)) {
			$x=sirelSiteConfig::$various[$keyname];
			if(is_int($x)||(is_double($x))) {
				if(0<=$x) {
					$answer=$x;
				} else {
					sirelLogger::log(__FILE__,__LINE__,
							'sirelSiteConfig::$various["'.$keyname.'"] had a '.
							'negative value |||(=='.$x.').');
				} // else
			}else {
				sirelLogger::log(__FILE__,__LINE__,
						'sirelSiteConfig::$various["'.$keyname.'"] is not '.
						'an integer nor a double. It\'s class is|||'.
						get_class($x).'  and value is '.$x);
			}//else
		} // if
		$max_allowed=15.0;
		if($max_allowed<$answer) {
			sirelLogger::log(__FILE__,__LINE__,
					$max_allowed.' < sirelSiteConfig::$various["'.$keyname.'"]'.
					'|||(=='.$answer.') The value will be automatically '.
					'changed to '.$max_allowed.'.');
			$answer=$max_allowed;
		} // if
		return $answer;
	}   // calculate_delay_acquire_value


	// A slight Denial Of Service (DoS) attack antimeasure. It also tries to
	// hide the differences within load times, if  for valid and invalid
	// user names. This method is meant to be used in conjunction
	// with the PHP built-in function usleep(). It reads in min and
	// max delay value from the sirelSiteConfig.
	public static function calculate_delay_in_microseconds() {
		$min=sirelSecurityArch_1::calculate_delay_acquire_value('login_delay_min', 1);
		$max=sirelSecurityArch_1::calculate_delay_acquire_value('login_delay_max', 3);
		if(($min+$max)==0.0) {
			$max=3;
			sirelLogger::log(__FILE__,__LINE__,
					'(sirelSiteConfig::$various["login_delay_min"] + '.
					'sirelSiteConfig::$various["login_delay_max"]) == 0. '."\n".
					'For security reasons the maximum '.
					'delay will be automatically set to '.$max.'.');
		} // if
		$x=1000000;
		return mt_rand($min*$x,$max*$x);
	} // calculate_delay_in_microseconds()

} // class sirelSecurityArch_1


?>
