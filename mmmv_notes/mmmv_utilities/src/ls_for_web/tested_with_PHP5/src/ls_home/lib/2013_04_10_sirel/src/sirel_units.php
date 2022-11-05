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

// It's used for unit conversion.
//
// In order to avoid parsing strings, one uses the following units
// precedence: m, kg, s, A, K, cd, mol
//
// The precedence of the rest of the units, the ones that have been 
// derived from the Si units, is in alphabetical order, starting with 
// lower case greek letters, then continuing with upper case greek letters,
// then with lower case latin letters and after that come the 
// upper case latin letters. 
//
class sirel_units {

// It's not always possible to perform unit conversion by
// executing a single multiplication, i.e. by multiplying
// the origin unit with a constant and get the destination unit.
//
// Temperature units is one such example.
//
// For the sake of speed and generality the implementation here
// is based on an idea that units, and that includes composite units
// like the meters per second, are graph vertices.
// The graph edges are conversion functions.
//
// A complete unidirected graph
// (http://mathworld.wolfram.com/CompleteGraph.html )
// that has n vertices, has n*(n-1)/2=(n^2-n)/2 edges.
// A directed graph has  n^2-n directed edges. In anohter words,
// the there are "a lot of" edges. That in turn entails that
// it makes sense to create only those conversion function
// instances that are actually needed and cache them.
//

// key==<a string in a format of "originunit -> destinationunit"
	protected static $arht_conversion_functions=array();

// Units precedence: m, kg, s, A, K, cd, mol
	protected static $arht_supported_nonSi_units=array('km'=>42,'cm'=>42,'mm'=>42,'t'=>42,'g'=>42,'mg'=>42,'l'=>42,'cm^3'=>42,'t/(m^3)'=>42,'kg/l'=>42,'g/l'=>42,'g/(cm^3)'=>42,'mg/l'=>42,'mg/(cm^3)'=>42);

// For editing aid:
// array('km'=>42,'cm'=>42,'mm'=>42,
// 't'=>42,'g'=>42,'mg'=>42,
// 'l'=>42,'cm^3'=>42,
// 't/(m^3)'=>42,'kg/l'=>42,'g/l'=>42,'g/(cm^3)'=>42,'mg/l'=>42,'mg/(cm^3)'=>42,
//  );
//

	protected static $arht_supported_Si_units=array('m'=>42,'kg'=>42, 'm^3'=>42, 'kg/(m^3)'=>42);

// For editing aid:
// array('m'=>42,'kg'=>42,
// 'm^3'=>42,
// 'kg/(m^3)'=>42);

//------------------------------------------------------------------
// Returns True, if the unit is not supported by this class.
//
// This method is not public, because even if the conversion
// from unit x to unit y is implemented in this class, there
// are probably many units, to which it is theoretically possible
// to convert values from units x, but the conversion is not
// yet implemented by this class.
//
// As a result, the meaning of a a unit support is a bit vague
// and quite specific to this class.
	protected static function b_unit_not_supported(&$s_unit) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_unit);
			} // if
			$b_out=True;
			if(array_key_exists($s_unit, sirel_units::$arht_supported_Si_units)) {
				$b_out=False;
				return $b_out;
			} //if
			if(array_key_exists($s_unit, sirel_units::$arht_supported_nonSi_units)) {
				$b_out=False;
			} //if
			return $b_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // b_unit_not_supported

//------------------------------------------------------------------
	private static function assert_unit_supported(&$s_unit) {
		try {
			if(sirel_units::b_unit_not_supported($s_unit)) {
				throw new Exception('Unit "'.$s_unit.'" is not yet '.
						'supported by this class.');
			} // if
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // assert_unit_supported

//------------------------------------------------------------------
	private static function create_func_1($s_conversion_constant) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',
						$s_conversion_constant);
			} // if
			$func_out=create_function('$fd_value_in_origin_units',
					'$fd_out=(1.0*$fd_value_in_origin_units)*'.
					$s_conversion_constant.';'.
					'return $fd_out;');
			return $func_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_func_1

//------------------------------------------------------------------
	private static function create_conversion_function_orig_density(&$s_destination_unit,
			&$s_origin_unit,&$s_exc_destination_unit_not_found) {
		try {
			$func_out=NULL;
			if(sirelLang::str1EqualsStr2($s_origin_unit, 't/(m^3)')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1000000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'kg/(m^3)')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'kg/l')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1000000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'g/l')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'g/(cm^3)')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1000000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'mg/l')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'mg/(cm^3)')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 't/(m^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/(m^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg/l')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g/(cm^3)')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg/(cm^3)')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if

			return $func_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_conversion_function_orig_density

