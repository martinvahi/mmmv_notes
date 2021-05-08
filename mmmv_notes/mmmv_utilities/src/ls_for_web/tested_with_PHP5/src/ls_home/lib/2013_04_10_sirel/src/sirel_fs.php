<?php
//=========================================================================
// Copyright 2010, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// All rights reserved.
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
//=========================================================================
require_once('sirel_lang.php');
//=========================================================================
class sirelFS {

	// Always returns an UTF-8. It throws an exception, if
	// the file does not exist.
	public static function file2str($s_file_path) {
		try {
			if (!file_exists($s_file_path)) {
				throw(new Exception('A File or a folder with the path of "'.
						$s_file_path.'" does not exist.'));
			} // if
			if (is_dir($s_file_path)) {
				throw(new Exception('"'.$s_file_path.'" is a folder, but '.
						'a file is required.'));
			} // if
			$file_handle = fopen($s_file_path, "rb"); // b for Windows.
			$s_raw=fread($file_handle, filesize($s_file_path));
			fclose($file_handle);
			$s_out=utf8_encode($s_raw);
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // file2str

	public function str2file(&$s_file_content,$s_file_path) {
		$file_handle=NULL;
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_file_content);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_file_path);
			} // if
			if (file_exists($s_file_path)) {
				if (is_dir($s_file_path)) {
					throw(new Exception('"'.$s_file_path.'" is a folder, but '.
							'only a file is allowed to be overwritten.'));
				} // if
			} // if
			$s_0=utf8_encode($s_file_content);
			// The following code is partly copy/pasted from:
			// http://bytes.com/topic/php/answers/497802-utf-8-file-reading-writing-php
			$file_handle = fopen($s_file_path, "wb+");
			fwrite($file_handle, $s_0);
			fclose($file_handle);
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // str2file


