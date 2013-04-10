<?php
//------------------------------------------------------------------------
// Copyright (c) 2009, martin.vahi@softf1.com that has an
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
//
//------------------------------------------------------------------------
// This file is part of the sirel_core.php and should be
// used only by using "require_once('sirel_core.php')".
//
// It is not allowed to use any of the sirel_core_exc.php
// functionality in this file. This file is a quite hackish,
// but it is relatively self contained. :-)
//------------------------------------------------------------------------



// It's the duty of the log writers to make sure that the
// logging is done in some nonblocking manner.
interface sirelLoggerLogWriter {
	public function get_name();
	public function log(&$a_single_log_message_as_an_UTF8_string);

	// Returns the whole log as a string or an error message as a string.
	// The reason, why it does not throw an exception is that
	// according to the sirel library architecture the logging is
	// not allowed to throw any exceptions.
	public function to_s();

	// Erases all entries from the log. This method exists in the
	// interface, because locking and threading related issues might
	// turn it to be a nontrival task. It returns a class sirelOP instance.
	public function clear_log();
} // interface sirelLoggerLogWriter

// Usage example:
// sirelLogger::get_instance()->log(__FILE__,__LINE__,'Greetings!','debug');
class sirelLoggerLogWriterDebug implements sirelLoggerLogWriter {
	protected $log_messages_=array();

	public function get_name() {
		return 'debug';
	} // get_name

	public function log(&$a_single_log_message_as_an_UTF8_string) {
		$this->log_messages_[]=$a_single_log_message_as_an_UTF8_string;
	} // log

	// It's used in the sirel_html.php for displaying the debug log.
	public function to_s() {
		$s='';
		foreach($this->log_messages_ as $msg) {
			$s=$s."\n--------------------------------------\n".$msg;
		} // foreach
		return $s;
	} // to_s

	public function clear_log() {
		$this->log_messages_=array();
		$answer=new sirelOP;
		$answer->sb_failure='f';
		return $answer;
	} // clear_log

} //class sirelLoggerLogWriterDebug

// This logwriter is quite expensive from time consuption point
// of view. Mainly it's due to the interaction with a file system.
//
// The main reason, why its implementation is so quirky is that the
// flock() is said to be somewhat problematic and unstable.
// Secondary reason is that non-locking systems are faster in an
// environment, where there are "a lot of" threads.
//
// Log file flooding issues are dealt with
// by dividing the log message to 2 parts: general part and the part that
// contains message instance specific data. The parts are separated
// by "|||". The general part is hashed and the hash is
// used for checking, whether a log message with that kind of
// a general part already exists. If it does, the whole log
// message is omitted. The "|||" is optional, but if the message
// contains more than one of them, only the very first one
// is considered to be the bisector.
//
// Some valid log message examples:
// "Journaling repairs activated at funcy funcname after the leave of
// user ||| username";
// "This just can't be happening, but it does anyway at funcyfunc ;->";
// "The Murphy's laws apply to input data ||| data1, data2, data3";
// "We've been cracked! Loss of data ||| dataname.";
// "If this sentence contains the output of time() or date(), the
// log will be flooded.|||";
// "||| This log message ends up in the logfile only once, regardless of
// the content of this sentence.".
class sirelLoggerLogWriterDefault implements sirelLoggerLogWriter {
	protected $logmsgfolder_;
	protected $individual_entries_folder_='individual_log_entries';

	public function get_name() {
		return 'default';
	} // get_name

	// Returns True, if successful.
	private function init_folder1() {
		$x=sirelSiteConfig::$log_folder;
		if(!file_exists(sirelSiteConfig::$log_folder)) {
			sirelLogger::log(__FILE__,__LINE__,
					'The log folder(=='.sirelSiteConfig::$log_folder.
					') is not accessible. The settings are '.
					'probably wrong.', 'debug');
			return False;
		} else if(!is_dir(sirelSiteConfig::$log_folder)) {
			sirelLogger::log(__FILE__,__LINE__,
					'The log folder is not actually a folder.','debug');
			return False;
		} else if(!is_writable(sirelSiteConfig::$log_folder)) {
			sirelLogger::log(__FILE__,__LINE__,
					'The log folder is not writable.','debug');
			return False;
		}//if
		$this->logmsgfolder_=sirelSiteConfig::$log_folder.'/'.
				$this->individual_entries_folder_;
		if(file_exists($this->logmsgfolder_)) {
			if(!is_writable($this->logmsgfolder_)) {
				sirelLogger::log(__FILE__,__LINE__,
						'The individual log messages folder exists,'.
						'but is not writable.', 'debug');
				return False;
			} // if
		} else {
			mkdir($this->logmsgfolder_);
			// The chmod 0777 is because the web server user differs from
			// the web application administrator user.
			chmod($this->logmsgfolder_,0777);
		} // else
		return True;
	}// init_folder1

