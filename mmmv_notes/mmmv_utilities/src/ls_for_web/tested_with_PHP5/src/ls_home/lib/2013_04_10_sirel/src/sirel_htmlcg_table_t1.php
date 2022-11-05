<?php
// ------------------------------------------------------------------------
// Copyright (c) 2011, martin.vahi@softf1.com that has an
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
// ------------------------------------------------------------------------
require_once('sirel_lang.php');
require_once('sirel_type_normalizations.php');

// ---------------------------------------------------------

// It's for generating HTML code for a table that has
// the number of columns and rows that is specified 
// by the constructor parameters.
//
// Addressing of the compartments is similar to that of pixels:
// (0,0) is the upper leftmost compartment.
//
// The JavaScript attributes are totally omitted, because if 
// the JavaScrpt were enabled, one would rather want to use a 
// pure JavaScript based solution in stead of this one.
class sirel_htmlcg_table_t1 {

	public $s_table_name_=NULL;
	private $i_x_max_;
	private $i_y_max_;
	private $db_;
	private $s_html_id_prefix_;

	// key=='x_y', value==the HTML code
	// For the sake of speed key-value pairs
	// for compartments that have not been explicitly
	// assigned a value/style/etc. are not present in the hashtables.
	// It's possible that a key that resides in one hashtable, is
	// missing from the other.
	private $arht_compartment_style_=array();
	private $arht_compartment_classes_=array();
	private $arht_compartment_HTML_=array();

	private $s_compartments_common_style_='';
	private $s_compartments_common_classes_='raudrohi_visible_table_cells';

	private $s_table_style_='border:1px;';
	private $s_table_class_='raudrohi_visible_table';

	public function generate_new_html_id_prefix() {
		try {
			$this->s_html_id_prefix_=$this->db_->generate_ID();
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // generate_new_html_id_prefix


	// The $db_descriptor is expected to be of class sirelDatabaseDescriptor
	// The database connection is for generating unique HTML id prefixes.
	public function __construct($i_number_of_columns, $i_number_of_rows,
			&$db_descriptor) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_int', $i_number_of_columns);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_int', $i_number_of_rows);
				sirelLang::assert_range(1,'<=',$i_number_of_columns,'*',
						42,'$i_number_of_columns');
				sirelLang::assert_range(1,'<=',$i_number_of_rows,'*',
						42,'$i_number_of_rows');
			} // if
			$this->i_x_max_=$i_number_of_columns-1;
			$this->i_y_max_=$i_number_of_rows-1;
			$this->db_=sirelDBgate_pool::get_db($db_descriptor);
			$this->generate_new_html_id_prefix();
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // constructor

