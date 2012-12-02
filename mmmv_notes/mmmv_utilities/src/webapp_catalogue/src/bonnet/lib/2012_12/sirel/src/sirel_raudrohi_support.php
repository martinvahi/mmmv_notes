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

require_once('sirel_html.php');
// Raudrohi JavaScript library kernel port specific stuff.
class raudrohi_support {

	private static function port_YUI_3_x_common_t1(&$p,&$ob_html) {
		try {
			$ob_html->add_2_ar_css($p.'reset/reset-min.css');
			$ob_html->add_2_ar_css($p.'fonts/fonts-min.css');
			$ob_html->add_2_ar_javascript($p.'yui/yui-min.js');
			$ob_html->add_2_ar_javascript($p.'yui/yui-base-min.js');
			$ob_html->add_2_ar_javascript($p.'oop/oop-min.js');
			$ob_html->add_2_ar_javascript($p.'dom/dom-min.js');
			$ob_html->add_2_ar_javascript($p.'get/get-min.js');
			$ob_html->add_2_ar_javascript($p.'loader/loader-min.js');
			$ob_html->add_2_ar_javascript($p.'plugin/plugin-min.js');
			$ob_html->add_2_ar_javascript($p.'pluginhost/pluginhost-min.js');
			$ob_html->add_2_ar_javascript($p.'event/event-min.js');
			/*
				$ob_html->add_2_ar_javascript($p.'event/event-base-min.js');
				$ob_html->add_2_ar_javascript($p.'event/event-delegate-min.js');
				$ob_html->add_2_ar_javascript($p.'event/event-key-min.js');
				$ob_html->add_2_ar_javascript($p.'event/event-mouseenter-min.js');
				$ob_html->add_2_ar_javascript($p.'event/event-mousewheel-min.js');
				$ob_html->add_2_ar_javascript($p.'event/event-focus-min.js');
				$ob_html->add_2_ar_javascript($p.'event/event-resize-min.js');
				$ob_html->add_2_ar_javascript($p.'event-custom/event-custom-min.js');
				$ob_html->add_2_ar_javascript($p.'event-custom/event-custom-base-min.js');
				$ob_html->add_2_ar_javascript($p.'event-custom/event-custom-complex-min.js');
				$ob_html->add_2_ar_javascript($p.'cache/cache-min.js');
				$ob_html->add_2_ar_javascript($p.'node/node-min.js');
				  if(sirelSiteConfig::$debug_JavaScript){
				  // As of 10.2009 the console component is still in
				  // beta status and its CSS seems to mess things up.
				$ob_html->add_2_ar_javascript($p.'console/console-min.js');
				$ob_html->add_2_ar_javascript($p.'console/console-filters-min.js');
				  } // if
				$ob_html->add_2_ar_javascript($p.'base/base-min.js');
				$ob_html->add_2_ar_javascript($p.'node/node-event-delegage-min.js');
				$ob_html->add_2_ar_javascript($p.'io/io-min.js');
				$ob_html->add_2_ar_javascript($p.'io/io-base-min.js');
				$ob_html->add_2_ar_javascript($p.'io/io-form-min.js');
				$ob_html->add_2_ar_javascript($p.'io/io-queue-min.js');
				$ob_html->add_2_ar_javascript($p.'io/io-xdr-min.js');
				$ob_html->add_2_ar_javascript($p.'io/io-upload-iframe-min.js');
				$ob_html->add_2_ar_javascript($p.'json/json-min.js');
				$ob_html->add_2_ar_javascript($p.'json/json-parse-min.js');
				$ob_html->add_2_ar_javascript($p.'json/json-stringify-min.js');

				$ob_html->add_2_ar_javascript($p.'anim/anim-min.js');
				$ob_html->add_2_ar_javascript($p.'test/test-min.js');
				$ob_html->add_2_ar_javascript($p.'overlay/overlay-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-ddm-base-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-ddm-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-drag-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-proxy-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-scroll-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-plugin-min.js');
				$ob_html->add_2_ar_javascript($p.'dd/dd-drop-min.js');
			*/
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // port_YUI_3_x_common_t1

	private static function port_YUI_3_0(&$sirelHTMLPage_instance) {
		try {
			$ob_html=&$sirelHTMLPage_instance;
			if (sirelSiteConfig::$use_content_delivery_networks_for_JavaScript_dependency_libs) {
				$ob_html->add_2_ar_css('http://yui.yahooapis.com/combo?3.0.0/build/cssreset/reset-context-min.css&3.0.0/build/cssfonts/fonts-context-min.css');
				$ob_html->add_2_ar_javascript('http://yui.yahooapis.com/combo?3.0.0/build/yui/yui-min.js&3.0.0/build/oop/oop-min.js&3.0.0/build/event-custom/event-custom-min.js&3.0.0/build/attribute/attribute-min.js&3.0.0/build/pluginhost/pluginhost-min.js&3.0.0/build/base/base-min.js&3.0.0/build/plugin/plugin-min.js&3.0.0/build/loader/loader-min.js&3.0.0/build/json/json-min.js&3.0.0/build/dom/dom-min.js&3.0.0/build/node/node-min.js&3.0.0/build/event/event-min.js&3.0.0/build/datatype/datatype-min.js&3.0.0/build/event-simulate/event-simulate-min.js&3.0.0/build/node/node-event-simulate-min.js&3.0.0/build/node-focusmanager/node-focusmanager-min.js&3.0.0/build/dump/dump-min.js&3.0.0/build/substitute/substitute-min.js&3.0.0/build/queue-promote/queue-promote-min.js&3.0.0/build/io/io-min.js&3.0.0/build/collection/collection-min.js&3.0.0/build/async-queue/async-queue-min.js');
			} else {
				$p=sirelSiteConfig::$various['url_yui_3_0'].'build/';
				raudrohi_support::port_YUI_3_x_common_t1($p,$ob_html);
			} // else
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // port_YUI_3_0

	private static function port_YUI_3_3_0(&$sirelHTMLPage_instance) {
		try {
			$ob_html=&$sirelHTMLPage_instance;
			if (sirelSiteConfig::$use_content_delivery_networks_for_JavaScript_dependency_libs) {
				$ob_html->add_2_ar_css('http://yui.yahooapis.com/combo?3.3.0/build/cssfonts/fonts-min.css&3.3.0/build/cssfonts/fonts-context-min.css&3.3.0/build/cssreset/reset-min.css&3.3.0/build/cssgrids/grids-min.css&3.3.0/build/cssreset/reset-context-min.css&3.3.0/build/cssbase/base-min.css&3.3.0/build/widget/assets/skins/sam/widget.css&3.3.0/build/widget/assets/skins/sam/widget-stack.css&3.3.0/build/autocomplete/assets/skins/sam/autocomplete.css&3.3.0/build/console/assets/skins/sam/console.css&3.3.0/build/console/assets/skins/sam/console-filters.css&3.3.0/build/cssbase/base-context-min.css&3.3.0/build/datatable/assets/skins/sam/datatable.css&3.3.0/build/dial/assets/skins/sam/dial.css&3.3.0/build/node-flick/assets/skins/sam/node-flick.css&3.3.0/build/node-menunav/assets/skins/sam/node-menunav.css&3.3.0/build/overlay/assets/skins/sam/overlay.css&3.3.0/build/resize/assets/skins/sam/resize.css&3.3.0/build/scrollview/assets/skins/sam/scrollview-base.css&3.3.0/build/scrollview/assets/skins/sam/scrollview-scrollbars.css&3.3.0/build/slider/assets/skins/sam/slider.css&3.3.0/build/tabview/assets/skins/sam/tabview.css&3.3.0/build/test/assets/skins/sam/test.css');
				$ob_html->add_2_ar_javascript('http://yui.yahooapis.com/combo?3.3.0/build/yui/yui-min.js&3.3.0/build/oop/oop-min.js&3.3.0/build/dom/dom-min.js&3.3.0/build/dom/dom-style-ie-min.js&3.3.0/build/event-custom/event-custom-min.js&3.3.0/build/event/event-min.js&3.3.0/build/pluginhost/pluginhost-min.js&3.3.0/build/node/node-min.js&3.3.0/build/event/event-base-ie-min.js&3.3.0/build/node/align-plugin-min.js&3.3.0/build/attribute/attribute-min.js&3.3.0/build/base/base-min.js&3.3.0/build/anim/anim-min.js&3.3.0/build/arraysort/arraysort-min.js&3.3.0/build/async-queue/async-queue-min.js&3.3.0/build/classnamemanager/classnamemanager-min.js&3.3.0/build/collection/collection-min.js&3.3.0/build/escape/escape-min.js&3.3.0/build/event-valuechange/event-valuechange-min.js&3.3.0/build/intl/intl-min.js&3.3.0/build/datatype/lang/datatype.js&3.3.0/build/datatype/datatype-min.js&3.3.0/build/querystring/querystring-stringify-simple-min.js&3.3.0/build/queue-promote/queue-promote-min.js&3.3.0/build/io/io-min.js&3.3.0/build/json/json-min.js&3.3.0/build/jsonp/jsonp-min.js&3.3.0/build/jsonp/jsonp-url-min.js&3.3.0/build/dom/selector-css3-min.js&3.3.0/build/widget/widget-min.js&3.3.0/build/widget/widget-base-ie-min.js&3.3.0/build/widget/widget-position-min.js&3.3.0/build/widget/widget-position-align-min.js&3.3.0/build/widget/widget-stack-min.js&3.3.0/build/yql/yql-min.js&3.3.0/build/autocomplete/lang/autocomplete.js&3.3.0/build/autocomplete/autocomplete-min.js&3.3.0/build/autocomplete/autocomplete-list-keys-min.js&3.3.0/build/text/text-min.js&3.3.0/build/autocomplete/autocomplete-filters-min.js&3.3.0/build/autocomplete/autocomplete-filters-accentfold-min.js&3.3.0/build/highlight/highlight-min.js&3.3.0/build/autocomplete/autocomplete-highlighters-min.js&3.3.0/build/autocomplete/autocomplete-highlighters-accentfold-min.js&3.3.0/build/autocomplete/autocomplete-list-keys-min.js&3.3.0/build/autocomplete/autocomplete-plugin-min.js&3.3.0/build/plugin/plugin-min.js&3.3.0/build/cache/cache-min.js&3.3.0/build/charts/charts-min.js&3.3.0/build/dump/dump-min.js&3.3.0/build/substitute/substitute-min.js&3.3.0/build/console/lang/console.js&3.3.0/build/console/console-min.js&3.3.0/build/console/console-filters-min.js&3.3.0/build/cookie/cookie-min.js&3.3.0/build/dataschema/dataschema-min.js&3.3.0/build/datasource/datasource-min.js&3.3.0/build/recordset/recordset-min.js&3.3.0/build/stylesheet/stylesheet-min.js&3.3.0/build/datatable/lang/datatable.js&3.3.0/build/datatable/datatable-min.js&3.3.0/build/dd/dd-min.js&3.3.0/build/dd/dd-gestures-min.js&3.3.0/build/dd/dd-drop-plugin-min.js&3.3.0/build/event/event-touch-min.js&3.3.0/build/event-gestures/event-gestures-min.js&3.3.0/build/dd/dd-gestures-min.js&3.3.0/build/dd/dd-plugin-min.js&3.3.0/build/transition/transition-min.js&3.3.0/build/dial/lang/dial.js&3.3.0/build/dial/dial-min.js&3.3.0/build/dom/dom-style-ie-min.js&3.3.0/build/editor/editor-min.js&3.3.0/build/event/event-base-ie-min.js&3.3.0/build/event-simulate/event-simulate-min.js&3.3.0/build/history/history-min.js&3.3.0/build/history/history-hash-ie-min.js&3.3.0/build/history/history-hash-ie-min.js&3.3.0/build/imageloader/imageloader-min.js&3.3.0/build/loader/loader-min.js&3.3.0/build/node-flick/node-flick-min.js&3.3.0/build/node/node-event-simulate-min.js&3.3.0/build/node-focusmanager/node-focusmanager-min.js&3.3.0/build/node/node-load-min.js&3.3.0/build/node-menunav/node-menunav-min.js&3.3.0/build/widget/widget-position-constrain-min.js&3.3.0/build/widget/widget-stdmod-min.js&3.3.0/build/overlay/overlay-min.js&3.3.0/build/querystring/querystring-min.js&3.3.0/build/querystring/querystring-parse-simple-min.js&3.3.0/build/async-queue/async-queue-min.js&3.3.0/build/resize/resize-min.js&3.3.0/build/scrollview/scrollview-base-min.js&3.3.0/build/scrollview/scrollview-base-ie-min.js&3.3.0/build/scrollview/scrollview-scrollbars-min.js&3.3.0/build/scrollview/scrollview-min.js&3.3.0/build/scrollview/scrollview-base-ie-min.js&3.3.0/build/scrollview/scrollview-paginator-min.js&3.3.0/build/node/shim-plugin-min.js&3.3.0/build/slider/slider-min.js&3.3.0/build/sortable/sortable-min.js&3.3.0/build/sortable/sortable-scroll-min.js&3.3.0/build/tabview/tabview-base-min.js&3.3.0/build/widget/widget-child-min.js&3.3.0/build/widget/widget-parent-min.js&3.3.0/build/tabview/tabview-min.js&3.3.0/build/tabview/tabview-plugin-min.js&3.3.0/build/test/test-min.js&3.3.0/build/swfdetect/swfdetect-min.js&3.3.0/build/swf/swf-min.js&3.3.0/build/uploader/uploader-min.js&3.3.0/build/widget-anim/widget-anim-min.js&3.3.0/build/widget/widget-base-ie-min.js&3.3.0/build/widget/widget-locale-min.js&3.3.0/build/profiler/profiler-min.js');
			} else {
				$p=sirelSiteConfig::$various['url_yui_3_3_0'].'build/';
				raudrohi_support::port_YUI_3_x_common_t1($p,$ob_html);
			} // else
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // port_YUI_3_3_0

	public static function set_portspecific_CSS_and_JavaScript_includes(
			&$sirelHTMLPage_instance) {
		try {
			switch (sirelSiteConfig::$javascript_side_raudrohi_port) {
				case 'YUI_3_3_0':
					raudrohi_support::port_YUI_3_3_0($sirelHTMLPage_instance);
					break;
				case 'YUI_3_0':
					raudrohi_support::port_YUI_3_0($sirelHTMLPage_instance);
					break;
				default:
					throw new Exception(
					__CLASS__.'->'.__FUNCTION__.
							': There\'s no branch for '.
							'sirelSiteConfig::$javascript_side_raudrohi_port=='.
							sirelSiteConfig::$javascript_side_raudrohi_port.'.');
					break;
			} // switch
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	}
	// set_portspecific_CSS_and_JavaScript_includes


	private static $microsession_wrapper_ht_cache_=null;
	// The $dpckg is expected to be the output of the
	// sirelFormscriptSupport::deserialize.  The
	// unpack_microsession_package returns binary version
	// of the data hashtable. For the sake of efficiency it
	// caches the binary version of the microsession wrapper
	// hashtable to the raudrohi_support::$microsession_wrapper_ht_cache_.
	public static function unpack_microsession_package(&$dpckg) {
		try {
			raudrohi_support::$microsession_wrapper_ht_cache_=sirelLang::ProgFTE2ht(
					$dpckg->data_);
			$arht_wrapper=&raudrohi_support::$microsession_wrapper_ht_cache_;
			$arht_data_in=&sirelLang::ProgFTE2ht($arht_wrapper['data']);
			$arht_wrapper['data']='unset at 86fa713b-29b5-4d19-8fdf-3090fbee9b10';
			return $arht_data_in;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	}
	// unpack_microsession_package
	// Returns a string that represents a serialized version of
	// the microsession data package. It is assumed that the
	// raudrohi_support::unpack_microsession_package has been used
	// to unpack the microsession package that is being replied to
	// by using the raudrohi_support::pack_microsession_package
	public static function pack_microsession_package(&$arht_data_out) {
		try {
			$arht_wrapper=&raudrohi_support::$microsession_wrapper_ht_cache_;
			if ($arht_wrapper == NULL) {
				sirelThrowLogicException(__FILE__,__LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'May be the raudrohi_support::'.
						'unpack_microsession_package '.
						'wasn\'nt used before calling this method? ');
			} // if
			$arht_wrapper['data']=&sirelLang::ht2ProgFTE($arht_data_out);
			$answer=$arht_wrapper['return_command'].'|||'.
					sirelLang::ht2ProgFTE($arht_wrapper);
			raudrohi_support::$microsession_wrapper_ht_cache_=null;
			return $answer;
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	}
// pack_microsession_package
}
// raudrohi_support
?>