//------------------------------------------------------------------
	private static function create_conversion_function_orig_length(&$s_destination_unit,
			&$s_origin_unit,&$s_exc_destination_unit_not_found) {
		try {
			$func_out=NULL;
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'km')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'km')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'm')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm')) {
					$func_out=sirel_units::create_func_1('100000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mm')) {
					$func_out=sirel_units::create_func_1('1000000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'm')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'km')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'm')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm')) {
					$func_out=sirel_units::create_func_1('100');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mm')) {
					$func_out=sirel_units::create_func_1('1000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'cm')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'km')) {
					$func_out=sirel_units::create_func_1('0.00001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'm')) {
					$func_out=sirel_units::create_func_1('0.01');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mm')) {
					$func_out=sirel_units::create_func_1('10');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'mm')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'km')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'm')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm')) {
					$func_out=sirel_units::create_func_1('0.1');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mm')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			return $func_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_conversion_function_orig_length

//------------------------------------------------------------------
	private static function create_conversion_function_orig_volume(&$s_destination_unit,
			&$s_origin_unit,&$s_exc_destination_unit_not_found) {
		try {
			$func_out=NULL;
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'm^3')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'm^3')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'l')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm^3')) {
					$func_out=sirel_units::create_func_1('1000000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'l')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'm^3')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'l')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm^3')) {
					$func_out=sirel_units::create_func_1('1000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'cm^3')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'm^3')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'l')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'cm^3')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
			} // if
			return $func_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_conversion_function_orig_volume

//------------------------------------------------------------------
	private static function create_conversion_function_orig_mass(&$s_destination_unit,
			&$s_origin_unit,&$s_exc_destination_unit_not_found) {
		try {
			$func_out=NULL;
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'kg')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'g')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 't')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'kg')) {
					$func_out=sirel_units::create_func_1('1.0');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg')) {
					$func_out=sirel_units::create_func_1('1000000');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
				return $func_out;
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'g')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'kg')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 't')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
				return $func_out;
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 't')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'kg')) {
					$func_out=sirel_units::create_func_1('1000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g')) {
					$func_out=sirel_units::create_func_1('1000000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg')) {
					$func_out=sirel_units::create_func_1('1000000000');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 't')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
				return $func_out;
			} // if
			if(sirelLang::str1EqualsStr2($s_origin_unit, 'mg')) {
				if(sirelLang::str1EqualsStr2($s_destination_unit, 'kg')) {
					$func_out=sirel_units::create_func_1('0.000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 't')) {
					$func_out=sirel_units::create_func_1('0.000000001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'g')) {
					$func_out=sirel_units::create_func_1('0.001');
				} elseif(sirelLang::str1EqualsStr2($s_destination_unit, 'mg')) {
					$func_out=sirel_units::create_func_1('1.0');
				} else {
					throw new Exception($s_exc_destination_unit_not_found);
				} // else
				return $func_out;
			} // if
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_conversion_function_orig_mass

//------------------------------------------------------------------
	private static function create_conversion_function(&$s_destination_unit,
			&$s_origin_unit) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_destination_unit);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_origin_unit);
				sirel_units::assert_unit_supported($s_destination_unit);
				sirel_units::assert_unit_supported($s_origin_unit);
			} // if
			$s_exc_destination_unit_not_found='There is a flaw. The creation of '.
					'conversion function from unit '.$s_origin_unit.
					' to unit '.$s_destination_unit.' failed. The origin unit '.
					' exists in the conversion graph but there is no '.
					' directed edge from the origin unit to the '.
					' destination unit. ';
			$func_out=NULL;
// List of supported units for vim based semiautomated text editing:
//  't'
//  'kg'
//  'g'
//  'mg'
//  'm^3'
//  'l'
//  'kg/(m^3)'
//  'mg/(cm^3)'
//  'g/l'
			if(is_null($func_out)) {
				$func_out=sirel_units::create_conversion_function_orig_mass($s_destination_unit,
						$s_origin_unit,$s_exc_destination_unit_not_found);
			} // if
			if(is_null($func_out)) {
				$func_out=sirel_units::create_conversion_function_orig_volume($s_destination_unit,
						$s_origin_unit,$s_exc_destination_unit_not_found);
			} // if
			if(is_null($func_out)) {
				$func_out=sirel_units::create_conversion_function_orig_density($s_destination_unit,
						$s_origin_unit,$s_exc_destination_unit_not_found);
			} // if
			if(is_null($func_out)) {
				$func_out=sirel_units::create_conversion_function_orig_length($s_destination_unit,
						$s_origin_unit,$s_exc_destination_unit_not_found);
			} // if
			if(is_null($func_out)) {
				throw new Exception('There is a flaw. The creation of '.
						'conversion function from unit '.$s_origin_unit.
						' to unit '.$s_destination_unit.' failed.');
			} // if
			return $func_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // create_conversion_function

//------------------------------------------------------------------
	private static function get_conversion_function(&$s_destination_unit,
			&$s_origin_unit) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_destination_unit);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_origin_unit);
				sirel_units::assert_unit_supported($s_destination_unit);
				sirel_units::assert_unit_supported($s_origin_unit);
			} // if
			$s_key=$s_origin_unit.' -> '.$s_destination_unit;
			$func_out=NULL;
			if(array_key_exists($s_key, sirel_units::$arht_conversion_functions)) {
				$func_out=sirel_units::$arht_conversion_functions[$s_key];
			} else {
				$func_out=sirel_units::create_conversion_function($s_destination_unit,
						$s_origin_unit);
				sirel_units::$arht_conversion_functions[$s_key]=$func_out;
			} // if
			return $func_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_conversion_function

