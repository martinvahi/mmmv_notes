<?php
// ------------------------------------------------------------------------
// Copyright (c) 2012, martin.vahi@softf1.com that has an
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
//=========================================================================
require_once(realpath($s_path_ls_home.'/configuration.php'));

if(defined('s_path_lib_sirel')!=True) {
	define('s_path_lib_sirel',$s_path_lib_sirel);
} // if
//require_once($s_path_lib_sirel.'/src/sirel.php');
require_once($s_path_lib_sirel.'/src/sirel_html.php');
require_once($s_path_lib_sirel.'/src/sirel_fs.php');
require_once($s_path_lib_sirel.'/src/sirel_text_concatenation.php');
//-------------------------------------------------------------------------
# The default initializations.

if(!isset ($arht_comments)) {
	$arht_comments=array();
} // if

if(!isset ($arht_skiplist)) {
	$arht_skiplist=array();
	$arht_skiplist['index.php']=42;
} // if

if(!isset($s_leaf_message)) {
	$s_leaf_message='This folder is empty.';
} // if
if(!isset($s_list_prefix_html)) {
	$s_list_prefix_html='';
} // if
if(!isset($s_list_suffix_html)) {
	$s_list_suffix_html='';
} // if

if(!isset($b_display_as_leaf)) {
	$b_display_as_leaf=False;
} // if

if(!isset($b_is_root_folder)) {
	$b_is_root_folder=False;
} // if

if(!isset($s_upwards_link_name)) {
	$s_upwards_link_name='up';
} // if

//-------------------------------------------------------------------------

function s2link(&$s_in) {
	try {
		$s_out='';
		$s_out='<a href="./'.$s_in.'">'.$s_in.'</a>';
		return($s_out);
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__, $err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // s2link

function s_item_html(&$s_path, &$arht_comments) {
	try {
		$s_token=s2link($s_path);
		if(array_key_exists($s_path,$arht_comments)) {
			$s_comment=$arht_comments[$s_path];
			$s_token=('<table><tr><td align="left" valign="top">'.
							$s_token.'</td>').
					('<td style="visibility:hidden;">spacer</td><td>'.
							$s_comment."</td></tr></table>\n");
		} // if
		$s_token=$s_token."<br/>\n";
		return $s_token;
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__,$err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // s_item_html

$arht=sirelFS::ls(realpath('./'));
$i_len=count($arht);
$s_path=NULL;
$arht_list=array();
$s_token=NULL;
if(0<mb_strlen($s_list_prefix_html)) {
	$s_list_prefix_html=$s_list_prefix_html."<br/><br/>\n";
	array_push($arht_list,$s_list_prefix_html);
} // if
if($b_display_as_leaf) {
	array_push($arht_list, $s_leaf_message);
} else {
	// In reality the folder is never empty, because it contains this index.php.
	if ($i_len==1) {
		$s_path=$arht[0];
		if($s_path!='index.php') {
			throw new Exception('$s_path=='.$s_path."\n".
					'GUID="940e2305-3e23-4f46-b513-42e2d0b01dd7"');
		} // if
		$b_1=True;
		if(!array_key_exists($s_path,$arht_skiplist)) {
			$s_token=s_item_html($s_path,$arht_comments);
			array_push($arht_list, $s_token);
			$b_1=False;
		} // if
		if($b_1) {
			array_push($arht_list, $s_leaf_message);
		} // if
	} else {
		for($i=0;$i<$i_len;$i++) {
			$s_path=$arht[$i];
			if(!array_key_exists($s_path,$arht_skiplist)) {
				$s_token=s_item_html($s_path,$arht_comments);
				array_push($arht_list, $s_token);
			} // if
		} // for
	} // else
} // if
if(0<mb_strlen($s_list_suffix_html)) {
	$s_list_suffix_html="<br/><br/>\n".$s_list_suffix_html;
	array_push($arht_list,$s_list_suffix_html);
} // if
//-------------------------------------------------------------------------
$s_1=s_concat_array_of_strings($arht_list);
$ob_html=new sirelHTMLPage();
$s_block_start='<div style="position:relative;left:35px;top:35px; font-size:170%;">';
if($b_is_root_folder) {
	$ob_html->add_2_ar_body($s_block_start.'<span style="visibility:hidden;">xx</span>'."\n");
}else {
	$ob_html->add_2_ar_body(($s_block_start.'<a href="./../">').
			($s_upwards_link_name."</a>\n"));
} // else
$ob_html->add_2_ar_body("</div>\n");
$s_block_start='<div style="position:relative;left:90px;top:70px;font-size:50pt;">';
$ob_html->add_2_ar_body($s_block_start."ls\n");
$ob_html->add_2_ar_body("</div>\n");
$s_block_start='<div style="position:relative;left:200px;top:80px;">';
$ob_html->add_2_ar_body($s_block_start."\n");
$ob_html->add_2_ar_body($s_1);
$ob_html->add_2_ar_body("</div>\n");
$s_html_out=$ob_html->to_s();
echo $s_html_out;
//=========================================================================
