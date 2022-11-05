<?php
//=========================================================================
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
//=========================================================================
require_once('sirel_lang.php');

//-------------------------------------------------------------------------

// GUID stands for Globally Unique Identifier.
// Returns a string that contains a newly generated GUID
function sirel_GUID() {
	try {
		// A modified version of a passage from the RFC 4122:
		//---passage--start--
		//
		//  The variant field determines the layout of the UUID.  That is,
		//  the interpretation of all other bits in the UUID depends
		//  on the setting of the bits in the variant field.  As such,
		//  it could more accurately be called a type field; we retain
		//  the original term for compatibility. The variant field
		//  consists of a variable number of the most significant bits
		//  of octet 8 of the UUID.
		//
		//  The following table lists the contents of the variant field, where
		//  the letter "x" indicates a "don't-care" value.
		//
		//  Msb0  Msb1  Msb2  Description
		//
		//   0     x     x    Reserved, NCS backward compatibility.
		//   1     0     x    The variant specified in this document.
		//   1     1     0    Reserved, Microsoft Corporation backward
		//                    compatibility
		//   1     1     1    Reserved for future definition.
		//
		//---passage--end----
		//
		//---RFC-4122-citation--start--
		//
		// To minimize confusion about bit assignments within octets, the UUID
		// record definition is defined only in terms of fields that are
		// integral numbers of octets.  The fields are presented with the most
		// significant one first.
		//
		//---RFC-4122-citation--end---
		//
		// _0_1_2_3 _4_5 _6_7 _8_9 __11__13__15   #== byte indices
		// oooooooo-oooo-Xooo-Yooo-oooooooooooo
		// 012345678901234567890123456789012345
		// _________9_________9_________9______
		//
		// X indicates the GUID version and is the most significant
		// nibble of byte 6, provided that the counting of bytes
		// starts from 0, not 1.
		//
		// The value of Y determines the variant and the Y designates the
		// most significant nibble of byte 8,
		// provided that the counting starts from 0.
		// For version 4 the Y must be in set {8,9,a,b}.
		$s_1=dechex(time());
		// The GUID is in ASCII anyway, until converted to UTF-8
		// where the hex characters have 1 byte UTF-8 code points.
		while(strlen($s_1)<36) {
			$s_1=$s_1.dechex(rand());
		} // while
		$s_2=substr($s_1,0,36); // GUID-s have 36 characters
		// The reason, why it is beneficial to place the
		// timestamp part of the GUID to the end of the GUID is
		// that the randomly generated digits have a
		// bigger variance than the timestamp digits have.
		// If the GUIDs are used as ID-s or file names,
		// then the bigger the variance of first digits of the string,
		// the less amount of digits search algorithms have to study to
		// exclude majority of irrelevant records from further inspection.
		$s_1=strrev($s_2);
		$s_2=utf8_encode($s_1);

		$s_1=sirelLang::s_set_char($s_2, 8, '-');
		$s_2=sirelLang::s_set_char($s_1, 13, '-');
		$s_1=sirelLang::s_set_char($s_2, 14, '4');
		$s_2=sirelLang::s_set_char($s_1, 18, '-');
		$s_char=''.dechex(8+rand(0,3));
		$s_1=sirelLang::s_set_char($s_2, 19, $s_char);
		$s_2=sirelLang::s_set_char($s_1, 23, '-');
		return $s_2;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // sirel_GUID

//-------------------------------------------------------------------------

//=========================================================================
?>

