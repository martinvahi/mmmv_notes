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
// The XSS stands for Cross Site Scripting. Another keyphrase
// is code injection.
//------------------------------------------------------------------------

// The ideology of this interface is that any malicious
// script should be presentable as text in an unmodified
// manner. This entails that the filtering depends on the
// software that is used for displaying or processing the text.
// (For a different approach, please see: http://htmlpurifier.org .
//  As of 07.2009 some XSS examples might be found
//  from http://ha.ckers.org/xss.html )
//
// If the script is stored, let's say, into a database,
// in some unfiltered or reversible manner, then it is
// possible to filter it according to the software that will receive/display
// the script. In the case of the SQL injection one should try to
// use  parametrized data entry whenever possible.
class sirelCodeInjectionFilter{

    // Makes it safe to write the $text_to_filter into an HTML document.
    public static function html(&$text_to_filter){
        $answer=htmlentities($text_to_filter, ENT_QUOTES,'UTF-8');
        return $answer;
    } // html

    // TODO: this method needs to be tested
    public static function bash(&$text_to_filter){
        // The current version of the filter spoils a script like
        // echo ";"
        // but as this method is required to handle both, correct
        // bash syntax and incorrect bash syntax, the appropriate
        // analyzer is left to the TODO list.
        $s=mb_eregi_replace('"','\\"',mb_eregi_replace('`', '\\`', $text_to_filter));
        $answer=mb_eregi_replace(';', '', mb_eregi_replace('$', '\\$', $s));
        return $answer;
    } // bash

    // This method is for cases, where it is not possible to use parametrized
    // SQL queries. It's not perfect, but it's better than nothing.
    public static function SQL(&$text_to_filter){
        $answer=mb_eregi_replace(';', '', $text_to_filter);
        return $answer;
    } // SQL

} // class sirelCodeInjectionFilter

?>
