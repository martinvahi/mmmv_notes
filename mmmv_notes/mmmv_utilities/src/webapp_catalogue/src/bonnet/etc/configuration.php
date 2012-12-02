<?php
//=========================================================================

sirelSiteConfig::$various['i_web_catalogue_config_ls_depth']=4;

//-------------------------------------------------------------------------

// The regexes are fed to mb_ereg and their correct values are
// quite hellish to find. I recommend using the KomodoIDE regex
// experimentation tool for testing out the regexes.
$arht=array();
array_push($arht,'.+index.html');
array_push($arht,'.+index.php');
sirelSiteConfig::$various['arht_regexes_to_match_listed_paths']=$arht;

//-------------------------------------------------------------------------
$arht_skiplist=array();
// The values are not pushed to the array, becaouse due to efficiency reasons
// the code uses the PHP function array_key_exists(...)
$arht_skiplist['.git']=42;
$arht_skiplist['.hg']=42;
$arht_skiplist['.svn']=42;
$arht_skiplist['IDE']=42;
sirelSiteConfig::$various['arht_folders_to_skip_from_search']=$arht_skiplist;

//-------------------------------------------------------------------------
$s_0='';
sirelSiteConfig::$various['s_html_body_prefix']=$s_0;

//-------------------------------------------------------------------------
$s_0='';
sirelSiteConfig::$various['s_html_body_suffix']=$s_0;

//=========================================================================
?>
