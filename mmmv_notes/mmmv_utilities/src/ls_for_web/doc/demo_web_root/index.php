<?php
//=========================================================================
$s_path_ls_home=realpath('./../../src/ls_home'); // please update the path

$b_is_root_folder=True; // Determins, whether a link 
                        // to a "parent" folder is displayed.

//$s_list_prefix_html='
// Some optional HTML goes here.
//';

$arht_comments=array();
$arht_comments['AA']='
This is a comment 
<br/> 
about the AA and it is in the 
<a href="http://www.w3schools.com/html/default.asp">HTML</a> format.
';


$arht_skiplist=array();  // Optional. Lists files and folders that will not be displayed.
$arht_skiplist['CC']=42; // will not be shown in the list 

//$s_list_suffix_html='
// Some optional HTML goes here.
//';

//-------------------------------------------------------------------------
require_once($s_path_ls_home.'/ls_core.php');
//=========================================================================