	// This one is expensive.
	private function verify_coordinates($i_x,$i_y) {
		try {
			// The range check accepts both, floats and ints,
			// but coordinates have to be ints, not floats.
			// That explanes the typechecks here.
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int', $i_x);
			sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
					__FUNCTION__,'sirelTD_is_int', $i_y);
			sirelLang::assert_range(0,'<=',$i_x,'<=',$this->i_x_max_,'$i_x');
			sirelLang::assert_range(0,'<=',$i_y,'<=',$this->i_y_max_,'$i_y');
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // verify_coordinates


	// An empty string unsets the common style.
	public function set_compartments_common_style($s_style) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_style);
			} // if
			$this->s_compartments_common_style_=$s_style;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_compartments_common_style

	// Returns a string. If the common style is not set, then
	// it returns an empty string.
	public function get_compartments_common_style() {
		try {
			$s_out=''.$this->s_compartments_common_style_;
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_compartments_common_style

	// Sets the compartment TD-tag's style attribute. An individual
	// style definition overrides the common style.
	public function set_compartment_style($i_x,$i_y,$s_style) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				$this->verify_coordinates($i_x,$i_y);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_style);
			} // if
			$this->arht_compartment_style_[''.$i_x.'_'.$i_y]=$s_style;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_compartment_style


	// An empty string unsets the common classes.
	public function set_compartments_common_classes($s_classes) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_classes);
			} // if
			$this->s_compartments_common_classes_=$s_classes;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_compartments_common_classes

	// Rturns a string. If the common classes are not set, then
	// it returns an empty string.
	public function get_compartments_common_classes() {
		try {
			$s_out=''.$this->s_compartments_common_classes_;
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_compartments_common_classes

	// Sets the compartment TD-tag's class attribute.
	public function set_compartment_classes($i_x,$i_y,$s_class) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				$this->verify_coordinates($i_x,$i_y);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_class);
			} // if
			$this->arht_compartment_classes_[''.$i_x.'_'.$i_y]=$s_class;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_compartment_classes

	public function set_compartment_HTML($i_x,$i_y,$s_html) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				$this->verify_coordinates($i_x,$i_y);
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_html);
			} // if
			$this->arht_compartment_HTML_[''.$i_x.'_'.$i_y]=$s_html;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_compartment_HTML

	public function get_compartment_HTML_id($i_x,$i_y) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				$this->verify_coordinates($i_x,$i_y);
			} // if
			// Please update the to_s, if you change its format.
			// The to_s does not use this method due to speed considerations.
			$s_out=$s_html_id_prefix_.'_'.$i_x.'_'.$i_y;
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_compartment_HTML_id

	public function get_table_HTML_id() {
		try {
			$s_out=$s_html_id_prefix_.'_table';
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // get_table_HTML_id


	// An empty string can be used for clearing the attribute.
	public function set_table_style($s_style) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_style);
			} // if
			$this->s_table_style_=&$s_style;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_table_style


	// An empty string can be used for clearing the attribute.
	public function set_table_class($s_class) {
		try {
			if(sirelSiteConfig::$debug_PHP) {
				sirelLang::assert_type(__FILE__, __LINE__, __CLASS__,
						__FUNCTION__,'sirelTD_is_mbstring', $s_class);
			} // if
			$this->s_table_class_=&$s_class;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_table_class

	private function to_s_rows() {
		try {
			$lc_s_linebreak="\n"; // instance reuse
			$lc_s_emptystring='';
			$lc_s_underscore='_';

			$s_table_rows='';
			$s_row='';

			$s_row_start='<tr>'.$lc_s_linebreak;
			$s_row_end='</tr>'.$lc_s_linebreak;

			$s_td_s1='<td id="'; // instance reuse
			$s_td_s2='" class="';
			$s_td_s3='" style="';
			$s_td_s4='">'.$lc_s_linebreak;
			$s_td_end=$lc_s_linebreak.'</td>'.$lc_s_linebreak;

			$s_html_id_s1= $this->s_html_id_prefix_.$lc_s_underscore;

			$i_x=0;
			$i_y=0;
			$s_html_id='';
			$s_key='';
			$x=NULL;
			for($i_y=0;$i_y<=$this->i_y_max_;$i_y++) {
				$s_row=$lc_s_emptystring.$s_row_start;
				for($i_x=0;$i_x<=$this->i_x_max_;$i_x++) {
					$s_key=$lc_s_emptystring.$i_x.$lc_s_underscore.$i_y;
					$s_html_id=$s_html_id_s1.$s_key;

					$s_classes=$this->s_compartments_common_classes_;
					$x=$this->arht_compartment_classes_[$s_key];
					if($x!=NULL) {
						$s_classes=$x;
					} // if

					$s_style=$this->s_compartments_common_style_;
					$x=$this->arht_compartment_style_[$s_key];
					if($x!=NULL) {
						$s_style=$x;
					} // if

					$s_row=$s_row.$s_td_s1.$s_html_id.
							$s_td_s2.$s_classes.$s_td_s3.$s_style.$s_td_s4.
							$this->arht_compartment_HTML_[$s_key].$s_td_end;
				} // for
				$s_row=$s_row.$s_row_end;
				$s_table_rows=$s_table_rows.$s_row;
			} // for
			return $s_table_rows;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // to_s_rows

	// Returns the HTML code of the table.
	public function to_s() {
		try {
			$s_table_start="\n".'<table class="'.$this->s_table_class_.
					'" style="'.$this->s_table_style_.'" id="'.
					$this->get_table_HTML_id().'">'."\n".
					'<tbody>'."\n";
			$s_table_rows=$this->to_s_rows();
			$s_table_end=$s1.'</tbody>'."\n".
					'</table>'."\n";
			$s_out=$s_table_start.$s_table_rows.$s_table_end;
			return $s_out;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // to_s

	public function clear_compartments_style() {
		try {
			$this->arht_compartment_style_=array();
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // clear_compartments_style

	public function clear_compartments_class() {
		try {
			$this->arht_compartment_classes_=array();
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // clear_compartments_class

	// Clears all HTML from the compartments, but
	// leaves the HTML ids and all the rest of the
	// compartment related datata intact, the way it was.
	//
	// If one calls this method, then one probably also
	// wants to call the method generate_new_html_id_prefix().
	public function clear_compartments_HTML() {
		try {
			$this->arht_compartment_HTML_=array();
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // clear_compartments_HTML

} // sirel_htmlcg_table_t1


// ---------------------------------------------------------

?>
