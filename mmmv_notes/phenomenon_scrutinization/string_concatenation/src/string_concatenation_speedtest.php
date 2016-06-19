<?php
/*=========================================================================

 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 This file is licensed under the MIT license:
 http://www.opensource.org/licenses/mit-license.php

=========================================================================*/
mb_internal_encoding('UTF-8');
mb_regex_encoding('UTF-8');
mb_http_output('UTF-8');
mb_http_input('UTF-8');
mb_language('uni');
//-------------------------------------------------------------------------
require_once('watershed_concatenation_implementations/sirel_text_concatenation.php');

function s_generate_random_ASCIIstyle_string($i_length) {
	$arht=array();
	$i_range=NULL;
	for($i=0;$i<$i_length;$i++) {
		$i_range=mt_rand(1,3);
		if($i_range==1) {
			$arht[]=chr(mt_rand(48,57));      // 0..9
		} else {
			if($i_range==2) {
				$arht[]=chr(mt_rand(65,90));  // A..Z
			} else { // $i_range==3
				$arht[]=chr(mt_rand(97,122)); // a..z
			} // else
		} // else
	} // for
	$s_out=s_concat_array_of_strings($arht);
	return $s_out;
} // s_generate_random_ASCIIstyle_string

function div($a,$b) {
	$i_out=floor($a/$b);
	return $i_out;
} // div

function concact_by_plain_loop($n) {
	$s_xV="xV";
	$s_out='';
	for($i=0;$i<$n;$i++) {
		$s_out=$s_out.($s_xV.mt_rand(0,9));
	} // for
	return $s_out;
} // concact_by_plain_loop

function concat_by_pseudowatershed($n) {
	$s_xV="xV";
	$i_reminder=$n%2;
	$i_loop=div($n,2);
	$s_1='';
	for($i=0;$i<$i_loop;$i++) {
		$s_1=$s_1.($s_xV.mt_rand(0,9));
	} // for
	$s_2='';
	for($i=0;$i<$i_loop;$i++) {
		$s_2=$s_2.($s_xV.mt_rand(0,9));
	} // for
	if($i_reminder==1) {
		$s_2=$s_2.($s_xV.mt_rand(0,9));
	} // if
	$s_out=$s_1.$s_2;
	return $s_out;
} // concat_by_pseudowatershed

function concact_by_watershed($n) {
	$s_xV="xV";
	$ar=array();
	for($i=0;$i<$n;$i++) {
		$ar[]=$s_xV.mt_rand(0,9);
	} // for
	$s_out=s_concat_array_of_strings($ar);
	return $s_out;
} // concact_by_watershed

//$n=10000;
//$i_branch=2;

$b_ok=FALSE;
echo("\n");
if ($i_branch==2) {
	echo('PHP test with the plain loop concatenation.');
	$s=concact_by_plain_loop($n);
	$b_ok=TRUE;
	echo("\n".'mb_strlen($s)=='.mb_strlen($s)."\n");
} // if
if ($i_branch==3) {
	echo('PHP test with the pseudo-watershed concatenation.');
	$s=concat_by_pseudowatershed($n);
	$b_ok=TRUE;
	echo("\n".'mb_strlen($s)=='.mb_strlen($s)."\n");
} // if
if ($i_branch==4) {
	echo('PHP test with the watershed concatenation.');
	$s=concact_by_watershed($n);
	$b_ok=TRUE;
	echo("\n".'mb_strlen($s)=='.mb_strlen($s)."\n");
} // if
if ($b_ok==FALSE) {
	echo("\n".'The $n=='.$n.' and the $i_branch=='.$i_branch."\n");
} // if
echo("\n");


// Juhus8ne genereerimise funktsioon koos selle
// v2ljakutsega on siia lisatud vaid demonstreerimaks
// juhtumit, kus s8nede kiire yhendamine omab praktilist v22rtust.
//
// $s=s_generate_random_ASCIIstyle_string(1000);
// echo($s);

?>
