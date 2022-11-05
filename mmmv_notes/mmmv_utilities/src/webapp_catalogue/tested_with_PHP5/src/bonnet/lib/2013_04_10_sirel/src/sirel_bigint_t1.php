<?php
//-------------------------------------------------------------------------
// Copyright (c) 2011, martin.vahi@softf1.com that has an
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
//-------------------------------------------------------------------------
require_once('sirel_operators.php');

// The sirelBigit implementation here is totally OK, except that
// not that many servers support the gnu bigint module. 
// that's why one has outcommented all of this file by using a
// single pair of /**/.

/*  

//-------------------------------------------------------------------------
// Converts an integer to base $i_output_base. The output is an array,
// where digits are integers. The least significant digit resides
// at index 0.
//
// The output returns an absolute value of the $i_in, i.e.
// the abs($i_in) is converted to base $i_output_base.
function func_sirel_operators_set_baseconversion_ar_int2baseX($i_in,
		$i_output_base) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_in);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_output_base);
		} // if
		if($i_output_base<2) {
			sirelThrowLogicException(__FILE__, __LINE__,
					__CLASS__.'->'.__FUNCTION__.': '.
					'The minimum allowed value of the '.
					'$i_output_base is 2, but the ||| '.
					'$i_output_base=='.$i_output_base);
		} // if
		$arht_out=array();
		if($i_in===0) {
			array_push($arht_out, 0);
			return $arht_out;
		} // if
		$i_reminder=NULL;
		$i_pile=abs($i_in);
		$b_go_on=True;
		while($i_output_base<=$i_pile) {
			$i_reminder=$i_pile%$i_output_base;
			array_push($arht_out, $i_reminder);
			$i_pile=($i_pile-$i_reminder)/$i_output_base;
		} // while
		array_push($arht_out, $i_pile);
		return $arht_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_set_baseconversion_ar_int2baseX

// It's declared here in stead of a separate
// operators PHP file to avoid a dependency loop
// and for efficiency, because the sirel_BigInt_t1 
// depends on the conversion.
sirel_operators::declare_operator(func_sirel_operators_set_baseconversion_ar_int2baseX,
		'ar_int2baseX',42,2);

//-------------------------------------------------------------------------
// The sirel_BigInt_t1 implements an arbitrary size integer.
//
// In its essence it's actually a wrapper to the PHP GNU MP 
// extension, but one of its benefits over the raw GNU MP
// functions is that it allows reliable type determination,
// which is essential for choosing functions according to operand 
// types in the operators framework.
//
// Another reason for preferring the wrapper to the raw use 
// of the the PHP GNU MP is that the GNU MP extension might not
// always be available.
class sirel_BigInt_t1 {
//-------------------------------------------------------------------------

	// There are representations: array_representation
	// and the GNU MP representation.
	protected $ob_GNU_MP_int=NULL; // always up to date
	protected $b_array_representation_is_up_to_date=False;

	// In the array_representation the integer is stored in binary format.
	// The motivation for prefering binary format to
	// the other formats consists of the following
	// 2 points:
	//
	// x) In binary format the arithmetic operations
	//    can be implemented in a simpler fashion than in
	//    otehr formats.
	//
	// x) In practice one needs transaction based persistance,
	//    which in practice it's implemented by using the standard
	//    SQL databases, but one also needs to
	//    computationally eficciently select ranges
	//    amongst "huge" sets of bigints and the most computationally
	//    cheapest solution that I, martin.vahi@softf1.com, was able
	//    to come up with in September 2011 is where the bigint is
	//    stored to the database by using 4 columns:
	//
	//     char {t,f}  | char {+,-} | int      | text
	//     sb_is_set   | s_sign     | i_length | s_binary_digits
	//
	//     An example:
	//        "t"      |     "+"    |    3     | "101"
	//        "t"      |     "+"    |    16    | "1000000000000000"
	//        "t"      |     "-"    |    5     | "10100"
	//        "t"      |     "+"    |    0     | ""

	protected $s_sign='+';

	// The lowest bit is at index 0 and
	// bits are in the form of integers, 0 and 1.
	// Leading zeros are not allowed, which is to say that
	// number 0 is depicted as an empty array.
	protected $arht_i_digits=array();

// ------------------------------------------------------------------------
	private function set_array_mode_value_by_string(&$s_value, &$s_sign) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_value);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_sign);
			} // if
			$this->b_array_representation_is_up_to_date=False;
			if(($s_sign!='+')&&($s_sign!='-')) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'$s_sign=='.$s_sign.
						' , but only "+" and "-" are supported.');
			} // if
			$i_s_value_length=mb_strlen($s_value);
			if($i_s_value_length<=0) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'The $s_value must not be an empty string. '.
						'||| $s_value=='.$s_value);
			} // if
			$this->s_sign=$s_sign;
			$this->arht_i_digits=array();
			$s_lc_char_0='0';
			$s_lc_char_1='1';
			if(sirelSiteConfig::$debug_PHP) {
				for($i=0;$i<$i_s_value_length;$i++) {
					$s_char=mb_substr($s_value, $i, 1);
					if(($s_char!=$s_lc_char_0)&&($s_char!=$s_lc_char_1)) {
						sirelThrowLogicException(__FILE__, __LINE__,
								__CLASS__.'->'.__FUNCTION__.': '.
								'The string is allowed to consist of '.
								'only 0-s and 1-s., but the $s_value=='.
								$s_value);
					} // if
				} // for
			} // if
			// One has to cope with strings like '000101', which
			// is equivalent with '101'.
			$s_pile=mb_ereg_replace('^[0]+', '', $s_value);
			$i_s_pile_length=mb_strlen($s_pile);
			if($i_s_pile_length==0) {
				// The input string is in the style of '00000' or '0'.
				$this->s_sign='+';
				$this->b_array_representation_is_up_to_date=True;
				return;
			} // if

			for($i=$i_s_pile_length-1;0<=$i;$i--) {
				$s_char=mb_substr($s_pile, $i, 1);
				if($s_char==$s_lc_char_0) {
					array_push($this->arht_i_digits,0);
				} else {
					array_push($this->arht_i_digits,1);
				} // else
			} // for
			$this->b_array_representation_is_up_to_date=True;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_array_mode_value_by_string

// ------------------------------------------------------------------------
	private function set_ob_gnump_value_by_string(&$s_value, &$s_sign) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_value);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_sign);
			} // if
			$this->b_array_representation_is_up_to_date=False;
			if(($s_sign!='+')&&($s_sign!='-')) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'$s_sign=='.$s_sign.
						' , but only "+" and "-" are supported.');
			} // if
			$i_s_value_length=mb_strlen($s_value);
			if($i_s_value_length<=0) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'The $s_value must not be an empty string. '.
						'||| $s_value=='.$s_value);
			} // if
			if(sirelSiteConfig::$debug_PHP) {
				$s_lc_char_0='0';
				$s_lc_char_1='1';
				for($i=0;$i<$i_s_value_length;$i++) {
					$s_char=mb_substr($s_value, $i, 1);
					if(($s_char!=$s_lc_char_0)&&($s_char!=$s_lc_char_1)) {
						sirelThrowLogicException(__FILE__, __LINE__,
								__CLASS__.'->'.__FUNCTION__.': '.
								'The string is allowed to consist of '.
								'only 0-s and 1-s., but the $s_value=='.
								$s_value);
					} // if
				} // for
			} // if
			// One has to cope with strings like '000101', which
			// is equivalent with '101'.
			$s_pile=mb_ereg_replace('^[0]+', '', $s_value);
			$i_s_pile_length=mb_strlen($s_pile);
			if($i_s_pile_length==0) {
				// The input string is in the style of '00000' or '0'.
				$this->ob_GNU_MP_int=gmp_init(0);
				return;
			} // if
			$ibignu_1=gmp_init($s_pile,2);
			if($s_sign=='+') {
				$this->ob_GNU_MP_int=&$ibignu_1;
			} else { // $s_sign=='-'
				$this->ob_GNU_MP_int=gmp_neg($ibignu_1);
			} // else
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_ob_gnump_value_by_string

// ------------------------------------------------------------------------
	private function update_array_mode() {
		try {
			$s_value=NULL;
			$s_sign='+';
			if(gmp_sign($this->ob_GNU_MP_int)<0) {
				$s_sign='-';
				$s_value=gmp_strval(gmp_neg($this->ob_GNU_MP_int),2);
			} else {
				$s_value=gmp_strval($this->ob_GNU_MP_int,2);
			} // else
			$this->set_array_mode_value_by_string($s_value, $s_sign);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // update_array_mode

// ------------------------------------------------------------------------
	// If the $s_or_i_or_BigInt is of type string, then the $s_sign
	// must have a value of "+" or "-" and the string has to
	// consist of only characters "0" or "1" or the string has
	// to be an empty string, which denotes integer zero, regardless
	// of wether the $s_sign has a value of "+" or "-".
	//
	// If the $s_or_i_or_BigInt is of type integer or of
	// type sirel_BigInt_t1, then the $s_sign has to be NULL.
	public function set_value(&$s_or_i_or_BigInt, $s_sign=NULL) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,
						'sirelTD_is_mbstring,sirelTD_is_int,sirelTD_is_class_sirel_BigInt_t1,sirelTD_is_resource',
						$s_or_i_or_BigInt);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring,sirelTD_is_null',$s_sign);
				$s_type=sirelLang::type_2_s($s_or_i_or_BigInt);
				if($s_type=='sirelTD_is_mbstring') {
					sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
							__FUNCTION__,'sirelTD_is_mbstring',$s_sign);
				} else {
					sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
							__FUNCTION__,'sirelTD_is_null',$s_sign);
				} // else
			} // if
			$this->b_array_representation_is_up_to_date=False;
			$s_type=sirelLang::type_2_s($s_or_i_or_BigInt);
			if($s_type=='sirelTD_is_mbstring') {
				if(sirelSiteConfig::$debug_PHP) {
					for($i=0;$i<$i_s_value_length;$i++) {
						$s_char=mb_substr($s_value, $i, 1);
						if(($s_char!=$s_lc_char_0)&&($s_char!=$s_lc_char_1)) {
							sirelThrowLogicException(__FILE__, __LINE__,
									__CLASS__.'->'.__FUNCTION__.': '.
									'The string is allowed to consist of '.
									'only 0-s and 1-s.');
						} // if
					} // for
				} // if
				$s_value=$s_or_i_or_BigInt;
				$this->set_ob_gnump_value_by_string($s_value, $s_sign);
			} else {
				if(($s_type=='sirelTD_is_int')) {
					$i_in=$s_or_i_or_BigInt;
					$this->ob_GNU_MP_int=gmp_init($i_in);
				} else {
					if($s_type=='sirelTD_is_class_sirel_BigInt_t1') {
						$ibi_in_gnu=&$s_or_i_or_BigInt->ob_GNU_MP_int;
						// The gmp_init handles the '-' at the index 0
						// of the $s_tmp
						$s_tmp=gmp_strval($ibi_in_gnu,2);
						$this->ob_GNU_MP_int=gmp_init($s_tmp,2);
					} else {
						if($s_type=='sirelTD_is_resource') {
							// the GNU MP integer
							$ibi_in_gnu=&$s_or_i_or_BigInt;
							$s_tmp=gmp_strval($ibi_in_gnu,2);
							$this->ob_GNU_MP_int=gmp_init($s_tmp,2);
						} else {
							sirelThrowLogicException(__FILE__, __LINE__,
									__CLASS__.'->'.__FUNCTION__.': '.
									'The code has a flaw. $s_type=='.
									$s_type.'  $s_or_i_or_BigInt=='.
									$s_or_i_or_BigInt);
						} // else
					} // else
				} // else
			} // else
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_value

//-------------------------------------------------------------------------
	// $s_sign inSet {'-','+'}
	public function set_sign($s_sign) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_sign);
			} // if
			$b_gmp_is_positive=True;
			if(gmp_sign($this->ob_GNU_MP_int)<0) {
				$b_gmp_is_positive=False;
			} // if
			if($s_sign=='+') {
				if(!$b_gmp_is_positive) {
					$this->ob_GNU_MP_int=gmp_neg($this->ob_GNU_MP_int);
				} // if
			} else {
				if($s_sign=='-') {
					if($b_gmp_is_positive) {
						$this->ob_GNU_MP_int=gmp_neg($this->ob_GNU_MP_int);
					} // if
				} else {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The $s_sign must be either \'-\' or '.
							'\'+\', but the $s_sign=='.$s_sign);
				} // else
			} // else
			$this->s_sign=$s_sign;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_sign

//-------------------------------------------------------------------------
	// Parameters are the same as the method set_value
	// has.
	public function __construct($s_or_i_or_BigInt, $s_sign=NULL) {
		try {
			$this->set_value($s_or_i_or_BigInt,$s_sign);
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // constructor

//-------------------------------------------------------------------------
	private function s_get_absolute_value_in_base_2_from_array_representation() {
		try {
			$arht_digits=&$this->arht_i_digits;
			$i_n_of_digits=count($arht_digits);
			if($i_n_of_digits==0) {
				$s_out='0';
				return $s_out;
			} // if
			$s_lc_emptystring='';
			$s_out=$s_lc_emptystring;
			$i_len=count($arht_digits);
			$x_elem=NULL;
			for($i=0;$i<$i_len;$i++) {
				$x_elem=$arht_digits[$i];
				$s_out=$s_lc_emptystring.$x_elem.$s_out;
			} // for
			return $s_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_get_absolute_value_in_base_2_from_array_representation

//-------------------------------------------------------------------------
	public function s_get_absolute_value_in_base_2() {
		try {
			$s_out=NULL;
			// The reason, why one does not use the gmp_abs
			// here is that the gmp_abs creates a new GNU MP
			// integer instance, but the PHP solution here
			// avoids the instantiation in some cases.
			if(gmp_sign($this->ob_GNU_MP_int)<0) {
				$s_out=gmp_strval(gmp_neg($this->ob_GNU_MP_int), 2);
			} else {
				$s_out=gmp_strval($this->ob_GNU_MP_int, 2);
			} // else
			return $s_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_get_absolute_value_in_base_2

//-------------------------------------------------------------------------
	public function s_get_sign() {
		try {
			$i_sign=gmp_sign($this->ob_GNU_MP_int);
			$s_out=NULL;
			if($i_sign<0) {
				$s_out='-';
			} else {
				$s_out='+';
			} // else
			return $s_out;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_get_sign

//-------------------------------------------------------------------------
	public function add(&$i_or_BigInt) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,
						'sirelTD_is_int,sirelTD_is_class_sirel_BigInt_t1',
						$i_or_BigInt);
			} // if
			$this->b_array_representation_is_up_to_date=False;
			$x_in=NULL;
			$s_type=sirelLang::type_2_s($i_or_BigInt);
			if($s_type=='sirelTD_is_int') {
				$x_in=&$i_or_BigInt;
			} else {
				$x_in=&$i_or_BigInt->ob_GNU_MP_int;
			} // if
			$ibi_this_gnu=&$this->ob_GNU_MP_int;
			$this->ob_GNU_MP_int=gmp_add($x_in,$ibi_this_gnu);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} //add

//-------------------------------------------------------------------------
	public function mul(&$i_or_BigInt) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,
						'sirelTD_is_int,sirelTD_is_class_sirel_BigInt_t1',
						$i_or_BigInt);
			} // if
			$this->b_array_representation_is_up_to_date=False;
			$x_in=NULL;
			$s_type=sirelLang::type_2_s($i_or_BigInt);
			if($s_type=='sirelTD_is_int') {
				$x_in=&$i_or_BigInt;
			} else {
				$x_in=&$i_or_BigInt->ob_GNU_MP_int;
			} // if
			$ibi_this_gnu=&$this->ob_GNU_MP_int;
			$this->ob_GNU_MP_int=gmp_mul($x_in, $ibi_this_gnu);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} //mul

//-------------------------------------------------------------------------
	// Multiplies the number with (-1), i.e. negates the number.
	public function neg() {
		try {
			$this->b_array_representation_is_up_to_date=False;
			$this->ob_GNU_MP_int=gmp_neg($this->ob_GNU_MP_int);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} //neg

//-------------------------------------------------------------------------
} // sirel_BigInt_t1

//-------------------------------------------------------------------------

function func_sirel_operators_BigInt_t1_add_ibi_int($ibi_a,$i_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($i_b);
		$ibi_out->add($ibi_a);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_add_ibi_int

function func_sirel_operators_BigInt_t1_add_int_ibi($i_a,$ibi_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($i_a);
		$ibi_out->add($ibi_b);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_add_int_ibi

function func_sirel_operators_BigInt_t1_add_ibi_ibi($ibi_a,$ibi_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($ibi_a);
		$ibi_out->add($ibi_b);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_add_ibi_ibi

// The reason, why there are 3 separate functions in stead of just
// one with type detection is that the 3-function solution is
// computationally more efficient. The operator execution
// routine chooses the function according to operand types.
// The single-function solution would duplicate the relatively
// expensive type determination calls.
$ibi_1=new sirel_BigInt_t1(42);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_add_ibi_int,
		'+',$ibi_1,42);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_add_int_ibi,
		'+',42,$ibi_1);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_add_ibi_ibi,
		'+',$ibi_1,$ibi_1);

//-------------------------------------------------------------------------
function func_sirel_operators_BigInt_t1_add_substract_ibi_int($ibi_a,$i_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($i_b);
		$ibi_out->neg();
		$ibi_out->add($ibi_a);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_add_substract_ibi_int

function func_sirel_operators_BigInt_t1_add_substract_int_ibi($i_a,$ibi_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_b);
		} // if
		// a - b = -(b - a) = -(b + (-a))
		// The trickery is based on an assumption that in the case of
		// truly huge numbers it's cheaper to negate a number than
		// to instantiate a number.
		$ibi_out=new sirel_BigInt_t1($i_a);
		$ibi_out->neg();
		$ibi_out->add($ibi_b);
		$ibi_out->neg();
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_add_substract_int_ibi

function func_sirel_operators_BigInt_t1_add_substract_ibi_ibi($ibi_a,$ibi_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($ibi_b);
		$ibi_out->neg();
		$ibi_out->add($ibi_a);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_add_substract_ibi_ibi

sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_add_substract_ibi_int,
		'-',$ibi_1,42);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_add_substract_int_ibi,
		'-',42,$ibi_1);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_add_substract_ibi_ibi,
		'-',$ibi_1,$ibi_1);

//-------------------------------------------------------------------------
function func_sirel_operators_BigInt_t1_mul_ibi_int($ibi_a,$i_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($i_b);
		$ibi_out->mul($ibi_a);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_mul_ibi_int

function func_sirel_operators_BigInt_t1_mul_int_ibi($i_a,$ibi_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int',$i_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($i_a);
		$ibi_out->mul($ibi_b);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_mul_int_ibi

function func_sirel_operators_BigInt_t1_mul_ibi_ibi($ibi_a,$ibi_b) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_a);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_class_sirel_BigInt_t1',$ibi_b);
		} // if
		$ibi_out=new sirel_BigInt_t1($ibi_a);
		$ibi_out->mul($ibi_b);
		return $ibi_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_BigInt_t1_mul_ibi_ibi

sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_mul_ibi_int,
		'*',$ibi_1,42);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_mul_int_ibi,
		'*',42,$ibi_1);
sirel_operators::declare_operator(func_sirel_operators_BigInt_t1_mul_ibi_ibi,
		'*',$ibi_1,$ibi_1);
*/

//-------------------------------------------------------------------------

?>