	// It always retunrs an array of folder element paths, but
	// the array may also be empty. It throws an exception, if
	// the folder does not exist.
	public  static function ls($s_path_to_a_folder,$s_folder_element_name_regex='.*') {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_path_to_a_folder);
			} // if
			if (!file_exists($s_path_to_a_folder)) {
				throw(new Exception('A folder with a path of "'.
						$s_path_to_a_folder.'" does not exist.'));
			} // if
			if (!is_dir($s_path_to_a_folder)) {
				throw(new Exception('"'.$s_path_to_a_folder.'" is a file, but '.
						'a folder is required.'));
			} // if
			$ar_out=array();
			$b_go_on=True;
			$dir_handle=opendir($s_path_to_a_folder);
			$x=NULL;
			while ($b_go_on===True) {
				$x=readdir($dir_handle);
				if ($x===False) {
					$b_go_on=False;
				} else {
					if (($x!==0)&&($x!=='')) {
						if (($x!=='..')&&($x!=='.')) {
							if(mb_ereg_match($s_folder_element_name_regex,$x)==True) {
								array_push($ar_out,$x);
							} // if
						} // if
					} // if
				} // else
			} // if
			closedir($dir_handle);
			return $ar_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // ls

	//------------------------------------------------------------------

	// If the b_search_for_folders==false, then files are searched.
	private static function arht_folder_or_file_paths_impl(&$s_path_to_a_folder,
			$b_search_for_folders) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_path_to_a_folder);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_bool',$b_search_for_folders);
			} // if
			if (!file_exists($s_path_to_a_folder)) {
				throw(new Exception('A folder with a path of "'.
						$s_path_to_a_folder.'" does not exist.'));
			} // if
			if (!is_dir($s_path_to_a_folder)) {
				throw(new Exception('"'.$s_path_to_a_folder.'" is a file, but '.
						'a folder is required.'));
			} // if
			$arht_out=array();
			$arht_files_and_folders=sirelFS::ls($s_path_to_a_folder);
			$i_len=count($arht_files_and_folders);
			$s_path=NULL;
			$s_0=NULL;
			$s_1=NULL;
			if($b_search_for_folders==True) {
				for($i=0;$i<$i_len;$i++) {
					$s_0=$arht_files_and_folders[$i];
					if(is_dir($s_0)==True) {
						array_push($arht_out, $s_0);
					} else {
						$s_1=$s_path_to_a_folder.'/'.$s_0;
						// "//" -> "/"
						$s_path=mb_ereg_replace('[/]+', '/', $s_1);
						if(is_dir($s_path)==True) {
							array_push($arht_out, $s_path);
						} // if
					} // else
				} // for
			} else { // search for files
				for($i=0;$i<$i_len;$i++) {
					$s_0=$arht_files_and_folders[$i];
					if (file_exists($s_0)) {
						if(!is_dir($s_0)==True) {
							array_push($arht_out, $s_0);
						} // if
					} else {
						$s_1=$s_path_to_a_folder.'/'.$s_0;
						// "//" -> "/"
						$s_path=mb_ereg_replace('[/]+', '/', $s_1);
						if (file_exists($s_path)) {
							if(!is_dir($s_path)==True) {
								array_push($arht_out, $s_path);
							} // if
						} // if
					} // else
				} // for
			} // else
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_folder_or_file_paths_impl

	//  Returns an array of folder paths. It's like the ls with a
	// filter.
	public  static function arht_folder_paths($s_path_to_a_folder) {
		try {
			$b_search_for_folders=True;
			$arht_out=sirelFS::arht_folder_or_file_paths_impl(
					$s_path_to_a_folder,$b_search_for_folders);
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_folder_paths

	//  Returns an array of file paths. It's like the ls with a
	// filter.
	public  static function arht_file_paths($s_path_to_a_folder) {
		try {
			$b_search_for_folders=False;
			$arht_out=sirelFS::arht_folder_or_file_paths_impl(
					$s_path_to_a_folder,$b_search_for_folders);
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_file_paths

	//------------------------------------------------------------------

	// Returns an array with more popular image file extensions.
	// All of the file extensions have been written in lowercase.
	public static function arht_image_file_extensions() {
		try {
			$arht_out=array();
			array_push($arht_out, 'png');
			array_push($arht_out, 'jpg');
			array_push($arht_out, 'jpeg');
			array_push($arht_out, 'bmp');
			array_push($arht_out, 'gif');
			array_push($arht_out, 'svg');
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_image_file_extensions

	public static function arht_image_file_paths($s_path_to_a_folder) {
		try {
			$arht_out=array();
			$arht_file_paths=sirelFS::arht_file_paths($s_path_to_a_folder);
			$i_len=count($arht_file_paths);
			$s_fp=NULL;
			$s_lc_1='.+';
			$s_lc_2='$';
			$s_0=NULL;
			$s_1=NULL;
			$s_extension=NULL;
			$b_match=False;
			$arht_xt=sirelFS::arht_image_file_extensions();
			$i_len_xt=count($arht_xt);
			$s_xt=NULL;
			$s_rgx=NULL;
			for($i=0;$i<$i_len;$i++) {
				$s_fp=$arht_file_paths[$i];
				for($ii=0;$ii<$i_len_xt;$ii++) {
					$s_xt=$arht_xt[$ii];
					$s_rgx=$s_lc_1.$s_xt.$s_lc_2;
					$s_1=mb_strtolower($s_fp);
					$b_match=mb_ereg_match($s_rgx,$s_1);
					if($b_match==True) {
						array_push($arht_out, $s_fp);
					} // if
				} // for
			} // for
			return $arht_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // arht_image_file_paths


	//------------------------------------------------------------------
	private static $i_arht_fileextension2MIMEtype_load_state=0;
	private static $arht_fileextension2MIMEtype;

	private static function s_file_MIME_type_loadstage_1() {
		try {
			$arht_fileextension2MIMEtype=array();
			$arht_fileextension2MIMEtype['jfif']='image/jpeg';
			$arht_fileextension2MIMEtype['jpe']='image/jpeg';
			$arht_fileextension2MIMEtype['jpeg']='image/jpeg';
			$arht_fileextension2MIMEtype['jpg']='image/jpeg';
			$arht_fileextension2MIMEtype['gif']='image/gif';
			$arht_fileextension2MIMEtype['png']='image/png';
			$arht_fileextension2MIMEtype['pnm']='image/x-portable-anymap';
			$arht_fileextension2MIMEtype['bmp']='image/bmp';
			$arht_fileextension2MIMEtype['mp3']='audio/mpeg3';
			$arht_fileextension2MIMEtype['mov']='video/quicktime';
			$arht_fileextension2MIMEtype['css']='text/css';
			$arht_fileextension2MIMEtype['js']='application/x-javascript';
			$arht_fileextension2MIMEtype['txt']='text/plain';
			$arht_fileextension2MIMEtype['ps']='application/postscript';
			$arht_fileextension2MIMEtype['pdf']='application/pdf';
			$arht_fileextension2MIMEtype['doc']='application/msword';
			$arht_fileextension2MIMEtype['xls']='application/excel';
			$arht_fileextension2MIMEtype['xml']='text/xml';
			$arht_fileextension2MIMEtype['exe']='application/octet-stream';
			$arht_fileextension2MIMEtype['dvi']='application/x-dvi';
			$arht_fileextension2MIMEtype['tif']='image/tiff';
			$arht_fileextension2MIMEtype['tgz']='application/gnutar';
			$arht_fileextension2MIMEtype['tar']='application/x-tar';
			$arht_fileextension2MIMEtype['class']='application/java-byte-code';
			$arht_fileextension2MIMEtype['bz2']='application/x-bzip2';
			$arht_fileextension2MIMEtype['gz']='application/x-gzip';
			$arht_fileextension2MIMEtype['java']='text/x-java-source';
			sirelFS::$arht_fileextension2MIMEtype=$arht_fileextension2MIMEtype;
			sirelFS::$i_arht_fileextension2MIMEtype_load_state=1;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_file_MIME_type_loadstage_1

	private static function s_file_MIME_type_loadstage_2() {
		try {
			if(sirelFS::$i_arht_fileextension2MIMEtype_load_state==2) {
				return; // already loaded
			} // if
			require_once('bonnet/sirel_fs_mimetypes.php');
			$arht_0=sirelFS_mimetypes::arht_mimetypes_stage_2();
			$arht_1=array_merge($arht_0,sirelFS::$arht_fileextension2MIMEtype);
			sirelFS::$arht_fileextension2MIMEtype=$arht_1;
			sirelFS::$i_arht_fileextension2MIMEtype_load_state=2;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_file_MIME_type_loadstage_2

	// It's a wrapper to the mess in the PHP standard library.
	// It's verbose here, but saves characters at client code.
	public static function s_file_MIME_type(&$s_path_to_a_file) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring',$s_path_to_a_file);
			} // if
			if (!file_exists($s_path_to_a_file)) {
				throw(new Exception('A file with a path of "'.
						$s_path_to_a_file.'" does not exist.'));
			} // if
			if (is_dir($s_path_to_a_file)) {
				throw(new Exception('"'.$s_path_to_a_file.'" is a folder, but '.
						'a file is required.'));
			} // if
			// Credits for the "correct", but not universally functional,
			// solution go to
			// http://stackoverflow.com/questions/4807036/php-5-3-5-fileinfo-mime-type-for-ms-office-2007-files-magic-mime-updates
			//
			// The "correct" and "functions according to the will of the
			// web server administrator" version of the solution:
			// $ob_finfo= new finfo(FILEINFO_MIME_TYPE);
			// $s_out= $ob_finfo->file($s_path_to_a_file);
			//
			// The next solution is dirty, incorrect, but portable and works,
			// i.e. the design of the web technolocy, PHP, sucks such
			// a big time that a dirty hack is more reliable
			// and robust than a correct version:
			$s_out='';
			if(sirelFS::$i_arht_fileextension2MIMEtype_load_state==0) {
				sirelFS::s_file_MIME_type_loadstage_1();
			} // if
			$arht_fx2MIME=sirelFS::$arht_fileextension2MIMEtype;
			$ob_path_parts = pathinfo($s_path_to_a_file);
			//$ob_path_parts['dirname'], "\n";
			//$ob_path_parts['basename'], "\n";
			$s_extension=mb_strtolower($ob_path_parts['extension']);
			if(array_key_exists($s_extension, $arht_fx2MIME)) {
				$s_out=$arht_fx2MIME[$s_extension];
				return($s_out);
			} // if
			// The stage 2 is heavy.
			sirelFS::s_file_MIME_type_loadstage_2();
			$arht_fx2MIME=sirelFS::$arht_fileextension2MIMEtype;
			if(array_key_exists($s_extension, $arht_fx2MIME)) {
				$s_out=$arht_fx2MIME[$s_extension];
			} // if
			return($s_out);
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_file_MIME_type

	//------------------------------------------------------------------

	public static function s_gen_tmpfilename() {
		try {
			$s_fp_tmp_folder=sirelSiteConfig::$tmp_folder;
			$s_out=$s_fp_tmp_folder.
					'/tmpfile_'.time().'_'.mt_rand(0,99999).'.php';
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // s_gen_tmpfilename

	//------------------------------------------------------------------
	public static function selftest() {
		try {
			$ar_test_results=array();
			//$ar_test_results[]=sirelFS::selftest_emailaddress();
			return $ar_test_results;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // selftest

} // class sirelFS

?>
