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

// Verifications are in the sirel_core.php or its sub-files.
$s_path_lib_sirel=sirelSiteConfig::$various['s_path_lib_sirel'];
require_once($s_path_lib_sirel.'/src/sirel_dbcomm.php');
require_once($s_path_lib_sirel.'/src/sirel_text_concatenation.php');

//-------------------------------------------------------------------------
// The idea is that during development sometimes one changes the
// data storage format. Different versions of application
// source might not be compatible with the data storage format even,
// if they are intended to be.
//
// To lessen the liklehood that a newer version of the application
// corrodes the data that is written by an older version, one can
// make sure that at least the table names, column names and types
// of the database that is created by the new version match with that
// of the old version. This does not help against flaws that come
// form changes in the database format semantics, but it catches
// at least some of the most simplistic flaws.
//
// ../dev_tools/db_format_signature_comparison 
//
// contains a "PHP-page" that can be used for copy-pasting the 
// database signature to a text-file and the
//
// ../dev_tools/db_format_signature_comparison/orderless_linediff Ruby script
//
// can be used for finding out the differences between the
// textfiles. The main benefit of the Ruby script over the
// ordinary diff is that it treats textfile lines as set elements and
// displays the difference between the two sets, which in practice means
// that the Ruby script produces less false positives than the
// traditional diff.
class sirel_db_format_signature {

	private static function s_get_s_table_signature(&$db,&$dbc,&$s_table_name) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_class_sirelDBgate',$db);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_table_name);
			} // if
			$ar_column_names=$dbc->get_column_names($s_table_name);
			$arht_column_type_names=$dbc->get_column_types($s_table_name);
			$s_lc_linebreak="\n";
			$s_lc_separator=' : ';
			$i_len=count($ar_column_names);
			$s_column_name=NULL;
			$s_column_type=NULL;
			$ar_strings=array();
			for($i=0;$i<$i_len;$i++) {
				$s_column_name=$ar_column_names[$i];
				$s_column_type=$arht_column_type_names[$s_column_name];
				$ar_strings[]=$s_table_name;
				$ar_strings[]=$s_lc_separator;
				$ar_strings[]=$s_column_name;
				$ar_strings[]=$s_lc_separator;
				$ar_strings[]=$s_column_type;
				$ar_strings[]=$s_lc_linebreak;
			} // for
			$s_out=s_concat_array_of_strings($ar_strings);
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_get_s_table_signature

	// The $db_descriptor is expected
	// to be of type sirelDatabaseDescriptor
	public static function s_get(&$database_descriptor,
			$b_use_HTML_linebreaks) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,
						'sirelTD_is_class_sirelDatabaseDescriptor',
						$database_descriptor);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_bool',
						$b_use_HTML_linebreaks);
			} // if
			$db=sirelDBgate_pool::get_db($database_descriptor);
			$dbc=sirelDBcomm_pool::get_dbc($database_descriptor);
			$ar_table_names=$db->ar_get_table_names();
			$s_out='';
			$i_len=count($ar_table_names);
			$s_table_name=NULL;
			$s_table_signature=NULL;
			$ar_strings=array();
			for($i=0;$i<$i_len;$i++) {
				$s_table_name=$ar_table_names[$i];
				$s_table_signature=sirel_db_format_signature::s_get_s_table_signature($db,
						$dbc,$s_table_name);
				$ar_strings[]=$s_table_signature;
			} // for
			$s_out=s_concat_array_of_strings($ar_strings);
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_get

} // sirel_db_format_signature

//=========================================================================

?>