	// The idea is that the logger's to_s method might be
	// called from a separate console script, which is
	// executed by some user other than the web-server.
	// It might be that the folders that are created by the
	// web server are not writable to that user, but are readable
	// to that user. If one used the init_folder1(), the to_s()
	// might be malfunctional.
	private function individual_messages_folder_is_readable() {
		if(!file_exists(sirelSiteConfig::$log_folder)) {
			sirelLogger::log(__FILE__,__LINE__,
					'The log folder is not accessible. The settings are probably wrong.',
					'debug');
			return False;
		} else if(!is_dir(sirelSiteConfig::$log_folder)) {
			sirelLogger::log(__FILE__,__LINE__,
					'The log folder is not actually a directory.',
					'debug');
			return False;
		} else if(!is_readable(sirelSiteConfig::$log_folder)) {
			sirelLogger::log(__FILE__,__LINE__,
					'The log folder is a directory and exists, but is not readable.',
					'debug');
			return False;
		}//if
		$this->logmsgfolder_=sirelSiteConfig::$log_folder.'/'.
				$this->individual_entries_folder_;
		if(!file_exists($this->logmsgfolder_)) {
			//sirelLogger::log(__FILE__,__LINE__,
			//		'The individual log messages folder does not exist.',
			//		'debug');
			return False;
		} // if
		if(!is_readable($this->logmsgfolder_)) {
			return False;
		} // if
		return True;
	}// individual_messages_folder_is_readable


	private function extract_general_part_of_the_message(&$message) {
		$pos1=mb_strpos($message, '|||message');
		$pos2=mb_strpos($message, '|||', $pos1+10);
		if(is_null($pos2)) {
			$pos2=mb_strlen($message);
		}
		// The file name and line number parts are intentionally left in.
		return mb_substr($message, 0, $pos2);
	} // extract_general_part_of_the_message

	// Just a personal comment by me, martin.vahi@softf1.com:
	// "In low quality software the logging is used as a
	// client feedback form, but in high quality software
	// the logging is used as a black box of an aeroplane.
	// The logging system can also be pretty useful as a
	// debugging aid."
	public function log(&$a_single_log_message_as_an_UTF8_string) {
		try {
			$t=time();
			clearstatcache();
			if(!$this->init_folder1()) {
				return;
			} // if
			$msg=$a_single_log_message_as_an_UTF8_string;
			$hsh=hash('md5', $this->extract_general_part_of_the_message($msg));
			$textfile_name=$this->logmsgfolder_.'/'.$hsh.'.txt';
			if(file_exists($textfile_name)) {
				return;
			} // if
			$file_handle = fopen($textfile_name, 'w');
			fwrite($file_handle,$t.'|||'.$msg);
			fclose($file_handle);
			chmod($textfile_name, 0777);
		} catch (Exception $err_exception) {
			// We intentionally won't do anything here.
		} // catch
	} // log

	private function to_s_collect_log_messages() {
		$dir_handle = opendir($this->logmsgfolder_);
		$answer=array();
		while ($file_name = readdir($dir_handle)) {
			$fn=$this->logmsgfolder_.'/'.$file_name;
			if(is_file($fn)) {
				$file_handle = fopen($fn, 'r');
				$answer[]=fread($file_handle,filesize($fn));
				fclose($file_handle);
			} // if
		} // while
		return $answer;
	} // to_s_collect_log_messages

	private function to_s_rehash_messages(&$array_of_raw_messages) {
		$answer=array();
		if(count($array_of_raw_messages)==0) {
			return $answer;
		} // if
		$msg_startpos=mb_strpos($array_of_raw_messages[0], '|||')+3;
		foreach($array_of_raw_messages as $msg) {
			$s=mb_substr($msg,$msg_startpos);
			$pair=new sirelPair((int)mb_substr($msg, 0, ($msg_startpos-3)),$s);
			$answer[]=$pair;
		} // foreach
		sirelUtils::sort2columnTable($answer,new sirelCompareWrapperSTD());
		return $answer;
	} // to_s_rehash_messages

	public function to_s() {
		$answer='';
		try {
			clearstatcache();
			if(!$this->individual_messages_folder_is_readable()) {
				return $answer;
			} // if
			$ar=$this->to_s_rehash_messages($this->to_s_collect_log_messages());
			if(count($ar)==0) {
				return $answer;
			} // if
			$pos_f=mb_strpos($ar[0]->b_, '|||', 3); // |||line xx |||file
			$ar=array_reverse($ar);
			foreach($ar as $x) {
				$str=$x->b_;
				$line_s=mb_substr($str, 3, $pos_f-3);
				$pos_m=mb_strpos($str, '|||', $pos_f+3);
				$file_s=mb_substr($str, $pos_f+3, $pos_m-$pos_f-3);
				$msg=mb_substr($str, $pos_m+10); // |||message
				$answer=$answer."<br/>\n".date('c',$x->a_).'  '.$line_s.
						'  '.$file_s." <br/>\n".$msg." <br/>\n";
			}
		} catch (Exception $err_exception) {
			// We intentionally won't do anything here.
		} // catch
		return $answer;
	} // to_s

