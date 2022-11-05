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
require_once('sirel_type_normalizations.php');

// ---------------------------------------------------------

// It's used for converting the unix time integer to
// various string representations of the unix time.
class sirel_unix_time {
	protected static $arht_i18n_=array();

	protected static function verify_language(&$s_language) {
		try {
			$b_ok=False;
			if(sirelLang::str1EqualsStr2($s_language,'estonian')==True) {
				$b_ok=True;
			} else {
				if(sirelLang::str1EqualsStr2($s_language,'english_uk')==True) {
					$b_ok=True;
				} else {
				} // else
			} // else
			if($b_ok==False) {
				throw new Exception('$s_language=="'.$s_language.'", '.
						'but the only supported values are:"estonian",'.
						'"english_uk"');
			} // if
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verify_language

	protected static function get_i18n_instance(&$s_language) {
		try {
			sirel_unix_time::verify_language($s_language);
			$ob_i18n=sirel_unix_time::$arht_i18n_[$s_language];
			if(is_null($ob_i18n)) {
				require_once('bonnet/i18n/unix_time/sirel_unix_time_i18n_'.
								$s_language.'.php');
				if(sirelLang::str1EqualsStr2($s_language,'estonian')==True) {
					$ob_i18n=new sirel_unix_time_18n_estonian();
					sirel_unix_time::$arht_i18n_[$s_language]=$ob_i18n;
				} // if
				if(sirelLang::str1EqualsStr2($s_language,'english_uk')==True) {
					$ob_i18n=new sirel_unix_time_18n_english_uk();
					sirel_unix_time::$arht_i18n_[$s_language]=$ob_i18n;
				} // if
			} // if
			return $ob_i18n;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_i18n_instance

	public static function i_year($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('Y',$i_unix_time));
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_year

	public static function i_month($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('m',$i_unix_time));
			if(sirelSiteConfig::$debug_PHP) {
				if($i_out<1) {
					throw new Exception('$i_out=='.$i_out.'<1');
				} // if
				if(12<$i_out) {
					throw new Exception('12<$i_out=='.$i_out);
				} // if
			} // if
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_month

	public static function i_date($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('d',$i_unix_time));
			if(sirelSiteConfig::$debug_PHP) {
				if($i_out<1) {
					throw new Exception('$i_out=='.$i_out.'<1');
				} // if
				if(31<$i_out) {
					throw new Exception('31<$i_out=='.$i_out);
				} // if
			} // if
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_date

	// Monday, Tuesday,etc.
	public static function i_day_name($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('N',$i_unix_time));
			if(sirelSiteConfig::$debug_PHP) {
				if($i_out<1) {
					throw new Exception('$i_out=='.$i_out.'<1');
				} // if
				if(7<$i_out) {
					throw new Exception('31<$i_out=='.$i_out);
				} // if
			} // if
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_day_name

	// In 24 hour format, i.e. 17
	public static function i_hour($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('G',$i_unix_time));
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_hour

	public static function i_minute($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('i',$i_unix_time));
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_minute

	public static function i_second($i_or_s_unix_time) {
		try {
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			if($i_unix_time<0) {
				throw new Exception('$i_unix_time=='.$i_unix_time.'<0');
			} // if
			$i_out=(int)(date('s',$i_unix_time));
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_second


	public static function s_month_name($s_language,$i_or_s_unix_time) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,_FUNCTION__,
						'sirelTD_is_mbstring', $s_language);
			} // if
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			$i_month=sirel_unix_time::i_month($i_unix_time);
			$ob_i18n=sirel_unix_time::get_i18n_instance($s_language);
			$s_out=$ob_i18n->arht_month_names_[''.$i_month];
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_month_name

	public static function s_day_name($s_language,$i_or_s_unix_time) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__,__LINE__,__CLASS__,_FUNCTION__,
						'sirelTD_is_mbstring', $s_language);
			} // if
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			$i_day_name=sirel_unix_time::i_day_name($i_unix_time);
			$ob_i18n=sirel_unix_time::get_i18n_instance($s_language);
			$s_out=$ob_i18n->arht_day_names_[''.$i_day_name];
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_day_name


	public static function to_s_t1($s_language,$i_or_s_unix_time) {
		try {
			sirel_unix_time::verify_language($s_language);
			$i_unix_time=sirel_type_normalizations::to_i($i_or_s_unix_time);
			$ob_i18n=sirel_unix_time::$arht_i18n_[$s_language];
			$s_out='';
			if(sirelLang::str1EqualsStr2($s_language,'estonian')==True) {
				$s_out=''.sirel_unix_time::i_date($i_unix_time).' '.
						sirel_unix_time::s_month_name($s_language,
						$i_unix_time).' '.
						sirel_unix_time::i_year($i_unix_time);
			} // if
			if(sirelLang::str1EqualsStr2($s_language,'english_uk')==True) {
				$s_out=''.sirel_unix_time::i_date($i_unix_time).'th '.
						sirel_unix_time::s_month_name($s_language,
						$i_unix_time).' '.
						sirel_unix_time::i_year($i_unix_time);
			} // if
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // to_date_str_t1

	// The unix time does not capture just the day, month, year, but
	// also hours, minutes, seoconds. If one wants to select all
	// records that have a date of 01.04.20xx by using just any
	// timestamp that falls to that date, then one has to find the
	// 0. second of the date 01.04.20xx.
	//
	// That's where the i_floor_2_day and i_ceil_2_day come to play.
	public static function i_floor_2_day($i_unix_time) {
		try {
			$i_hour=0;
			$i_minute=0;
			$i_second=0;
			$i_month=sirel_unix_time::i_month($i_unix_time);
			$i_date=sirel_unix_time::i_date($i_unix_time);
			$i_year=sirel_unix_time::i_year($i_unix_time);

			$i_out=mktime($i_hour,$i_minute,$i_second,
					$i_month,$i_date,$i_year);
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_floor_2_day

	// Comments reside next to the i_floor_2_day(...).
	public static function i_ceil_2_day($i_unix_time) {
		try {
			$i_hour=23;
			$i_minute=59;
			$i_second=59;
			$i_month=sirel_unix_time::i_month($i_unix_time);
			$i_date=sirel_unix_time::i_date($i_unix_time);
			$i_year=sirel_unix_time::i_year($i_unix_time);

			$i_out=mktime($i_hour,$i_minute,$i_second,
					$i_month,$i_date,$i_year);
			return $i_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // i_ceil_2_day

} // sirel_unix_time


// ---------------------------------------------------------

?>
