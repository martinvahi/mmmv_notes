<?php
//=========================================================================
// Initial author of this script: Martin.Vahi@softf1.com
// This script is in public domain.
//
// The following line is a spdx.org license label line:
// SPDX-License-Identifier: 0BSD
//=========================================================================
$s = exec('pwd');
$s_plaintext = 'The working directory:' . "\n" . $s . "\n\n";
//-------------------------------------------------------------------------
$s_0 = shell_exec('ls');
$ar_0 = explode("\n", $s_0);
$i_len = count($ar_0);
$x_elem = NULL;
for ($i = 0; $i < $i_len; $i++) {
    $x_elem = $ar_0[$i];
    $s_0 = '<a href="./' . $x_elem . '">./' . $x_elem . "</a>\n";
    $s_plaintext = $s_plaintext . $s_0;
} // for
//-------------------------------------------------------------------------
$x_elem = '../';
$s_0 = '<a href="./' . $x_elem . '">./' . $x_elem . "</a>\n";
$s_plaintext = $s_plaintext . $s_0;
//-------------------------------------------------------------------------
$s_out = mb_ereg_replace("\n", "<br/>\n", $s_plaintext, "g");
echo('' . $s_out);

//=========================================================================
