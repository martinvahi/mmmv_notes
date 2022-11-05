<!DOCTYPE HTML>
<html>
<head>
    <title>File Uploading Hello World: File Receiver</title>
    <!-- by martin.vahi@softf1.com at 2015_05 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="the_document_body">
<h1>Conversion Script Output</h1>
<br/>

<?php
mb_internal_encoding('UTF-8');
mb_regex_encoding('UTF-8');
mb_http_output('UTF-8');
mb_http_input('UTF-8');
mb_language('uni');

require_once('./settings.php');

function mb_trim(&$str, $spc = '\t\s')
{
    return mb_ereg_replace("[$spc]*$", '',
        mb_ereg_replace("^[$spc]*", '', $str));
} // mb_trim

function s_reverse_string($s_in)
{
    $i_str_len = mb_strlen($s_in);
    $s_out = NULL;
    if ($i_str_len == 0) {
        $s_out = '';
        return $s_out;
    } // if
    $s_char = NULL;
    if ($i_str_len < 32) {
        // A speed hack that is based on the
        // fact that all initial strings that
        // will be concatenated  have the length
        // of a single character, i.e. 1
        $s_out = '';
        for ($i = $i_str_len - 1;
             0 <= $i;
             $i--) {
            $s_char = mb_substr($s_in, $i, 1);
            $s_out = $s_out . $s_char;
        } // for
    } else {
        // According to
        // http://stackoverflow.com/questions/2556289/php-split-multibyte-string-word-into-separate-characters
        // it seems that there is no way to
        // split the string to characters in
        // some more efficient way.
        $arht_s = array();
        for ($i = $i_str_len - 1;
             0 <= $i;
             $i--) {
            $s_char = mb_substr($s_in, $i, 1);
            array_push($arht_s, $s_char);
        } // for
        $s_out = s_concat_array_of_strings($arht_s);
    } // else
    return $s_out;
} // s_reverse_string

//-------------------------------------------------------------------------

function bisectStr(&$s_haystack, &$s_needle)
{
    // A trick here is that if $s_haystack=='',
    // ($s_haystack==NULL)==True, i.e. an empty string is
    // equivalent to NULL from PHP == operator point of view.
    if (is_null($s_haystack)) {
        return NULL;
    } // if
    $ar_out = array();
    $ar_out[] = $s_haystack;
    $xx = mb_strpos($s_haystack, $s_needle);
    if (is_bool($xx)) {
        return $ar_out;
    } // if
    $s_first = mb_substr($s_haystack, 0, $xx);
    $s_last = mb_substr($s_haystack, $xx + mb_strlen($s_needle));
    $ar_out[1] =& $s_first;
    $ar_out[2] =& $s_last;
    return $ar_out;
} // bisectStr


// s_get_tail('','abcd') -> ''
// s_get_tail('XB','') -> ''
// s_get_tail('Y','abcd') -> 'abcd'
// s_get_tail('XB','abcdXBefg') -> 'efg'
// s_get_tail('XB','abcdXB') -> ''
// s_get_tail('XB','aXBbcdXB') -> ''
// s_get_tail('XB','XBabcd') -> 'abcd'
// s_get_tail('XB','Xabcd') -> 'Xabcd'
// s_get_tail('XB','XB') -> ''
function s_get_tail($s_separator, $s_whole)
{
    $s_out = NULL;
    $i_len_separator = mb_strlen($s_separator);
    if ($i_len_separator == 0) {
        $s_out = '';
        return $s_out;
    } // if
    $i_len_whole = mb_strlen($s_whole);
    if ($i_len_whole == 0) {
        $s_out = '';
        return $s_out;
    } // if
    $s_whole_rev = s_reverse_string($s_whole);
    $s_separ_rev = s_reverse_string($s_separator);
    $arht_triple = bisectStr($s_whole_rev,
        $s_separ_rev);
    if (count($arht_triple) < 3) { // $s_separator not part of the $s_whole
        $s_out = $s_whole;
        return $s_out;
    } // if
    $s_0 = $arht_triple[1];
    $s_out = s_reverse_string($s_0);
    return $s_out;
} // s_get_tail


function s_mime_type($s_fp)
{
    $s_fp_0 = realpath($s_fp);
    $s_0 = shell_exec('file --mime-type ' . $s_fp_0);
    // Sample output of the shell_exec(blabla):
    //
    //     ./Tutorial_Logic.pdf: application/pdf
    //
    // File names might contain colons, but
    // mime types do not contain colons.
    $s_separator = ':';
    $s_1 = s_get_tail($s_separator, $s_0);
    $s_out = mb_trim($s_1);
    return $s_out;
} // s_mime_type


