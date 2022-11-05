<?php
// ------------------------------------------------------------------------
// Copyright (c) 2011, martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// All rights reserved.

// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:

// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
// * Neither the name of the Martin Vahi nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.

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
// ------------------------------------------------------------------------

class sirel_unix_time_18n_estonian {

	public $arht_month_names_;
	public $arht_day_names_;
	public $arht_season_names_;

	private function init_month_names() {
		$this->arht_month_names_=array();
		$this->arht_month_names_['1']='jaanuar';    // January
		$this->arht_month_names_['2']='veebruar';   // February
		$this->arht_month_names_['3']='märts';
		$this->arht_month_names_['4']='aprill';
		$this->arht_month_names_['5']='mai';
		$this->arht_month_names_['6']='juuni';
		$this->arht_month_names_['7']='juuli';
		$this->arht_month_names_['8']='august';
		$this->arht_month_names_['9']='september';
		$this->arht_month_names_['10']='oktoober';
		$this->arht_month_names_['11']='november';
		$this->arht_month_names_['12']='detsember'; // December
	} // init_month_names

	private function init_day_names() {
		$this->arht_day_names_=array();
		$this->arht_day_names_['1']='esmaspäev'; // Monday
		$this->arht_day_names_['2']='teisipäev'; // Tuesday
		$this->arht_day_names_['3']='kolmapäev'; // Wednestay
		$this->arht_day_names_['4']='neljapäev'; // Thursday
		$this->arht_day_names_['5']='reede';     // Friday
		$this->arht_day_names_['6']='laupäev';   // Saturday
		$this->arht_day_names_['7']='pühapäev';  // Sunday
	} // init_day_names

	private function init_season_names() {
		$this->arht_season_names_=array();
		$this->arht_season_names_['1']='kevad';  // spring
		$this->arht_season_names_['2']='suvi';   // summer
		$this->arht_season_names_['3']='sügis';  // autumn
		$this->arht_season_names_['4']='talv';   // winter
	} // init_season_names

	public function __construct() {
		$this->init_month_names();
		$this->init_day_names();
		$this->init_season_names();
	} // constructor

} // sirel_unix_time_18n_estonian


// ---------------------------------------------------------

?>
