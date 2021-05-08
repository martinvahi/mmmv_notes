<?php
//=========================================================================
$s_path_ls_home=realpath('./../../../src/ls_home');

$arht_skiplist=array();
$arht_skiplist['index.php']=42;
$arht_skiplist['DDDD']=42;

$s_list_prefix_html='
The folder, DDDD, exists, but is not displayed 
due to the configuration that resides in the index.php 
that generated this page.
';
//-------------------------------------------------------------------------
require_once($s_path_ls_home.'/ls_core.php');
//=========================================================================
