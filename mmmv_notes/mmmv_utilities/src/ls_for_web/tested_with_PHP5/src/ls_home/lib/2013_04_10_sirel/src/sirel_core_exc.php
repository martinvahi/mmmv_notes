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
//------------------------------------------------------------------------


function sirelServerSideErrorPageDisplayingPassphraseAtTheClientSide(){
    return '
        <!-- This keyword here, the
        OPEN_<theTITLEof_I_heaT_up_I_can\'t_cool_down_You_got_me_spinnin_Round_and_Round>
        notifies the JavaScript that in stead of displaying its own error message
        it should display this HTML page-->';
} // sirelServerSideErrorPageDisplayingPassphraseAtTheClientSide

// The essence of the existence of the class sirelResourceException
// is visible at the function sirelDisplayException(...).
class sirelResourceException extends Exception{
} // class sirelResourceException
class sirelIOException extends Exception{
} // class sirelIOException


// It is meant to be called like that:
// sirelThrowResourceException(__FILE__,__LINE__,'greetings!');
function sirelThrowResourceException($file,$line,$message){
    throw new sirelResourceException( "".
        "\n<p>-------------------------------\n".
        'File '.$file."\n line: ".$line." Message:\n".$message);
} // sirelThrowResourceException

// It is meant to be called like that:
// sirelThrowLogicException(__FILE__,__LINE__,'greetings!');
function sirelThrowLogicException($file,$line,$message){
    throw new Exception( "\n<p>-------------------------------\n".
        'File '.$file."\n line: ".$line." Message:\n".$message);
} // sirelThrowLogicException

function sirelThrowIOException($file,$line,$message){
    throw new sirelIOException( "".
        "\n<p>-------------------------------\n".
        'File '.$file."\n line: ".$line." Message:\n".$message);
} // sirelThrowIOException


// The sirelBubble(...) is meant to be used in the
// following context:
//
// require_once("$sirel_path/sirel_core.php");
// try{
//   CODE THAT USES THE sirelBubble(...)
// } catch (Exception $err_exception) {
//     sirelBubble(__FILE__,__LINE__,$err_exception);
// } // catch
function sirelBubble($file_path,$line,$exception,$message=''){
    $msg="\n<p>-------------------------------\n".
    'File: '.$file_path."\nline: ".$line.' '.
        'Message: '.$message."\n".
    $exception->getMessage()."\n</p>";
    $err_exception_type=get_class($exception);
    switch ($err_exception_type) {
        case 'sirelResourceException':
            throw new sirelResourceException($msg);
            break;
        case 'sirelIOException':
            throw new sirelIOException($msg);
            break;
        default: // logic_error
            throw new Exception($msg);
            break;
    } // switch

} // sirelBubble(...)

// The sirelDisplayException is meant to display the
// stack of exception messages that was gathered by
// using the sirelBubble. It is meant to be used in
// the following context:
//
// require_once("$sirel_path/sirel_core.php");
// try{
//   CODE THAT USES THE sirelBubble(...).
// } catch (Exception $err_exception) {
//     sirelDisplayException(__FILE__,__LINE__,$err_exception);
// }
function sirelDisplayException($file_path,$line,$exception,$message=''){
    $msg="\n<p>---------------Bubble-Display--Start-------------\n".
    $message;
    if($message!=''){
        $msg=$msg."\n";
    } // if
    $err_exception_type=get_class($exception);
    $msg=$msg.'Exception type: '.$err_exception_type."\n".
    $exception->getMessage()."\n".
        "---------------Bubble-Display--End----------------\n";
    $logstack='default';
    if(sirelSiteConfig::$debug_PHP){
        $logstack='debug';
    } // if
    // The sirelLogger::log(plapla) are here with the |||
    // to avoid log flooding, no matter how many threads
    // stumble upon the same errorous condition. The side effect
    // is that if there are multiple different errors that trigger an
    // exception, then only one of them will be logged, but that's OK,
    // because absolutely all of them have to be fixed anyway and
    // after the logged one gets fixed, the rest have their turn to be logged.
    // If the number of errors is so huge that the current strategy becomes
    // unfeasible, then the software is crap anyway.
    switch ($err_exception_type) {
        case 'sirelResourceException':
            sirelLogger::log($file_path,$line,
                'Function sirelDisplayException(...)->'.
                'sirelResourceException |||'.$msg, $logstack);
            require_once('sirel_resource_error.html');
            break;
        case 'sirelIOException':
            sirelLogger::log($file_path,$line,
                'Function sirelDisplayException(...)->'.
                'sirelIOException |||'.$msg, $logstack);
            require_once('sirel_io_error.html');
            break;
        default: // logic_error
            sirelLogger::log($file_path,$line,
                'Function sirelDisplayException(...)->'.
                'logic_error |||'.$msg, $logstack);
            require_once('sirel_logic_error.html');
            break;
    } // switch
} // sirelDisplayException

?>
