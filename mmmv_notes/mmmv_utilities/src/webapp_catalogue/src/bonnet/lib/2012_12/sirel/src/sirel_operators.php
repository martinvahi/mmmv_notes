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
require_once('sirel_ix.php');
// ---------------------------------------------------------

// The class sirel_operators allows oprator overloading
// and in general it also follows a rule that no
// function there uses any global or class variables.
// The exceptions to the global and class variable usage
// is the usage of declared functions.
//
// The fact that neither class nor global variables, 
// except functions, are used allowes the sirel_operators
// functions to be used in recursive functions, unless that
// rule is not followed by the code that instanteates and
// registeres operator functions.
//
// The main idea behind the operator overloadability is to
// allow the operator functions to be somewhat reusable in the
// mathematical sense.
class sirel_operators {
	private static $arht_operators=array();
	private static $s_separ='_||||-sEpAratOr-||||_';

//--------------------------------------------------------------------
	public static function s_signature(&$s_operator_name,
			&$ar_operargsamples) {
		try {
			$s_separ=&sirel_operators::$s_separ;
			$s_signature=''.$s_operator_name.$s_separ;
			$i_len=count($ar_operargsamples);
			$x_elem=NULL;
			$s_typename=NULL;
			for($i=0;$i<$i_len;$i++) {
				$x_elem=$ar_operargsamples[$i];
				$s_typename=sirelLang::type_2_s($x_elem);
				$s_signature=$s_signature.$s_typename.$s_separ;
			} // for
			return $s_signature;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_signature

//--------------------------------------------------------------------
	// The classical $s_operator_name values are "+", "-", "*","/","mod".
	//
	// The operand type names are used only for choosing the right
	// operator. This means that the number of actual operands can be
	// greater than the number of operand types declared here.
	public static function declare_operator($func_id_est_callback,
			$s_operator_name,$x_first_operand_example) {
		try {
			$ar_args=func_get_args();
			$i_n_of_args=count($ar_args);
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name);
				if($i_n_of_args<3) {
					// The requirement that an operator has to
					// take at least one operand is mainly to increase the
					// likelyhood of detecting client code mistakes.
					// It can be refactored out later without the need to
					// change the client code.
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The operator is expected to take at least one '.
							'argument. $i_n_of_args=='.$i_n_of_args);
				} // if
				if(function_exists($func_id_est_callback)==False) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The function that is declared to implement the '.
							'operator does not exist. $func_id_est_callback=='.
							$func_id_est_callback);
				} // if
			} // if
			$ar_operargsamples=array();
			$x_elem=NULL;
			for($i=2;$i<$i_n_of_args;$i++) {
				$x_elem=$ar_args[$i];
				array_push($ar_operargsamples, $x_elem);
			} // for
			$s_signature=sirel_operators::s_signature($s_operator_name,
					$ar_operargsamples);
			sirel_operators::$arht_operators[$s_signature]=$func_id_est_callback;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // declare_operator

//--------------------------------------------------------------------
	public static function declare_binary_operator_for_numbers($func_id_est_callback,
			$s_operator_name) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name);
				if(function_exists($func_id_est_callback)==False) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The function that is declared to implement the '.
							'operator does not exist. $func_id_est_callback=='.
							$func_id_est_callback);
				} // if
			} // if
			sirel_operators::declare_operator($func_id_est_callback,
					$s_operator_name,42,42);
			sirel_operators::declare_operator($func_id_est_callback,
					$s_operator_name,42.0,42.0);
			sirel_operators::declare_operator($func_id_est_callback,
					$s_operator_name,42.0,42);
			sirel_operators::declare_operator($func_id_est_callback,
					$s_operator_name,42,42.0);
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // declare_binary_operator_for_numbers

