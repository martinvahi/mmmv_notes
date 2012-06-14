<?php
//=========================================================================
// Copyright 2012, martin.vahi@softf1.com that has an
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
//-------------------------------------------------------------------------
//
// This file does not depend on anything else, which makes
// it easy to include to other projects without including
// anything else from the sirel library.
//
// A line for copy-pasting:
//
//         require_once('sirel_text_concatenation.php');
//
//=========================================================================

// Returns a string.
function s_concat_array_of_strings(&$ar_strings) {
	$i_n=count($ar_strings);
	if($i_n<3) {
		if($i_n==2) {
			$s_out=$ar_strings[0].$ar_strings[1];
			return $s_out;
		} else {
			if($i_n==1) {
				// For the sake of consistency one
				// wants to make sure that the returned
				// string instance always differs from those
				// that are within the $ar_strings.
				$s_out=''.$ar_strings[0];
				return $s_out;
			} else { // $i_n==0
				$s_out='';
				return $s_out;
			} // else
		} // else
	} // if
	$s_out=''; // needs to be inited to the ''

	//if(False) {
	//// The classic part for testing and playing.
	//$i_len=count($ar_strings);
	//for($i=0;$i<$i_len;$i++) {
	//$s_out=$s_out.$ar_strings[$i];
	//} // for
	//return $s_out;
	//} // if

	// In its essence the rest of the code here implements
	// a tail-recursive version of this function. The idea is that
	//
	// s_out='something_very_long'.'short_string_1'.short_string_2';
	// uses a temporary string of length
	// 'something_very_long'.'short_string_1'
	// but
	// s_out='something_very_long'.('short_string_1'.short_string_2');
	// uses a much more CPU-cache friendly temporary string of length
	// 'short_string_1'.short_string_2';
	//
	// This here is probably not the most optimal solution, because
	// within the more optimal solution the order of
	// "concatenation glue placements" depends on the lengths
	// of the tokens/strings, but as analysis and "gluing queue"
	// assembly also has a computational cost, the version
	// here is almost always more optimal than the totally
	// naive version/
	$arht_1=&$ar_strings;
	$arht_2=array();
	$b_take_from_arht_1=True;
	$b_not_ready=True;
	$i_reminder=NULL;
	$i_loop=NULL;
	$i_arht_in_len=NULL;
	$i_arht_out_len=0; // code after the while loop needs a number
	$s_1=NULL;
	$s_2=NULL;
	$s_3=NULL;
	$i_2=NULL;
	while($b_not_ready) {
		// The next if-statement is to avoid copying temporary
		// strings between the $arht_1 and the $arht_2.
		if($b_take_from_arht_1) {
			$i_arht_in_len=count($arht_1);
			$i_reminder=$i_arht_in_len%2;
			$i_loop=($i_arht_in_len-$i_reminder)/2;
			for($i=0;$i<$i_loop;$i++) {
				$i_2=$i*2;
				$s_1=$arht_1[$i_2];
				$s_2=$arht_1[$i_2+1];
				$s_3=$s_1.$s_2;
				$arht_2[]=$s_3;
			} // for
			if($i_reminder==1) {
				$s_3=$arht_1[$i_arht_in_len-1];
				$arht_2[]=$s_3;
			} // if
			$i_arht_out_len=count($arht_2);
			if(1<$i_arht_out_len) {
				$arht_1=array();
			} else {
				$b_not_ready=False;
			} // else
		} else { // $b_take_from_arht_1==False
			$i_arht_in_len=count($arht_2);
			$i_reminder=$i_arht_in_len%2;
			$i_loop=($i_arht_in_len-$i_reminder)/2;
			for($i=0;$i<$i_loop;$i++) {
				$i_2=$i*2;
				$s_1=$arht_2[$i_2];
				$s_2=$arht_2[$i_2+1];
				$s_3=$s_1.$s_2;
				$arht_1[]=$s_3;
			} // for
			if($i_reminder==1) {
				$s_3=$arht_2[$i_arht_in_len-1];
				$arht_1[]=$s_3;
			} // if
			$i_arht_out_len=count($arht_1);
			if(1<$i_arht_out_len) {
				$arht_2=array();
			} else {
				$b_not_ready=False;
			} // else
		} // else
		$b_take_from_arht_1=!$b_take_from_arht_1;
	} // while
	if($i_arht_out_len==1) {
		if($b_take_from_arht_1) {
			$s_out=$arht_1[0];
		} else {
			$s_out=$arht_2[0];
		} // else
	}else {
		// The $s_out has been inited to ''.
		if(0<$i_arht_out_len) {
			throw(new Exception('This function is flawed.'));
		} // else
	} // else
	return $s_out;
} // s_concat_array_of_strings

//=========================================================================
?>