//------------------------------------------------------------------
	private static $arht_unit_2_Si=array('km'=>'m','m'=>'m','cm'=>'m','mm'=>'m','t'=>'kg','kg'=>'kg','g'=>'kg','mg'=>'kg','m^3'=>'m^3','l'=>'m^3','cm^3'=>'m^3','t/(m^3)'=>'kg/(m^3)','kg/(m^3)'=>'kg/(m^3)','kg/l'=>'kg/(m^3)','g/l'=>'kg/(m^3)','g/(cm^3)'=>'kg/(m^3)','mg/l'=>'kg/(m^3)','mg/(cm^3)'=>'kg/(m^3)');
// For editing aid:
// array('km'=>'m','m'=>'m','cm'=>'m','mm'=>'m',
// 't'=>'kg','kg'=>'kg','g'=>'kg','mg'=>'kg',
// 'm^3'=>'m^3','l'=>'m^3','cm^3'=>'m^3',
// 't/(m^3)'=>'kg/(m^3)','kg/(m^3)'=>'kg/(m^3)','kg/l'=>'kg/(m^3)','g/l'=>'kg/(m^3)','g/(cm^3)'=>'kg/(m^3)','mg/l'=>'kg/(m^3)','mg/(cm^3)'=>'kg/(m^3)',
// );

	// Returns a string that represents the Si version of the $s_unit.
	public static function s_unit_2_Si(&$s_unit) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_unit);
			} // if
			sirel_units::assert_unit_supported($s_unit);
			$s_Si_unit=''.sirel_units::$arht_unit_2_Si[$s_unit];
			return $s_Si_unit;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_unit_2_Si

// Converts the value to the Si system.  Probably some
// rounding will take place due to the use of floats.
	public static function fd_2_Si($i_or_s_or_fd,$s_unit) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_unit);
			} // if
			sirel_units::assert_unit_supported($s_unit);
			$s_Si_unit=sirel_units::$arht_unit_2_Si[$s_unit];
			$func_converter=sirel_units::get_conversion_function($s_Si_unit,
					$s_unit);
			$fd_in=sirel_type_normalizations::to_fd($i_or_s_or_fd);
			$fd_out=$func_converter($fd_in);
			return $fd_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // fd_2_Si

//------------------------------------------------------------------
// Converts the value from one system to anohter. Probably some
// rounding will take place due to the use of floats.
	public static function fd_convert($s_destination_unit,
			$i_or_s_or_fd,$s_origin_unit) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_destination_unit);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_origin_unit);
			} // if
			sirel_units::assert_unit_supported($s_destination_unit);
			sirel_units::assert_unit_supported($s_origin_unit);
			$func_converter=sirel_units::get_conversion_function($s_destination_unit,
					$s_origin_unit);
			$fd_in=sirel_type_normalizations::to_fd($i_or_s_or_fd);
			$fd_out=$func_converter($fd_in);
			return $fd_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // fd_convert

//------------------------------------------------------------------
	private static function test_sirel_units_b_unit_not_supported() {
		try {
			$test_result=array();
			$ar_tc=array();
//----tests-cases-start----------------------
			$s_unit='kg'; // A Si unit.
			$b=sirel_units::b_unit_not_supported($s_unit);
			if($b==True) {
				$test_case['msg']='$s_unit=="'.$s_unit.'" ';
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
//-----
			$s_unit='g'; // A non-Si unit.
			$b=sirel_units::b_unit_not_supported($s_unit);
			if($b==True) {
				$test_case['msg']='$s_unit=="'.$s_unit.'" ';
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
//-----
			$s_unit='ThisUnitCanNotPossiblyBeSupported';
			$b=sirel_units::b_unit_not_supported($s_unit);
			if($b==False) {
				$test_case['msg']='$s_unit=="'.$s_unit.'" ';
				$test_case['line_number']=__LINE__;
				$ar_tc[]=$test_case;
			} // if
//-----
			$b_error_not_detected=True;
			try {
				$x=array();
				$b=sirel_units::b_unit_not_supported($x); // type not supported
			}catch (Exception $err_exception) {
				$b_error_not_detected=False;
			} // catch
			if($b_error_not_detected) {
				$test_case['msg']='typecheck 1';
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
	} // test_sirel_units_b_unit_not_supported

	public static function selftest() {
		try {
			$ar_test_results=array();
// To avoid parsing the code of all of the selftests
// every time the sirel_units is used, the most of the
// sirel_units selftests are in test_sirel_units.php
//
// The next one is in this class only because it is not public.
			$ar_test_results[]=sirel_units::test_sirel_units_b_unit_not_supported();
			return $ar_test_results;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest

} // sirel_units


// ---------------------------------------------------------

?>