//--------------------------------------------------------------------
	// In addition to the $s_operator_name it
	// accepts opntionally any number of arguments, which
	// are used for type identification. The type names are
	// used for searching a specific operator instance. The
	// order of the optional arguments is relevant, i.e. matters.
	//
	// The search algorighm is that one assembles a signature and
	// then searches for an exact match, which means that one should
	// provide exactly as many optional arguments as was provided
	// during the declaration of the operator.
	public static function b_operator_defined($s_operator_name,
			$x_first_operand_example) {
		try {
			$ar_args=func_get_args();
			$i_n_of_args=count($ar_args);
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name);
				if($i_n_of_args<2) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The operator is expected to take at least one '.
							'argument. $i_n_of_args=='.$i_n_of_args);
				} // if
			} // if
			$ar_operargsamples=array();
			$x_elem=NULL;
			for($i=1;$i<$i_n_of_args;$i++) {
				$x_elem=$ar_args[$i];
				array_push($ar_operargsamples, $x_elem);
			} // for
			$s_signature=sirel_operators::s_signature($s_operator_name,
					$ar_operargsamples);
			$b_is_defined=array_key_exists($s_signature,
					sirel_operators::$arht_operators);
			return $b_is_defined;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // b_operator_defined

	// The same as the sirel_operators::b_operator_defined, except that
	// it takes an array of operand examples in stead of the operand
	// examples themselves.
	public static function b_operator_defined_ar($s_operator_name,
			&$ar_operand_examples) {
		try {
			$i_n_of_operand_examples=count($ar_operand_examples);
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$ar_operand_examples);
				if($i_n_of_operand_examples<1) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The operator is expected to take at least one '.
							'argument. $i_n_of_operand_examples=='.
							$i_n_of_operand_examples);
				} // if
			} // if
			$s_signature=sirel_operators::s_signature($s_operator_name,
					$ar_operand_examples);
			$b_is_defined=array_key_exists($s_signature,
					sirel_operators::$arht_operators);
			return $b_is_defined;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // b_operator_defined_ar

//--------------------------------------------------------------------
	// A really, dirty, nasty, bug in the PHP implementation
	// causes the call_user_func_array(...) to return NULL for
	// some functions even, if all the function attributes are OK
	// the function is acessible (as can be verified from the code of
	// this function) and so forth.
	//
	// The bug seems to be that the call_user_func_array(...)
	// is not able to handle functions that have been delcared to
	// take their arguments as references.
	private static function exec_PHP_bug_workarounds(&$func,
			&$ar_operargsamples,&$op_tmp) {
		try {
			$x_out=NULL;
			if($func=='func_sirel_operators_set_1_sirelOP_round_with_sb_failure_handling_t1') {
				$arg_0=$ar_operargsamples[0];
				$arg_1=$ar_operargsamples[1];
				$x_out=func_sirel_operators_set_1_sirelOP_round_with_sb_failure_handling_t1($arg_0,$arg_1);
				$op_tmp->value=$x_out;
				return;
			} // if
			if($func=='func_sirel_operators_to_fd_t1') {
				$arg_0=$ar_operargsamples[0];
				if(count($ar_operargsamples)==1) {
					$x_out=func_sirel_operators_to_fd_t1($arg_0);
				} else {
					$arg_1=$ar_operargsamples[1];
					$x_out=func_sirel_operators_to_fd_t1($arg_0,$arg_1);
				} // else
				$op_tmp->value=$x_out;
				return;
			} // if
			$op_tmp->sb_failure=False;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // exec_PHP_bug_workarounds

	private static function exec_common(&$s_signature,&$ar_operargsamples) {
		try {
			$func=sirel_operators::$arht_operators[$s_signature];
			$op_tmp=new sirelOP();
			$x_out=NULL;
			sirel_operators::exec_PHP_bug_workarounds($func,
					$ar_operargsamples,$op_tmp);
			if($op_tmp->sb_failure) {
				$x_out=&$op_tmp->value;
			} else {
				$x_out=call_user_func_array($func, $ar_operargsamples);
			} // else
			return $x_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // exec_common

	public static function exec($s_operator_name,$x_first_operand) {
		try {
			$ar_args=func_get_args();
			$i_n_of_args=count($ar_args);
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name);
				if($i_n_of_args<2) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The operator is expected to take at least one '.
							'argument. $i_n_of_args=='.$i_n_of_args);
				} // if
			} // if
			$ar_operargsamples=array();
			$x_elem=NULL;
			for($i=1;$i<$i_n_of_args;$i++) {
				$x_elem=&$ar_args[$i];
				array_push($ar_operargsamples, $x_elem);
			} // for
			$s_signature=sirel_operators::s_signature($s_operator_name,
					$ar_operargsamples);
			if(sirelSiteConfig::$debug_PHP) {
				$b_is_defined=array_key_exists($s_signature,
						sirel_operators::$arht_operators);
				if($b_is_defined==FALSE) {
					$s_msg='Operator not found for signature '.$s_signature.
							"\n".' <br/>';
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.$s_msg);
				} // if
				$func=sirel_operators::$arht_operators[$s_signature];
				if(is_callable($func)==False) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The function is not callable. $func=='.$func);
				} // if
			} // if
			$x_out=sirel_operators::exec_common($s_signature,
					$ar_operargsamples);
			return $x_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} //exec

	public static function exec_ar($s_operator_name,&$ar_operator_operands) {
		try {
			$i_n_of_operator_operands=count($ar_operator_operands);
			if(sirelSiteConfig::$debug_PHP) {
				if($i_n_of_operator_operands<1) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The operator is expected to take at least one '.
							'argument. $i_n_of_operator_operands=='.
							$i_n_of_operator_operands);
				} // if
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_array',$ar_operator_operands);
			} // if
			$s_signature=sirel_operators::s_signature($s_operator_name,
					$ar_operator_operands);
			if(sirelSiteConfig::$debug_PHP) {
				$b_is_defined=array_key_exists($s_signature,
						sirel_operators::$arht_operators);
				if($b_is_defined==False) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'Operator not found for signature '.$s_signature);
				} // if
				$func=sirel_operators::$arht_operators[$s_signature];
				if(is_callable($func)==False) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'The function is not callable. $func=='.$func);
				} // if
			} // if
			$x_out=sirel_operators::exec_common($s_signature,
					$ar_operator_operands);
			return $x_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // exec_ar

