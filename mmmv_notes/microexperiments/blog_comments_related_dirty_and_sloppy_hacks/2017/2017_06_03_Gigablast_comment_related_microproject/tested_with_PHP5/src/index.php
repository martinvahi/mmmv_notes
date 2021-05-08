<!DOCTYPE HTML>
<html>
<!--
Initial author of this file: Martin.Vahi@softf1.com
This PHP/HTML file is in public domain.
-->
<head>
    <title>Flimsy Demo as a Comment</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="the_document_body">
<p style="color:red;">
    This demo is a flimsy blog-post comment that
    <br/>
    stops working the moment the search engine
    <br/>
    changes its API to a "sufficiently great" extent.
</p>
    <br/><br/>
<p>
    The source of this micro-project <strong>MIGHT</strong> be downloadable from 
    <a href="https://longterm.softf1.com/2017/blog_resources/2017_06_03_Gigablast_comment_related_microproject.tar.xz">this link</a>.
</p>
    <br/><br/>
<p>
    <span style="font-family: monospace;">
    <?php

    require_once(realpath('.') . '/sirel_text_concatenation.php');

    class Dirty_hack_that_should_not_be_in_production
    {
        // In production a proper version of this function must be used,
        // a version that checks for the presence of files, checks that
        // the path actually references a file and not a folder, etc.
        // The input parameter types should be verified, id est that the
        // $s_file_path is actually a string and not just a string, but
        // a non-empty string, etc.
        public function file2str(&$s_file_path)
        {
            try {
                $s_out = '';
                $s_fp =& $s_file_path;
                $i_f_size = filesize($s_fp);
                if (0 < $i_f_size) {
                    $ob_file_handle_0 = fopen($s_fp, "r");
                    $s_out = fread($ob_file_handle_0, $i_f_size);
                    fclose($ob_file_handle_0);
                } // if
                return $s_out;
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="02325640-932c-4a06-a424-1230405061e7"');
            } // catch
        } // file2str

        public function str2file(&$s_in, &$s_fp)
        {
            try {
                $ob_file_handle_0 = fopen($s_fp, "w");
                fwrite($ob_file_handle_0, $s_in);
                fclose($ob_file_handle_0);
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="1485503d-a737-45c0-9424-1230405061e7"');
            } // catch
        } // str2file

        private $b_hack_tmp_dir_creation_attempt_done_ = FALSE;

        public function s_generate_tmp_file_path_t1()
        {
            try {
                if ($this->b_hack_tmp_dir_creation_attempt_done_ != TRUE) {
                    // Inefficient as hell, but good enough for this dirty demo hack
                    shell_exec('mkdir -p ./tmp_');
                    $this->b_hack_tmp_dir_creation_attempt_done_ = TRUE;
                } // if
                $s_tmp_0 = date('_Y_m_d_H_i_s_v_u_'); // v for milliseconds in PHP 7
                $s_fp_out = './tmp_/tmp_php_' . $s_tmp_0 . rand(0, 9999) . rand(0, 9999) . rand(0, 9999) . '.txt';
                return $s_fp_out;
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="4a41e783-9fe6-41d8-9c24-1230405061e7"');
            } // catch
        } // s_generate_tmp_file_path_t1

        public function s_HTMLize_t1(&$s_in)
        {
            try {
                $s_1 = $s_in;
                $s_0 = mb_ereg_replace('&', '&amp;', $s_1); // must be before the "foo -> &bar;"
                $s_1 = mb_ereg_replace("\t", '    ', $s_0); // tab to 4 spaces
                $s_0 = mb_ereg_replace(' ', '&nbsp;', $s_1); // space to HTML-no-breaking-space
                $s_1 = mb_ereg_replace('<', '&lt;', $s_0); // must be before the '"\n" -> "<br/>\n"'
                $s_0 = mb_ereg_replace('>', '&gt;', $s_1);
                $s_1 = mb_ereg_replace('"', '&quot;', $s_0);
                $s_0 = mb_ereg_replace('\'', '&apos;', $s_1);
                $s_1 = mb_ereg_replace('£', '&pound;', $s_0);
                $s_0 = mb_ereg_replace('¥', '&yen;', $s_1);
                $s_1 = mb_ereg_replace('¢', '&cent;', $s_0);
                $s_0 = mb_ereg_replace("\r\n", "\n", $s_1); // normalize Windows line breaks
                $s_1 = mb_ereg_replace("\r", "\n", $s_0);
                $s_0 = mb_ereg_replace("\n", "<br/>\n", $s_1);
                $s_1 = mb_ereg_replace('€', '&euro;', $s_0);
                $s_out = $s_1;
                return $s_out;
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="5aa9f8a9-b7c1-45d1-b224-1230405061e7"');
            } // catch
        } // s_HTMLize_t1

        public function s_html_code_of_this_PHP_file_t1()
        {
            try {
                $s_fp = __FILE__;
                $s_src = $this->file2str($s_fp);
                $s_src_html = $this->s_HTMLize_t1($s_src);
                return $s_src_html;
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="26f7d012-628e-471c-a124-1230405061e7"');
            } // catch
        } // s_html_code_of_this_PHP_file_t1

        public function s_search_result_item_2_HTML_t1(&$s_title, &$s_url,
                                                       $s_description = '')
        {
            try {
                $arht_s = array();
                array_push($arht_s,
                    "\n<br/>\n<a href=\"" . $s_url . '">' . $s_title . "</a><br/>\n");
                if ($s_description !== '') {
                    array_push($arht_s, '<span style="color: cadetblue;">' .
                        $s_description . "</span><br/>\n");
                } // if
                array_push($arht_s, "<br/>\n");
                $s_out = s_concat_array_of_strings($arht_s);
                return $s_out;
            } catch (Exception $err_exception) {
                sirelBubble_t2($err_exception,
                    "GUID='d083005e-4dfb-49a1-a324-1230405061e7'");
            } // catch
        } // s_search_result_item_2_HTML_t1

        // Search engine JSON format specific function.
        public function s_HTMLize_search_results_JSON_t1(&$s_json_in)
        {
            try {
                $arht_s = array();
                $arht_0 = json_decode($s_json_in, TRUE)['results'];
                //var_dump($arht_0); // useful for studying the structure
                $i_len = count($arht_0);
                $x_elem = NULL;
                $s_item_html = NULL;
                for ($i = 0; $i < $i_len; $i++) {
                    $x_elem = $arht_0[$i];
                    //-----------------------------------------------------
                    // Most of the search engine specific code, but not all of it:
                    // Obtaining the "results" array is also search engine specific.
                    $arht_package = $x_elem['package'];
                    $s_version = $arht_package['version'];
                    $s_title = $arht_package['name'] . '  version: ' . $s_version;
                    $s_description = $arht_package['description'];
                    //----
                    $arht_links = $arht_package['links'];
                    $s_home_page_url = $arht_links['homepage'];
                    $s_repository_url = $arht_links['repository'];
                    //----
                    $s_description = $s_description . "<br/>\n" .
                        '<a href="' . $s_repository_url . '">Repository</a>' . "<br/>\n";
                    //----
                    $s_item_html = $this->s_search_result_item_2_HTML_t1(
                        $s_title, $s_home_page_url, $s_description);
                    //-----------------------------------------------------
                    array_push($arht_s, $s_item_html);
                } // for
                $s_out = s_concat_array_of_strings($arht_s);
                return $s_out;
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="edf6ce21-5bb1-4cde-8324-1230405061e7"');
            } // catch
        } // s_HTMLize_search_results_JSON_t1


        // This PHP script queries the search engine.
        // It does it by using the Bash script, but the use of the
        // Bash script is just an implementation detail.
        // If a bot-net is ordered to visit the web page that
        // runs this PHP script, then from the search engine's
        // perspective, all of the queries from the bot-net
        // come from the server that runs this PHP-script.
        // Being a source for DoS attacks is not a kind of reputation
        // that an average, honorable, software developer or
        // server owner wants to have.
        //
        // The reason, why an ordinary delay in PHP script is
        // not good enough is that bots can make parallel queries,
        // so that there are a lot of delays ticking in parallel.
        // The delay mechanism has to be global across queries.
        public function anti_DoS_delay_t1($i_seconds = 1)
        {
            try {
                //------------------------------------------------
                // This here is not the most elegant implementation,
                // but it'll work "well enough".
                //------------------------------------------------
                if ($i_seconds < 1) {
                    throw new Exception('$i_seconds == ' . $i_seconds . "\n" .
                        'but the requirement is: 1 <= $i_seconds ' . "\n" .
                        'GUID="42fc2eb2-af8d-4dea-8c24-1230405061e7"');
                }
                //------------------------------------------------
                if ($this->b_hack_tmp_dir_creation_attempt_done_ != TRUE) {
                    // Inefficient as hell, but good enough for this dirty demo hack
                    shell_exec('mkdir -p ./tmp_');
                } // if
                $s_GUID = '46a0215b-6a5b-471b-9224-1230405061e7';
                $s_fp = "./tmp_/tmp_anti_DoS_delay_" . $s_GUID . '.txt';
                $i_now = time();
                $i_past = $i_now;
                $b_try_to_rewrite_the_file = FALSE;
                try {
                    if (file_exists($s_fp) !== TRUE) {
                        $s_0 = '' . $i_now;
                        $this->str2file($s_0, $s_fp);
                        // The
                        sleep(2); // is unnecessary at this branch, but it's OK as a backup,
                        // should there be a bug somewhere else.
                    } //else
                    $s_0 = $this->file2str($s_fp);
                    $i_past = (int)$s_0; //
                    $s_0 = '' . $i_now;
                    $this->str2file($s_0, $s_fp); // overwrite an existing file
                } catch (Exception $err_exception) {
                    // A solution for handling the situation, where the
                    // file did not get written properly, multiple
                    // PHP processes collided at writing the global file,
                    // server lost power, etc.
                    $b_try_to_rewrite_the_file = TRUE;
                    sleep(2);
                } // catch
                if ($b_try_to_rewrite_the_file === TRUE) {
                    try {
                        $s_0 = '' . $i_now;
                        $this->str2file($s_0, $s_fp);
                    } catch (Exception $err_exception) {
                        // The writing will be tried again at the next
                        // call to this function.
                        // The safety delays have been waited out, so
                        // it's OK to ignore the current exception.
                    }
                } // if
                $i_0 = $i_now - $i_past;
                $i_antiDoS_delay_average = $i_seconds;
                if ($i_0 < 0) {
                    // In production code one would throw an exception here
                    // in DEBUG mode, but in this case, we'll skip that.
                    echo('<br/>WARNING near GUID=="25de332c-18ff-4cc2-8314-1230405061e7"<br/>');
                    $i_0 = 2;
                } // if
                if ($i_0 < $i_antiDoS_delay_average) {
                    sleep($i_0);
                } else {
                    // There does exist a possibility that this script
                    // is never executed for years. That's why the
                    // $i_antiDoS_delay_average has to be used here in stead of the $i_0 .
                    sleep($i_antiDoS_delay_average);
                } // else
            } catch (Exception $err_exception) {
                throw new Exception('' . $err_exception . "\n" .
                    'GUID="e941c92b-bed0-45ef-b114-1230405061e7"');
            } // catch
        } // anti_DoS_delay_t1

    } # Dirty_hack_that_should_not_be_in_production

    //---------------------------------------------------------------------

    function the_main_program()
    {
        try {
            $ob_dirty_hack_functions = new Dirty_hack_that_should_not_be_in_production();
            $ob_dirty_hack_functions->anti_DoS_delay_t1(); // before allocating or running "a lot"
            $s_fp_bash = './2017_06_03_Gigablast_related_comment_script_01_dot_bash.txt';
            $arht_s_out = array();
            //------------
            date_default_timezone_set('UTC');
            $s_0 = date('Y_m_d H:i:s'); // v for milliseconds in PHP 7
            $s_1 = '<span style="position: fixed; top:20px;right: 20px;">' .
                "\nQuery date at time zone 0: <br/>" . $s_0 . '</span>';
            array_push($arht_s_out, $s_1);
            //------------
            shell_exec('cp -f ' . __FILE__ . ' ./index_php.txt 2> /dev/null');
            $s_0 = "<br/>\n" .
                '<a href="./index_php.txt"><h1>The Source of this file</a>' .
                "\n<br/>\n" .
                'which also uses <a href="./' . $s_fp_bash . '">a bash script</a></h1>' .
                "\n<br/>\n";
            array_push($arht_s_out, $s_0);
            //$s_src_html = $ob_dirty_hack_functions->s_html_code_of_this_PHP_file_t1();
            //array_push($arht_s_out, $s_src_html."<br/>\n");
            //------------
            $s_fp_php_tmp_0 = $ob_dirty_hack_functions->s_generate_tmp_file_path_t1();
            //echo($s_fp_php_tmp_0 );
            $s_cmd = 'bash ' . $s_fp_bash . ' mode_return_tmp_file_path > ' . $s_fp_php_tmp_0 . ' 2> /dev/null; sync ;';
            shell_exec($s_cmd);
            $s_fp_bash_tmp = $ob_dirty_hack_functions->file2str($s_fp_php_tmp_0);
            unlink($s_fp_php_tmp_0); // deletes the file
            $s_json = $ob_dirty_hack_functions->file2str($s_fp_bash_tmp);
            unlink($s_fp_bash_tmp);
            //------------
            array_push($arht_s_out, "\n<h1>Search Results in a Custom Format</h1><br/>\n");
            $s_0 = $ob_dirty_hack_functions->s_HTMLize_search_results_JSON_t1($s_json);
            array_push($arht_s_out, $s_0);
            //------------
            $s_tmp_0 = '<h1>Search Results in <a href="http://json.org/">JSON</a> Format</h1>';
            $s_json_html = $ob_dirty_hack_functions->s_HTMLize_t1($s_json);
            array_push($arht_s_out, $s_tmp_0);
            array_push($arht_s_out, $s_json_html);
            //------------
            // The s_concat_array_of_strings(...) is used in stead of
            // $s_out=$s_out.$foo.$bar
            // only due to speed. Details MIGHT be found from
            // https://github.com/martinvahi/mmmv_notes/tree/master/mmmv_notes/phenomenon_scrutinization/string_concatenation
            $s_out = s_concat_array_of_strings($arht_s_out);
            echo($s_out);
        } catch (Exception $err_exception) {
            throw new Exception('' . $err_exception . "\n" .
                'GUID="d5c06033-e5ca-4daa-8114-1230405061e7"');
        } // catch
    } // the_main_program

    the_main_program();

    /*
    //------------
    //echo($s_json);
    //$s_fp_bash_tmp='not_yet_set';
    // http://php.net/manual/en/function.json-decode.php
    //$arht=
*/
    ?>
    </span>
</p>
</body>
</html>