function s_concat_array_of_strings(&$ar_strings)
{
    $i_n = count($ar_strings);
    if ($i_n < 3) {
        if ($i_n == 2) {
            $s_out = $ar_strings[0] . $ar_strings[1];
            return $s_out;
        } else {
            if ($i_n == 1) {
                // For the sake of consistency one
                // wants to make sure that the returned
                // string instance always differs from those
                // that are within the $ar_strings.
                $s_out = '' . $ar_strings[0];
                return $s_out;
            } else { // $i_n==0
                $s_out = '';
                return $s_out;
            } // else
        } // else
    } // if
    $s_out = ''; // needs to be inited to the ''

    //if(False) {
    //// The classic part for testing and playing.
    //$i_len=count($ar_strings);
    //for($i=0;$i<$i_len;$i++) {
    //$s_out=$s_out.$ar_strings[$i];
    //} // for
    //return $s_out;
    //} // if

    // In its essence the rest of the code here implements
    // a tail-recursive version of this function. The idea is that
    //
    // s_out='something_very_long'.'short_string_1'.short_string_2';
    // uses a temporary string of length
    // 'something_very_long'.'short_string_1'
    // but
    // s_out='something_very_long'.('short_string_1'.short_string_2');
    // uses a much more CPU-cache friendly temporary string of length
    // 'short_string_1'.short_string_2';
    //
    // This here is probably not the most optimal solution, because
    // within the more optimal solution the order of
    // "concatenation glue placements" depends on the lengths
    // of the tokens/strings, but as analysis and "gluing queue"
    // assembly also has a computational cost, the version
    // here is almost always more optimal than the totally
    // naive version/
    $arht_1 =& $ar_strings;
    $arht_2 = array();
    $b_take_from_arht_1 = True;
    $b_not_ready = True;
    $i_reminder = NULL;
    $i_loop = NULL;
    $i_arht_in_len = NULL;
    $i_arht_out_len = 0; // code after the while loop needs a number
    $s_1 = NULL;
    $s_2 = NULL;
    $s_3 = NULL;
    $i_2 = NULL;
    while ($b_not_ready) {
        // The next if-statement is to avoid copying temporary
        // strings between the $arht_1 and the $arht_2.
        if ($b_take_from_arht_1) {
            $i_arht_in_len = count($arht_1);
            $i_reminder = $i_arht_in_len % 2;
            $i_loop = ($i_arht_in_len - $i_reminder) / 2;
            for ($i = 0; $i < $i_loop; $i++) {
                $i_2 = $i * 2;
                $s_1 = $arht_1[$i_2];
                $s_2 = $arht_1[$i_2 + 1];
                $s_3 = $s_1 . $s_2;
                $arht_2[] = $s_3;
            } // for
            if ($i_reminder == 1) {
                $s_3 = $arht_1[$i_arht_in_len - 1];
                $arht_2[] = $s_3;
            } // if
            $i_arht_out_len = count($arht_2);
            if (1 < $i_arht_out_len) {
                $arht_1 = array();
            } else {
                $b_not_ready = False;
            } // else
        } else { // $b_take_from_arht_1==False
            $i_arht_in_len = count($arht_2);
            $i_reminder = $i_arht_in_len % 2;
            $i_loop = ($i_arht_in_len - $i_reminder) / 2;
            for ($i = 0; $i < $i_loop; $i++) {
                $i_2 = $i * 2;
                $s_1 = $arht_2[$i_2];
                $s_2 = $arht_2[$i_2 + 1];
                $s_3 = $s_1 . $s_2;
                $arht_1[] = $s_3;
            } // for
            if ($i_reminder == 1) {
                $s_3 = $arht_2[$i_arht_in_len - 1];
                $arht_1[] = $s_3;
            } // if
            $i_arht_out_len = count($arht_1);
            if (1 < $i_arht_out_len) {
                $arht_2 = array();
            } else {
                $b_not_ready = False;
            } // else
        } // else
        $b_take_from_arht_1 = !$b_take_from_arht_1;
    } // while
    if ($i_arht_out_len == 1) {
        if ($b_take_from_arht_1) {
            $s_out = $arht_1[0];
        } else {
            $s_out = $arht_2[0];
        } // else
    } else {
        // The $s_out has been inited to ''.
        if (0 < $i_arht_out_len) {
            throw(new Exception('This function is flawed.'));
        } // else
    } // else
    return $s_out;
} // s_concat_array_of_strings