	// Returns a class sirelOP instance.
	public function clear_log() {
		$answer=new sirelOP;
		try {
			clearstatcache();
			if(!$this->init_folder1()) {
				return;
			} // if
			$dir_handle = opendir($this->logmsgfolder_);
			while ($file_name = readdir($dir_handle)) {
				$fn=$this->logmsgfolder_.'/'.$file_name;
				if(is_file($fn)) {
					unlink($fn);
				} // if
			} // while
			$answer->sb_failure='f';
		} catch (Exception $err_exception) {
			// We intentionally won't do anything here.
		} // catch
		return $answer;
	} // clear_log
} //class sirelLoggerLogWriterDefault


// All exceptions in this class are suppressed. If it is broken,
// then it is broken and it's up to the admins and developers to
// figure out, why the logging does not work.
//
// In its essence this class is a "typical" singleton.
// It depends on settings at class sirelSiteConfig.
//
// Probably the most simple way to use this class is like that:
// sirelLogger::log(__FILE__, __LINE__, 'greetings!');
// Indeed, no instantiation is required in the code that uses it.
class sirelLogger {
	private static $instance_=NULL;
	protected $log_writers_=array();

	private function __construct() {
		$lw=new sirelLoggerLogWriterDefault();
		$this->add_logwriter($lw);
		if(sirelSiteConfig::$debug_PHP) {
			$lwd=new sirelLoggerLogWriterDebug();
			$this->add_logwriter($lwd);
		} // if
	} // constructor

	public static function get_instance() {
		if(is_null(sirelLogger::$instance_)) {
			sirelLogger::$instance_=new sirelLogger();
		} // if
		return sirelLogger::$instance_;
	} // get_instance


	public function add_logwriter($a_log_writer) {
		try {
			// $a_log_writer type verification won't help.
			$this->log_writers_[$a_log_writer->get_name()]=$a_log_writer;
		} catch (Exception $err_exception) {
			// We intentionally won't do anything here.
		} // catch
	} // add_logwriter


	public static function to_s($log_writer_name=NULL) {
		if(is_null($log_writer_name)) {
			$log_writer_name='default';
		} // if
		$logger=sirelLogger::get_instance();
		$answer='';
		if(array_key_exists($log_writer_name, $logger->log_writers_)) {
			$answer=$logger->log_writers_[$log_writer_name]->to_s();
		} // if
		if(array_key_exists('debug', $logger->log_writers_)) {
			$answer=$answer."\n".
					$logger->log_writers_['debug']->to_s();
		} // if
		return $answer;
	} // to_s

	private function log_impl(&$file,&$line,&$message,$log_writer_name) {
		try {
			if((!sirelSiteConfig::$debug_PHP)&&($log_writer_name=='debug')) {
				// This allows one to leave the debug log statements
				// in place. Of cource, one should acknowledge that it's
				// appropriate to remove, at least comment out, the
				// debug statements from stable code regions.
				return;
			} //if
			if(is_null($log_writer_name)) {
				$log_writer_name='default';
			} // if
			if(array_key_exists($log_writer_name, $this->log_writers_)) {
				$fl=mb_convert_encoding(''.$file,'UTF-8','auto');
				$li=mb_convert_encoding(''.$line,'UTF-8','auto');
				$mg=mb_convert_encoding(''.$message,'UTF-8','auto');
				// The format of the $msg is important for
				// the default logwriter.
				$msg='|||line '.$li.' |||file '.$fl.'  |||message '.$mg;
				$this->log_writers_[$log_writer_name]->log($msg);
			} // if
		} catch (Exception $err_exception) {
			// We intentionally won't do anything here.
		} // catch
	} // log_impl

	// It is meant to be called like that:
	// sirelLogger::log(__FILE__, __LINE__, 'hollallaa');
	public static function log($file,$line,$message,$log_writer_name=NULL) {
		sirelLogger::get_instance()->log_impl($file,$line,$message,
				$log_writer_name);
	} //log

	// Returns a class sirelOP instance.
	public static function clear_log($log_writer_name=NULL) {
		if(is_null($log_writer_name)) {
			$log_writer_name='default';
		} // if
		$answer;
		$logger=sirelLogger::get_instance();
		if(array_key_exists($log_writer_name, $logger->log_writers_)) {
			$answer=$logger->log_writers_[$log_writer_name]->clear_log();
		} else {
			$answer=new sirelOP;
		}
		return $answer;
	} //clear_log

} //class sirelLogger


?>
