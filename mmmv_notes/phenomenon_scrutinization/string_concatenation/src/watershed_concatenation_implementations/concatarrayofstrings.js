
//=========================================================================
//
// The MIT license from the 
// http://www.opensource.org/licenses/mit-license.php
//
// Copyright (c) 2013, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
//
// Permission is hereby granted, free of charge, to 
// any person obtaining a copy of this software and 
// associated documentation files (the "Software"), 
// to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish, 
// distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//-------------------------------------------------------------------------
//
// This file depends only on JavaScript standard library, which makes
// it easy to include it to other projects.
//
//=========================================================================

s_concat_array_of_strings_watershed = function(ar_in) {
	var s_lc_emptystring = "";
	var s_out = s_lc_emptystring; // needs to be inited to the ""
	var i_n = ar_in.length;
	if (i_n < 3) {
		if (i_n == 2) {
			s_out = ar_in[0] + ar_in[1];
			return s_out;
		} else {
			if (i_n == 1) {
				// For the sake of consistency one
				// wants to make sure that the returned
				// string instance always differs from those
				// that are within the ar_in.
				s_out = s_lc_emptystring + ar_in[0];
				return s_out;
			} else { // i_n==0
				s_out = s_lc_emptystring;
				return s_out;
			} // if
		} // if
	} // if

	// In its essence the rest of the code here implements
	// a tail-recursive version of this function. The idea is that
	//
	// s_out='something_very_long'.'short_string_1'.short_string_2'
	// uses a temporary string of length
	// 'something_very_long'.'short_string_1'
	// but
	// s_out='something_very_long'.('short_string_1'.short_string_2')
	// uses a much more CPU-cache fri}ly temporary string of length
	// 'short_string_1'.short_string_2'
	//
	// Believe it or not, but as of January 2012 the speed difference
	// in PHP can be at least about 20% and in Ruby about 50%.
	// Please do not take my word on it. Try it out yourself by
	// modifying this function and assembling strings of length
	// 10000 from single characters.
	//
	// This here is probably not the most optimal solution, because
	// within the more optimal solution the the order of
	// "concatenation glue placements" dep}s on the lengths
	// of the tokens/strings, but as the analysis and "gluing queue"
	// assembly also has a computational cost, the version
	// here is almost always more optimal than the totally
	// naive version.
	var ar_1 = ar_in;

        // http://longterm.softf1.com/specifications/array_indexing_by_separators/index.html
	var b_take_from_ar_1 = true;
	var b_not_ready = true;
	var s_1 = null;
	var s_2 = null;
	var s_3 = null;
	var i_0 = null;
	var i = null;
	//------loop---init-----
	var i_ar_in_len = ar_1.length;
	var i_reminder = i_ar_in_len % 2;
	var i_loop = (i_ar_in_len - i_reminder) / 2;
	var ar_2 = new Array(i_loop + i_reminder);
	while (b_not_ready === true) {
		// The next if-statement is to avoid copying temporary
		// strings between the ar_1 and the ar_2.
		if (b_take_from_ar_1) {
			for (i = 0; i < i_loop; i++) {
				i_0 = i * 2;
				s_1 = ar_1[i_0];
				s_2 = ar_1[i_0 + 1];
				s_3 = s_1 + s_2;
				ar_2[i] = s_3;
			} // loop
			if (i_reminder === 1) {
				s_3 = ar_1[i_ar_in_len - 1];
				ar_2[i_loop] = s_3;
			} // if
			i_ar_in_len = ar_2.length;
			if (1 < i_ar_in_len) {
				i_reminder = i_ar_in_len % 2;
				i_loop = (i_ar_in_len - i_reminder) / 2;
				i = i_loop + i_reminder;
				// It's OK to allocate the arrays, because 
				// for 2^32 concatable strings there will 
				// be 32 array instantiations and the 
				// benefit is that the garbabe collector 
				// has a chance to destroy considerable amount
				// of temporary strings from the memory.
				ar_1 = new Array(i);
			} else {
				b_not_ready = false;
			} // else
		} else { // b_take_from_ar_1==false
			for (i = 0; i < i_loop; i++) {
				i_0 = i * 2;
				s_1 = ar_2[i_0];
				s_2 = ar_2[i_0 + 1];
				s_3 = s_1 + s_2;
				ar_1[i] = s_3;
			} // loop
			if (i_reminder === 1) {
				s_3 = ar_2[i_ar_in_len - 1];
				ar_1[i_loop] = s_3;
			} // if
			i_ar_in_len = ar_1.length;
			if (1 < i_ar_in_len) {
				i_reminder = i_ar_in_len % 2;
				i_loop = (i_ar_in_len - i_reminder) / 2;
				i = i_loop + i_reminder;
				ar_2 = new Array(i);
			} else {
				b_not_ready = false;
			} // else
		} // else
		b_take_from_ar_1 = !b_take_from_ar_1;
	} // while
	if (i_ar_in_len === 1) {
		if (b_take_from_ar_1) {
			s_out = ar_1[0];
		} else {
			s_out = ar_2[0];
		} // if
	} else {
		if (0 < i_ar_in_len) {
			throw(new Exception("This function is flawed.\n" +
				"GUID='50d43c5c-457f-45f9-9232-12b1d0204dd7'"));
		} else {
			throw(new Exception("This function is flawed. \n" +
				"i_ar_in_len == 0 \n" +
				"GUID='1dfec341-ac33-41b5-8232-12b1d0204dd7'"));
		} // else
	} // if
	// The s_out has been inited to "".
	return s_out;
} // s_concat_array_of_strings_watershed 