// Returns HTML-string, where the image has been embedded
// to the img tag parameters.
function s_img_fp_2_armoured_img_tag($s_fp)
{
    if (file_exists($s_fp) !== true) {
        echo("\nCrash. GUID='801796c1-2a4e-4a7a-b4f4-c240b0516fd7'");
        throw(new Exception("File with the path of \n" . $s_fp .
            "\ndoes not exist." .
            "\nGUID='2609dd30-8448-4116-93f4-c240b0516fd7'"));
    } // if
    $arht_s_out = array();
    array_push($arht_s_out, '<img src="data:');
    $s_mimetype = s_mime_type($s_fp);
    //-------------------------------------
    // The $s_mimetype must contain the phrase "image".
    // If not, then some unsupported file was uploaded.
    $s_0 = s_reverse_string($s_mimetype); // 'image/jpeg' -> 'gepj/egami'
    $s_separator = '/';
    $s_1 = s_get_tail($s_separator, $s_0);
    if ($s_1 != 'egami') {
        return '';
    } // if
    //-------------------------------------
    array_push($arht_s_out, $s_mimetype);
    array_push($arht_s_out, ';base64,');
    $x = file_get_contents($s_fp);
    $s_data = base64_encode($x);
    array_push($arht_s_out, $s_data);
    array_push($arht_s_out, '" />');
    $s_html = s_concat_array_of_strings($arht_s_out);
    return $s_html;
} // s_img_fp_2_armoured_img_tag

function s_fp_attempt_to_save_uploaded_file()
{
    $s_passwd_acceptable = constant('angervaks_settings_password');
    $s_password_in = $_POST['sunshine'];
    $s_fp_destination = '';
    if (isset($_POST['submit'])) {
        $i_file_size_max = constant('angervaks_settings_i_paswordless_file_size_max_in_bytes');
        $b_password_is_correct = false;
        if ($s_password_in === $s_passwd_acceptable) {
            echo('The password is correct.<br/><br/>');
            $b_password_is_correct = true;
        } // else
        //-----------------
        //$arht_fileField = $_FILES['fileField'];
        $arht_fileField = $_FILES['biologist_Mordin_Solus'];
        $ar_keys = array_keys($arht_fileField);
        $x_value = null;
        $i_file_size = 999999999;
        echo('File field data:<br/>' . "\n");
        $s_html_spacer = '<span style="visibility:hidden;">xxxx</span>';
        foreach ($ar_keys as $x_key) {
            $x_value = $arht_fileField[$x_key];
            echo('<br/>' . $s_html_spacer . $x_key . ' == ' . $x_value);
            if ($x_key == 'size') {
                echo(' Bytes');
                $i_file_size = intval($x_value);
            } // if
            echo("\n"); // Here in stead of elsewhere to allow the 'Bytes' echoing.
        } // foreach
        echo('<br/>');
        //-----------------
        if ($b_password_is_correct === false) {
            if ($i_file_size_max < $i_file_size) {
                echo('<span style="color:red;"><br/>Wrong password. <br/><br/>' . "\n" .
                    'Maximum password-free file size (==<strong>' .
                    $i_file_size_max . 'B</strong>)<br/> is smaller than the ' .
                    'size of the uploaded file (==<strong>' . $i_file_size . 'B</strong>).' .
                    '<br/><br/></span>');
                return;
            } // if
        } // if
        //-----------------
        $s_fp_dir_uploaded = realpath('.') . '/uploaded_files';
        if (!file_exists($s_fp_dir_uploaded)) {
            mkdir($s_fp_dir_uploaded, 0777);
        } // if
        //-----------------
        $s_fp_uploaded = $arht_fileField['tmp_name'];
        $s_fp_destination = $s_fp_dir_uploaded . '/' . $arht_fileField['name'];
        move_uploaded_file($s_fp_uploaded, $s_fp_destination);
    } else {
        echo('The form data seems to be missing. <br/>' .
            "\n GUID='58ef4559-00eb-412c-91f4-c240b0516fd7'");
    }
    return $s_fp_destination; // == '' if file saving failed
} // s_fp_attempt_to_save_uploaded_file

function the_main()
{
    $s_fp_destination = s_fp_attempt_to_save_uploaded_file();
    if ($s_fp_destination == '') {
        return;
    } // if
    $s_generated = s_img_fp_2_armoured_img_tag($s_fp_destination);
    //---------------------
    echo('<br/><br/>');
    //---------------------
    if ($s_generated == '') {
        echo("\n<strong>\n" .
            '<span style="color:red;">' . "\n" .
            'Conversion failed, because file MIME type ' .
            'of the uploaded file(==' .
            s_mime_type($s_fp_destination) .
            ')<br/>does not seem to be an image MIME type. ' .
            "\n</span>\n" .
            "\n</strong>\n");
        unlink($s_fp_destination);
        return;
    } // if
    $s_html = ("\n<br/><br/>\n" .
            "\n\n\n" .
            "<!-- The start of the Copy-Pastable region -->\n\n") .
        $s_generated . "\n\n<!-- The end of the Copy-Pastable region -->\n\n\n";
    unlink($s_fp_destination);
    echo("\n<strong>\n" .
        'The file conversion result resides at the source of this HTML page.' .
        "\n</strong>\n" .
        $s_html);
    //---------------------
    echo("\n" . '<br/><br/>');
} // the_main

sleep(1); // to force password guessing to multiple processes.
the_main();
//phpinfo();

?>
<br/><br/><br/><br/>

</body>
</html>
