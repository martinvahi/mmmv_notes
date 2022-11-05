<?php
// ------------------------------------------------------------------------
// Copyright (c) 2012, martin.vahi@softf1.com that has an
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
//
// The following line is a spdx.org license label line:
// SPDX-License-Identifier: BSD-3-Clause-Clear
//=========================================================================
$s_0='';

$s_0='./bonnet/lib/2013_04_10_sirel';
$s_path_lib_sirel=realpath($s_0);
if(defined('s_path_lib_sirel')!=True) {
	define('s_path_lib_sirel',$s_path_lib_sirel);
} // if
//require_once($s_path_lib_sirel.'/src/sirel.php');
require_once($s_path_lib_sirel.'/src/sirel_html.php');
require_once($s_path_lib_sirel.'/src/sirel_fs.php');
require_once($s_path_lib_sirel.'/src/sirel_text_concatenation.php');

require_once(realpath('./bonnet/etc/configuration.php'));
$arht=array(); // Dirty hack to null the $arht from the config file.
//-------------------------------------------------------------------------
function s2link($s_in) {
	try {
		$s_out='';
		if($s_in=='index.php') {
			// It's OK to display the existence of
			// index.html if the index.php generates the view.
			//return($s_out);
		} // if
		if (is_dir($s_in)) {
			$s_in=$s_in.'/';
		} // if
		$s_out='<a href="'.$s_in.'">'.$s_in."</a><br/>";
		return($s_out);
	}catch (Exception $err_exception) {
		sirelBubble(__FILE__,__LINE__, $err_exception,
				__CLASS__.'->'.__FUNCTION__.': ');
	} // catch
} // s2link

//-------------------------------------------------------------------------

function s_ls($s_prefix,$i_recursion_limit,&$arht_list,&$arht_skiplist,
		&$arht_regexes_to_match_listed_paths) {
	$i_recursion_limit=$i_recursion_limit-1;
	$arht=sirelFS::ls(realpath($s_prefix));
	sort($arht,SORT_REGULAR);
	$i_len=count($arht);
	$s_fn=NULL;
	$s_token=$s_prefix;
	if ($i_len==0) {
		$s_token=s2link($s_token);
		array_push($arht_list, $s_token);
	} else {
		$b_insert2arht=False;
		$b_ok_to_list=False;
		for($i=0;$i<$i_len;$i++) {
			$s_fn=$arht[$i];
			if(!array_key_exists($s_fn,$arht_skiplist)) {
				$s_token=$s_prefix.'/'.$s_fn;
				if (is_dir($s_token)) {
					if (0<=$i_recursion_limit) {
						s_ls($s_token,$i_recursion_limit,$arht_list,
								$arht_skiplist,$arht_regexes_to_match_listed_paths);
					} else {
						$s_token=s2link($s_token);
						$b_insert2arht=TRUE;
					} // else
				} else {
					$s_token=s2link($s_token);
					$b_insert2arht=TRUE;
				} // else
				if ($b_insert2arht) {
					$b_ok_to_list=False;
					$i_len_0=count($arht_regexes_to_match_listed_paths);
					$s_regex=NULL;
					for($ii=0;$ii<$i_len_0;$ii++) {
						$s_regex=$arht_regexes_to_match_listed_paths[$ii];
						if(mb_ereg($s_regex,$s_token)!=False) {
							$b_ok_to_list=True;
						} // if
					} // for
					if($b_ok_to_list) {
						array_push($arht_list, $s_token."\n");
					} // if
				} // if
				$b_insert2arht=FALSE;
                        } else {
                                //echo $s_fn.'<br/>'; // for debugging
			} // else
		} // for
	} // else
	//array_push($arht_list, '<br/>');
} // s_ls

//-------------------------------------------------------------------------
$i_ls_depth=sirelSiteConfig::$various['i_web_catalogue_config_ls_depth'];
$arht_regexes_to_match_listed_paths=sirelSiteConfig::$various['arht_regexes_to_match_listed_paths'];

$s_prefix='./web_applications/';
$arht_skiplist=sirelSiteConfig::$various['arht_folders_to_skip_from_search'];
$arht_list=array();

$s_0=''.sirelSiteConfig::$various['s_html_body_prefix'];
$s_0=$s_0."\n";
array_push($arht_list,$s_0);

s_ls($s_prefix,$i_ls_depth,$arht_list,$arht_skiplist,
		$arht_regexes_to_match_listed_paths);

array_push($arht_list,"\n");
$s_0=''.sirelSiteConfig::$various['s_html_body_suffix'];
array_push($arht_list,$s_0);
$s_1=s_concat_array_of_strings($arht_list);

$ob_html=new sirelHTMLPage();
$s_block_start='<div style="position:relative;left:35px;top:35px;">';
//$ob_html->add_2_ar_body($s_block_start.'<a href="./../">up</a>'."\n");
$ob_html->add_2_ar_body("</div>\n");
$s_block_start='<div style="position:relative;left:90px;top:70px;font-size:30pt;">';
$ob_html->add_2_ar_body($s_block_start.'Web Applications Catalogue'."\n");
$ob_html->add_2_ar_body("</div>\n");
$s_block_start='<div style="position:relative;left:200px;top:80px;">';
$ob_html->add_2_ar_body($s_block_start."\n");
$ob_html->add_2_ar_body('<br/><p>');
//$ob_html->add_2_ar_body('<a href="./../COMMENTS.txt">COMMENTS.txt</a><br/>');
$ob_html->add_2_ar_body('</p><br/>');
$ob_html->add_2_ar_body($s_1);
$ob_html->add_2_ar_body("</div>\n");
$ob_html->add_2_ar_body("<br/><br/><br/><br/>\n");
$ob_html->add_2_ar_body("<br/><br/><br/><br/>\n");
$s_html_out=$ob_html->to_s();
echo $s_html_out;
//=========================================================================
?>