//--------------------------------------------------------------------
} // class sirel_operators

//--------------------------------------------------------------------
function func_sirel_operators_plus_num_implicitcastless($x_a,$x_b) {
	try {
		$x_out=$x_a+$x_b;
		return $x_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_plus_num_implicitcastless

function func_sirel_operators_plus_num_cast2float($x_a,$x_b) {
	try {
		$fd_out=(1.0*$x_a)+(1.0*$x_b);
		return $fd_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_plus_num_cast2float

sirel_operators::declare_operator('func_sirel_operators_plus_num_implicitcastless',
		'+',42,42);
sirel_operators::declare_operator('func_sirel_operators_plus_num_implicitcastless',
		'+',42.0,42.0);

sirel_operators::declare_operator('func_sirel_operators_plus_num_cast2float',
		'+',42.0,42);
sirel_operators::declare_operator('func_sirel_operators_plus_num_cast2float',
		'+',42,42.0);
//--------------------------------------------------------------------
function func_sirel_operators_minus_num_implicitcastless($x_a,$x_b) {
	try {
		$x_out=$x_a-$x_b;
		return $x_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_minus_num_implicitcastless

function func_sirel_operators_minus_num_cast2float($x_a,$x_b) {
	try {
		$fd_out=(1.0*$x_a)-(1.0*$x_b);
		return $fd_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_minus_num_cast2float

sirel_operators::declare_operator('func_sirel_operators_minus_num_implicitcastless',
		'-',42,42);
sirel_operators::declare_operator('func_sirel_operators_minus_num_implicitcastless',
		'-',42.0,42.0);

sirel_operators::declare_operator('func_sirel_operators_minus_num_cast2float',
		'-',42.0,42);
sirel_operators::declare_operator('func_sirel_operators_minus_num_cast2float',
		'-',42,42.0);

//--------------------------------------------------------------------
function func_sirel_operators_multiply_num_implicitcastless($x_a,$x_b) {
	try {
		$x_out=$x_a*$x_b;
		return $x_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_multiply_num_implicitcastless

function func_sirel_operators_multiply_num_cast2float($x_a,$x_b) {
	try {
		$fd_out=(1.0*$x_a)*(1.0*$x_b);
		return $fd_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_multiply_num_cast2float

sirel_operators::declare_operator('func_sirel_operators_multiply_num_implicitcastless',
		'*',42,42);
sirel_operators::declare_operator('func_sirel_operators_multiply_num_implicitcastless',
		'*',42.0,42.0);

sirel_operators::declare_operator('func_sirel_operators_multiply_num_cast2float',
		'*',42.0,42);
sirel_operators::declare_operator('func_sirel_operators_multiply_num_cast2float',
		'*',42,42.0);

//--------------------------------------------------------------------
function func_sirel_operators_divide_num_implicitcastless($x_a,$x_b) {
	try {
		$x_out=$x_a/$x_b;
		return $x_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_divide_num_implicitcastless

function func_sirel_operators_divide_num_cast2float($x_a,$x_b) {
	try {
		$fd_out=(1.0*$x_a)/(1.0*$x_b);
		return $fd_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_divide_num_cast2float

sirel_operators::declare_operator('func_sirel_operators_divide_num_implicitcastless',
		'/',42,42); // According to selftests, there's no truncation, i.e. 7/2==3.5
sirel_operators::declare_operator('func_sirel_operators_divide_num_implicitcastless',
		'/',42.0,42.0);

sirel_operators::declare_operator('func_sirel_operators_divide_num_cast2float',
		'/',42.0,42);
sirel_operators::declare_operator('func_sirel_operators_divide_num_cast2float',
		'/',42,42.0);

//--------------------------------------------------------------------

function func_sirel_operators_to_s_int_and_float_and_s($x_a) {
	try {
		$s_out=''.$x_a;
		return $s_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_to_s_int_and_float_and_s

sirel_operators::declare_operator('func_sirel_operators_to_s_int_and_float_and_s',
		'to_s',42);
sirel_operators::declare_operator('func_sirel_operators_to_s_int_and_float_and_s',
		'to_s',42.2);
sirel_operators::declare_operator('func_sirel_operators_to_s_int_and_float_and_s',
		'to_s','42');

// ------------------------------------------------------------------------

// Exists for speed only, because the
// sirel_type_normalizations::to_fd is a bit expensive.
function func_sirel_operators_set_1_to_fd_fd($x_a) {
	try {
		$fd1=$x_a;
		return $fd1;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_set_1_to_fd_fd

sirel_operators::declare_operator('func_sirel_operators_set_1_to_fd_fd',
		'to_fd',42.0);

// Exists for speed only, because the
// sirel_type_normalizations::to_fd is a bit expensive.
function func_sirel_operators_set_1_to_fd_int($x_a) {
	try {
		$fd1=$x_a*1.0;
		return $fd1;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_set_1_to_fd_int

sirel_operators::declare_operator('func_sirel_operators_set_1_to_fd_int',
		'to_fd',42);

function func_sirel_operators_set_1_to_fd_s($x_a) {
	try {
		$fd1=sirel_type_normalizations::to_fd($x_a); // a bit heavy
		return $fd1;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_operators_set_1_to_fd_s

sirel_operators::declare_operator('func_sirel_operators_set_1_to_fd_s',
		'to_fd','42');

//--------------------------------------------------------------------

// It's just a namespace for the implementation of the
// func_sirel_map
class sirel_map_impl {

	private static function ar_b_is_array_create(&$ar_funcargs,
			&$i_n_of_funcargs) {
		try {
			$ar_b_is_array=array();
			$x_elem=NULL;
			$s_type=NULL;
			$s_type_array='sirelTD_is_array'; // instance reuse
			for($i=1;$i<$i_n_of_funcargs;$i++) {
				$x_elem=$ar_funcargs[$i];
				$s_type=sirelLang::type_2_s($x_elem);
				if(sirelLang::str1EqualsStr2($s_type, $s_type_array)) {
					array_push($ar_b_is_array, True);
				} else {
					array_push($ar_b_is_array, False);
				} // else
			} // for
			return $ar_b_is_array;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_b_is_array_create

	private static function ar_of_arht_operands_create(&$ar_funcargs,
			&$i_n_of_funcargs) {
		try {
			$ar_of_ar_operands=array();
			$x_elem=NULL;
			for($i=1;$i<$i_n_of_funcargs;$i++) {
				$x_elem=$ar_funcargs[$i];
				array_push($ar_of_ar_operands, $x_elem);
			} // for
			return $ar_of_ar_operands;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_of_arht_operands_create

	private static function arht_of_ix_2_operands_arht_key_create(&$ar_of_arht_operands,
			&$ar_b_is_array,&$i_n_of_operands) {
		try {
			$arht_of_ix_2_operands_arht_key=array();
			$b_is_array=NULL;
			$arht_operands=NULL;
			for($i=0;$i<$i_n_of_operands;$i++) {
				$b_is_array=$ar_b_is_array[$i];
				if($b_is_array) {
					$arht_operands=$ar_of_arht_operands[$i];
					$ii=0;
					$ar_keys=array_keys($arht_operands);
					foreach ($ar_keys as $x_key) {
						$arht_of_ix_2_operands_arht_key[$ii]=$x_key;
						$ii++;
					} // foreach
					break;
				} // if
			} // for
			if(sirelSiteConfig::$debug_PHP) {
				$arht_operands_arht_key_2_ix=sirel_ix::arht_swap_keys_and_values($arht_of_ix_2_operands_arht_key);
				// Verifies that all of the operand arrays have
				// exactly the same keys and length.
				$i_n_of_datapoints=count($arht_of_ix_2_operands_arht_key);
				for($i=0;$i<$i_n_of_operands;$i++) {
					$b_is_array=$ar_b_is_array[$i];
					if($b_is_array) {
						$arht_operands=$ar_of_arht_operands[$i];
						$ii=count($arht_operands);
						sirelLang::assert_range($i_n_of_datapoints,'<=',$ii, '<=',$i_n_of_datapoints, '$ii');
						$ii=0;
						$ar_keys=array_keys($arht_operands);
						foreach ($ar_keys as $x_key) {
							if(array_key_exists($x_key, $arht_operands_arht_key_2_ix)!=True) {
								throw new Exception('$i=='.$i.'  '.
										'$x_key=='.$x_key.'  line=='.__LINE__);
							} // if
						} // foreach
					} // if
				} // for
			} // if
			return $arht_of_ix_2_operands_arht_key;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_of_ix_2_operands_arht_key_create

	private static function ar_of_ar_operands_create(&$ar_of_arht_operands,
			&$ar_b_is_array,&$arht_operands_arht_key_2_ix,&$i_n_of_operands) {
		try {
			$ar_of_ar_operands=array();
			$b_is_array=NULL;
			$ar_operands=NULL;
			$arht_operands_or_x=NULL;
			$ar_keys=NULL;
			for($i=0;$i<$i_n_of_operands;$i++) {
				$arht_operands_or_x=$ar_of_arht_operands[$i];
				$b_is_array=$ar_b_is_array[$i];
				if($b_is_array) {
					$ar_operands=array();
					$ar_keys=array_keys($arht_operands_or_x);
					foreach ($ar_keys as $x_key) {
						$ar_operands[$arht_operands_arht_key_2_ix[$x_key]]=$arht_operands_or_x[$x_key];
					} // foreach
					array_push($ar_of_ar_operands,$ar_operands);
				} else {
					array_push($ar_of_ar_operands, $arht_operands_or_x);
				} // else
			} // for
			return $ar_of_ar_operands;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_of_ar_operands_create

	private static function arht_ar_out_ix_2_arht_out(&$ar_out_ix,
			&$arht_of_ix_2_operands_arht_key) {
		try {
			$arht_out=array();
			$ar_ixes=array_keys($ar_out_ix);
			foreach ($ar_ixes as $x_ix) {
				$arht_out[$arht_of_ix_2_operands_arht_key[$x_ix]]=$ar_out_ix[$x_ix];
			} // foreach
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_ar_out_ix_2_arht_out


	private static function ar_operands_create(&$ar_of_ar_operands,
			&$ar_b_is_array,&$i_operator_call_number_minu_one,
			&$i_n_of_operands) {
		try {
			$ar_operands=array();
			$x_elem=NULL;
			$b_is_array=NULL;
			$x_operand=NULL;
			for($i=0;$i<$i_n_of_operands;$i++) {
				$b_is_array=$ar_b_is_array[$i];
				$x_elem=$ar_of_ar_operands[$i];
				if($b_is_array) {
					$x_operand=$x_elem[$i_operator_call_number_minu_one];
				} else {
					$x_operand=$x_elem;
				} // else
				array_push($ar_operands, $x_operand);
			} // for
			return $ar_operands;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ar_operands_create

	public static function map(&$ar_funcargs) {
		$i_operator_call_number=0;
		try {
			$i_n_of_funcargs=count($ar_funcargs);
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_range(2, '<=', $i_n_of_funcargs, '*', 42, '$i_n_of_funcargs');
				$s_operator_name_or_func=$ar_funcargs[0];
				// At least in PHP 5.2 the functions do not differ from strings.
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name_or_func);
				// The rest of the funcargs can not be that simply checked
				// for types, because they are allowed to be literally
				// of any type, unless the function or operator
				// is not defined for them.
			} // if
			$s_operator_name_or_func=$ar_funcargs[0]; // can't put it before verification
			$ar_b_is_array=sirel_map_impl::ar_b_is_array_create($ar_funcargs,
					$i_n_of_funcargs);
			$i_n_of_operands=count($ar_b_is_array);
			$ar_of_arht_operands=sirel_map_impl::ar_of_arht_operands_create($ar_funcargs,
					$i_n_of_funcargs);

			$arht_of_ix_2_operands_arht_key=sirel_map_impl::arht_of_ix_2_operands_arht_key_create($ar_of_arht_operands,
					$ar_b_is_array,$i_n_of_operands);
			$arht_operands_arht_key_2_ix=sirel_ix::arht_swap_keys_and_values($arht_of_ix_2_operands_arht_key);
			$ar_of_ar_operands=sirel_map_impl::ar_of_ar_operands_create($ar_of_arht_operands,
					$ar_b_is_array,$arht_operands_arht_key_2_ix,$i_n_of_operands);

			if(sirelSiteConfig::$debug_PHP) {
				$i_2=count($ar_of_ar_operands);
				sirelLang::assert_range($i_n_of_operands, '<=', $i_2, '<=', $i_n_of_operands,
						'$i_n_of_operands==$i_2');
				$i_2=(-1);
				$i_3=NULL;
				$x_elem=NULL;
				$b_is_array=NULL;
				for($i=0;$i<$i_n_of_operands;$i++) {
					$b_is_array=$ar_b_is_array[$i];
					if($b_is_array) {
						$x_elem=$ar_of_ar_operands[$i];
						$i_3=count($x_elem);
						sirelLang::assert_range(1, '<=', $i_3, '*', 42,'$i_3');
						if($i_2==(-1)) {
							$i_2=$i_3;
						} else {
							if($i_3!=$i_2) {
								throw new Exception('$i_2=='.$i_2.
										'  $i_3=='.$i_3.'  $i=='.$i.
										' $s_operator_name_or_func=='.
										$s_operator_name_or_func);
							} // if
						} // else
					} // if
				} // for
			} // if
			$i_n_of_operator_calls=1; // a case, where no arrays have been given
			$x_elem=NULL;
			$b_is_array=NULL;
			for($i=0;$i<$i_n_of_operands;$i++) {
				$b_is_array=$ar_b_is_array[$i];
				if($b_is_array) {
					$x_elem=$ar_of_ar_operands[$i];
					$i_n_of_operator_calls=count($x_elem);
					// All of the arrays are expected to be of the
					// same length and that's enfoced in the debug
					// mode verifications just about 4 lines above
					// this for-block.
					break;
				} // if
			} // for
			$ar_out_ix=array();
			$ar_of_operands=NULL;
			$b_operator_is_defined=NULL; // value depends on operator operand types.
			$x_1=NULL;
			for($i=0;$i<$i_n_of_operator_calls;$i++) {
				$i_operator_call_number=$i;
				$ar_of_operands=sirel_map_impl::ar_operands_create($ar_of_ar_operands,
						$ar_b_is_array,$i,$i_n_of_operands);
				$b_operator_is_defined=sirel_operators::b_operator_defined_ar($s_operator_name_or_func,
						$ar_of_operands);
				if($b_operator_is_defined) {
					$x_1=sirel_operators::exec_ar($s_operator_name_or_func,
							$ar_of_operands);
				} else {
					if(sirelSiteConfig::$debug_PHP) {
						if(is_callable($s_operator_name_or_func)==False) {
							$s_signature=sirel_operators::s_signature($s_operator_name_or_func,
									$ar_of_operands) ;
							sirelThrowLogicException(__FILE__, __LINE__,
									__CLASS__.'->'.__FUNCTION__.': '.
									'The function '.$s_operator_name_or_func.
									'is not callable and an operator with a '.
									'signature of '.$s_signature.' has not '.
									'been defined.');
						} // if
					} // if
					$x_1=call_user_func_array($s_operator_name_or_func,
							$ar_of_operands);
				} // else
				array_push($ar_out_ix, $x_1);
			} // for
			$arht_out=sirel_map_impl::arht_ar_out_ix_2_arht_out(&$ar_out_ix,
					&$arht_of_ix_2_operands_arht_key);
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': '.
					'$i_operator_call_number=='.$i_operator_call_number);
		} // catch
	} // map

} // class sirel_map_impl

//--------------------------------------------------------------------
// The usage scenario is practically the same as it is with 
// the standard PHP array_map, but the main reason for implementing
// one's own version of the array_map is that the function instance
// does not depend only on the name of the operator but it also depends
// on the types of the operands.
// 
// That explains, why it is not possible to just query for the operator
// function and apply the standard array_map like this:
//
// $fung=sirel_operators::get_operator_function($s_operator_name);
// $ar_answers=array_map($func,$ar_first_operands,$ar_second_operands);
//
// The func_sirel_map contains a convenience feature that
// in stead of an array of values one can provide just
// one value, X, that is then interpreted as if it were an 
// array of values where all values equal to the X.
//
// An example:
//
// $ar_first_operands=array(11,13,17);
// $ar_sums=func_sirel_map('+',$ar_first_operands,5);
//
// The content of the $ar_sums will be : 16,18,22.
//
// The convenience feature will probably cause a crash or
// some other fault, if the X is an array, because it takes
// semantics to distinguish, how to interpret the X and the
// fact that X is an array or is of some other type is
// used for extracting the semantics.
//
// The implementation also works, if "hashtables" are used
// in stead of arrays. For example, the following code is correct:
// 
// $arht_1=array('hey'=>4,'ho'=>7);
// $arht_2=array('ho'=>22, 'hey=>52);
// $arht_sums_1=func_sirel_map('+',$arht_1,$arht_2);
// $arht_sums_2=func_sirel_map('+',$arht_1,11);
//
// The result: $arht_sums_1['hey']==56   $arht_sums_1['ho']==29
//             $arht_sums_2['hey']==15   $arht_sums_2['ho']==18
// It will probably crash, if the hashtables have different 
// key sets.
//
// It always returns an the PHP hashtableish array.
function func_sirel_map($s_operator_name_or_func) {
	try {
		$ar_funcargs=func_get_args();
		$ar_out=sirel_map_impl::map($ar_funcargs);
		return $ar_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_map

// It's the same as the func_sirel_map, except that
// in stead of accepting the "arrays" as arguments, it
// accepts an array of "arrays". The quotes are due to
// the convenience feature that is described within the
// description of the func_sirel_map.
function func_sirel_map_ar($s_operator_name_or_func,&$ar_the_rest) {
	try {
		if(sirelSiteConfig::$debug_PHP) {
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_mbstring',$s_operator_name_or_func);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_array',$ar_the_rest);
			$i=count($ar_the_rest);
			sirelLang::assert_range(1, '<=', $i, '*', 42,'$i');
		} // if
		$ar_1=array($s_operator_name_or_func);
		$ar_funcargs=array_merge($ar_1,$ar_the_rest);
		$ar_out=sirel_map_impl::map($ar_funcargs);
		return $ar_out;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // func_sirel_map_ar


//--------------------------------------------------------------------

?>

