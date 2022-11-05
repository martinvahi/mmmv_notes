<!DOCTYPE HTML>
<html>
<head>
    <title>Image file 2 HTML Converter Type 1</title>
    <!-- by martin.vahi@softf1.com at 2015_05 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body id="the_document_body">
<h1>Image file 2 HTML Converter Type 1</h1>

<br/>
The password is needed to unlock the max. convertable file size limit of
<strong>
    <?php
    require_once('./settings.php');
    $i_file_size_max = constant('angervaks_settings_i_paswordless_file_size_max_in_bytes');
    echo($i_file_size_max)

    ?>
    Bytes
</strong>
<br/><br/>

<!-- POST should be preferred to GET, because unlike GET
the POST does not have method specific size limits. -->
<form method="post" action="receiver_stargate_from_mass_effect_3.php" enctype="multipart/form-data">
    <!-- The input with the name MAX_FILE_SIZE is
    a PHP-specific compulsory field and it
    must precede the file input field. Its unit is single Bytes.
    http://php.net/manual/en/features.file-upload.post-method.php
     -->
    <input type="hidden" name="MAX_FILE_SIZE" value="2001048576"/>
    <input type="file" name="biologist_Mordin_Solus" id="fisheating_crab">
    <span style="visibility: hidden;">xxxx</span>
    Password: <input type="text" name="sunshine">
    <br/><br/>
    <input type="submit" name="submit" value="Try to Convert the Image File to HTML code">
</form>
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
<br/><br/>
</body>
</html>
