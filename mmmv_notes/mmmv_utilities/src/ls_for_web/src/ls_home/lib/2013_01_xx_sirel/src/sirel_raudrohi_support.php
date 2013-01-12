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
require_once('sirel_fs.php');
// Raudrohi JavaScript library kernel port specific stuff.
class raudrohi_support {

	private static function port_YUI_3_0_JS_and_CSS(&$ob_html) {
		try {
			$s_1=sirelSiteConfig::$various['confighook_url_yui_3_0'].'/build/';

			$ob_html->add_2_ar_css($s_1.'cssreset/reset-context-min.css');
			$ob_html->add_2_ar_css($s_1.'cssfonts/fonts-context-min.css');

			$ob_html->add_2_ar_javascript($s_1.'yui/yui-min.js');
			$ob_html->add_2_ar_javascript($s_1.'oop/oop-min.js');
			$ob_html->add_2_ar_javascript($s_1.'event-custom/event-custom-min.js');
			$ob_html->add_2_ar_javascript($s_1.'attribute/attribute-min.js');
			$ob_html->add_2_ar_javascript($s_1.'pluginhost/pluginhost-min.js');
			$ob_html->add_2_ar_javascript($s_1.'base/base-min.js');
			$ob_html->add_2_ar_javascript($s_1.'plugin/plugin-min.js');
			$ob_html->add_2_ar_javascript($s_1.'loader/loader-min.js');
			$ob_html->add_2_ar_javascript($s_1.'json/json-min.js');
			$ob_html->add_2_ar_javascript($s_1.'dom/dom-min.js');
			$ob_html->add_2_ar_javascript($s_1.'node/node-min.js');
			$ob_html->add_2_ar_javascript($s_1.'event/event-min.js');
			$ob_html->add_2_ar_javascript($s_1.'datatype/datatype-min.js');
			$ob_html->add_2_ar_javascript($s_1.'event-simulate/event-simulate-min.js');
			$ob_html->add_2_ar_javascript($s_1.'node/node-event-simulate-min.js');
			$ob_html->add_2_ar_javascript($s_1.'node-focusmanager/node-focusmanager-min.js');
			$ob_html->add_2_ar_javascript($s_1.'dump/dump-min.js');
			$ob_html->add_2_ar_javascript($s_1.'substitute/substitute-min.js');
			$ob_html->add_2_ar_javascript($s_1.'queue-promote/queue-promote-min.js');
			$ob_html->add_2_ar_javascript($s_1.'io/io-min.js');
			$ob_html->add_2_ar_javascript($s_1.'collection/collection-min.js');
			$ob_html->add_2_ar_javascript($s_1.'async-queue/async-queue-min.js');
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // port_YUI_3_0_JS_and_CSS

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
				raudrohi_support::port_YUI_3_0_JS_and_CSS($ob_html);
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
				$p=sirelSiteConfig::$various['confighook_url_yui_3_3_0'].
						'/build/';
				raudrohi_support::port_YUI_3_x_common_t1($p,$ob_html);
			} // else
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // port_YUI_3_3_0

	private static $b_config_hooks_processed=False;
	private static function process_config_hooks() {
		try {
			if (raudrohi_support::$b_config_hooks_processed==True) {
				return;
			} // if
			if(array_key_exists('confighook_url_lib_raudrohi',sirelSiteConfig::$various)!=True) {
				if(array_key_exists('application_root',sirelSiteConfig::$various)!=True) {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'Configuration variable named "application_root" '.
							'is missing from the sirelSiteConfig::$various.'.
							"\n GUID='56d2e944-2aaa-4ea5-8290-02a26101ccd7'");
				} // if
				$application_root=sirelSiteConfig::$various['application_root'];
				$s_candidate=$application_root.'/lib/raudrohi';
				if(is_dir($s_candidate)==True) {
					sirelSiteConfig::$various['confighook_url_lib_raudrohi']='./'.
							'lib/raudrohi/';
				} else {
					sirelThrowLogicException(__FILE__, __LINE__,
							__CLASS__.'->'.__FUNCTION__.': '.
							'Configuration variable named '.
							'"confighook_url_lib_raudrohi" '.
							'could not be auto-assembled from the '.
							'"application_root"(=='.$application_root.
							', nor is it explicitly present '.
							'in the sirelSiteConfig::$various.'.
							"\n GUID='c3e09a50-c20f-4fef-8190-02a26101ccd7'");
				} // else
			} // if
			$s_url_lib_raudrohi=sirelSiteConfig::$various['confighook_url_lib_raudrohi'];
			if(array_key_exists('confighook_raudrohi_port',sirelSiteConfig::$various)!=True) {
				// A default value is also set to it in the
				// sirel_engine_configuration.php
				sirelSiteConfig::$various['confighook_raudrohi_port']='YUI_3_0';
				//sirelSiteConfig::$various['confighook_raudrohi_port']='YUI_3_3_0';
			} // if
			if(array_key_exists('confighook_url_yui_3_0',sirelSiteConfig::$various)!=True) {
				sirelSiteConfig::$various['confighook_url_yui_3_0']=$s_url_lib_raudrohi.
						'/third_party/yahoo/yui_3_0/';
			} // if
			if(array_key_exists('confighook_url_yui_3_3_0',sirelSiteConfig::$various)!=True) {
				sirelSiteConfig::$various['confighook_url_yui_3_3_0']=$s_url_lib_raudrohi.
						'/third_party/yahoo/yui_3_3_0/';
			} // if
			raudrohi_support::$b_config_hooks_processed=True;
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // process_config_hooks

	// The main idea of this function is that the version of the
	// Raudrohi JavaScript Library CSS and JavaScript files changes
	// from time to time and due to web browser cache the CSS and
	// JavaScript file names have to change with every version change.
	// The file name change forces the web browser to download the new
	// version of the CSS and JavaScript files.
	private static function set_raudrohi_all_in_one_and_raudrohi_vX_CSS(&$sirelHTMLPage_instance) {
		try {
			$b_raudrohi_all_in_one_found=False;
			$b_raudrohi_css_found=False;
			$s_url_lib_raudrohi=sirelSiteConfig::$various['confighook_url_lib_raudrohi'];
			if(array_key_exists('application_root',sirelSiteConfig::$various)!=True) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Configuration variable named "application_root" '.
						'is missing from the sirelSiteConfig::$various.'.
						"\n GUID='e435892a-7f93-4e40-9590-02a26101ccd7'");
			} // if
			$application_root=sirelSiteConfig::$various['application_root'];
			$s_candidate=$application_root.'/'.$s_url_lib_raudrohi;
			if(is_dir($s_candidate)!=True) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Due to bandwidth concernes the current version '.
						'of the Sirel PHP library requires that each site '.
						'serves its own copy of the '.
						'Raudrohi JavaScript Library. '."\n".
						'The configuration variable, '."\n".
						'"confighook_url_lib_raudrohi"(=='.
						$s_url_lib_raudrohi.'),'."\n".
						' must depict a relative file paht. '.
						'Configuration variable "application_root"=='.
						$application_root.'  .'.
						"\n GUID='3aa42f58-a434-4504-b380-02a26101ccd7'");
			} // if
			$ar_fp=sirelFS::ls($s_candidate,
					'.*raudrohi_all_in_one_v..?.?.?.?.?.js');
			if(count($ar_fp)==0) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Due to bandwidth concernes the current version '.
						'of the Sirel PHP library requires that each site '.
						'serves its own copy of the '.
						'Raudrohi JavaScript Library. '."\n".
						'The file raudrohi_all_in_one_v<version number>.js '.
						'could not be found from '.$s_url_lib_raudrohi.
						"\n GUID='9300da4f-e228-47c1-b480-02a26101ccd7'");
			} // if
			$s_url=$s_url_lib_raudrohi.'/'.$ar_fp[0];
			$sirelHTMLPage_instance->add_2_ar_javascript($s_url);

			$ar_fp=sirelFS::ls($s_candidate.'/css',
					'.*raudrohi_v..?.?.?.?.?.css');
			if(count($ar_fp)==0) {
				sirelThrowLogicException(__FILE__, __LINE__,
						__CLASS__.'->'.__FUNCTION__.': '.
						'Due to bandwidth concernes the current version '.
						'of the Sirel PHP library requires that each site '.
						'serves its own copy of the '.
						'Raudrohi JavaScript Library. '."\n".
						'The file raudrohi_v<version number>.css'.
						'could not be found from '.$s_url_lib_raudrohi.
						"\n GUID='9f5e8315-0843-4105-a480-02a26101ccd7'");
			} // if
			$s_url=$s_url_lib_raudrohi.'/css/'.$ar_fp[0];
			$sirelHTMLPage_instance->add_2_ar_css($s_url);
		}catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	} // set_raudrohi_all_in_one_and_raudrohi_vX_CSS

	public static function set_CSS_and_JavaScript_includes(
			&$sirelHTMLPage_instance) {
		try {
			raudrohi_support::process_config_hooks();
			$s_raudrohi_port=sirelSiteConfig::$various['confighook_raudrohi_port'];
			switch ($s_raudrohi_port) {
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
							'sirelSiteConfig::$various["confighook_raudrohi_port"]=='.
							$s_raudrohi_port.'.');
					break;
			} // switch
			raudrohi_support::set_raudrohi_all_in_one_and_raudrohi_vX_CSS($sirelHTMLPage_instance);
		} catch (Exception $err_exception) {
			sirelBubble(__FILE__,__LINE__,$err_exception,
					__CLASS__.'->'.__FUNCTION__.': ');
		} // catch
	}
	// set_CSS_and_JavaScript_includes


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
