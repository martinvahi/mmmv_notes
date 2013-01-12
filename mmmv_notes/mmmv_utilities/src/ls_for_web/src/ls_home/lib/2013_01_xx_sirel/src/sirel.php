<?php
//=========================================================================
// Copyright (c) 2009, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
// * Neither the name of the Martin Vahi nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
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
//=========================================================================
// This file is meant to be included only by PHP files that
// are not part of the sirel library. It's a wrapper to all of
// the sirel library files. It's useful for initial development,
// but afterwards it makes sense to include only tghose sirel
// files that are actually used.
//-------------------------------------------------------------------------

// Identation forms a tree, which depicts file dependencies.
// As "requireing"(including) a leaf automatically "rquires"(includes)
// all of its parent nodes, the upper nodes are commented out for the sake
// of efficiency. Some files form multiple leaves.
//
//require_once('sirel_core.php');
/*    *///require_once('sirel_lang.php');
/*            *///require_once('sirel_type_normalizations.php');
/*                    *///require_once('sirel_ix.php');
/*                            *///require_once('sirel_operators.php');
/*                                    */require_once('sirel_operators_set_1.php');
/*                                    */require_once('sirel_bigint_t1.php');
/*                    */require_once('sirel_math_boolean.php');
/*            *///require_once('sirel_resource.php');
/*                    */require_once('sirel_javascript.php');
/*            */require_once('sirel_security_arch_1.php');
/*            */require_once('sirel_security_utilities.php');
/*            *///require_once('sirel_db.php');
/*                    *///require_once('sirel_dbcomm.php');
/*                            *///require_once('sirel_dbhashtable.php');
/*                                    */require_once('sirel_dbht.php');
/*                            *///require_once('bonnet/sirel_db_format_signature.php');
/*            */require_once('sirel_request_handling.php');
/*            *///require_once('sirel_internet_verifications.php');
/*                    */require_once('sirel_text_normalizations.php');
/*            *///require_once('sirel_fs.php');
/*                    */require_once('sirel_eval.php');
/*                    *///require_once('sirel_raudrohi_support.php');
/*            */require_once('sirel_units.php');
/*            */require_once('sirel_guid.php');
/*    *///require_once('sirel_html.php');
/*            *///require_once('sirel_javascript.php');
/*            */require_once('sirel_raudrohi_support.php');
/*    *///require_once('sirel_text_concatenation.php');
/*            */require_once('bonnet/sirel_db_format_signature.php');
/*    *///require_once('sirel_wml.php');

// TODO: Update it by sirel_dbcalc.php and alike. 
//       It needs a bit studying, which ones of those are worth including.
//       Some of the files might be merged, etc.
//

//=========================================================================
?>
