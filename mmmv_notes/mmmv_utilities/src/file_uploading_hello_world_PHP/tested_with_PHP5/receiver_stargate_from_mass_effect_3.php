<!DOCTYPE HTML>
<html>
<head>
    <title>File Uploading Hello World: File Receiver</title>
    <!-- by martin.vahi@softf1.com at 2015_05 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="the_document_body">
<h1>Output from the PHP</h1>
<br/>

<?php
mb_internal_encoding('UTF-8');
mb_regex_encoding('UTF-8');
mb_http_output('UTF-8');
mb_http_input('UTF-8');
mb_language('uni');

sleep(2); // to force password guessing to multiple processes.
function save_file()
{
    try {
        $s_passwd_acceptable = 'abc999'; // in real applications it should be a temporary hash
        $s_password_in = $_POST['sunshine'];
        if (isset($_POST['submit'])) {
            if ($s_password_in === $s_passwd_acceptable) {
                echo('Password is correct.<br/>');
                //-----------------
                //$arht_fileField = $_FILES['fileField'];
                $arht_fileField = $_FILES['biologist_Mordin_Solus'];
                $ar_keys = array_keys($arht_fileField);
                $x_value = null;
                foreach ($ar_keys as $x_key) {
                    $x_value = $arht_fileField[$x_key];
                    echo('<br/>($_FIELS[\'fileField\'])[' . $x_key . '] == ' . $x_value);
                } // foreach
                echo('<br/>');
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
                echo('Wrong password. <br/>' .
                    "\n GUID='f2a6f12c-e9ff-42ea-95aa-035011e05fd7'");
            } // else
        } else {
            echo('The form data seems to be missing. <br/>' .
                "\n GUID='f2a6f12c-e9ff-42ea-95aa-035011e05fd7'");
        }

    } catch (Exception $err_exception) {
        sirelBubble_t2($err_exception,
            "GUID='f2a6f12c-e9ff-42ea-95aa-035011e05fd7'");
    } // catch
} // save_file
save_file();
//echo('<br/>Some text.<br/>');
//phpinfo();

?>
<br/><br/>

<h1>Some References to some Sources of Inspiration</h1>
<ul>
    <li>
        <a href="http://masseffect.wikia.com/wiki/Mordin_Solus">Mordin Solus</a>
    </li>
    <li>
        <a href="https://www.youtube.com/watch?v=YZ2-xR54UDU">Sunshine</a>
    </li>
</ul>

</body>
</html>
