#!/usr/bin/env ruby
# See kood on rahvapärand ("public domain").
# SPDX-License-Identifier: 0BSD
# Esmaautor, kes 2026_04_10 selle epostikommentaariks kirjutas: Martin.Vahi@softf1.com
#
# Kontekst: Unicode teksti ASCII-tähemärkide jadaks ja tagasi konverteerides
# saab vanu teksti-otsimootoreid, teksti-otsi-tarkvara, muutmata kujul kasutada
# ka siis kui Unicode standardisse tähemärke juurde lisatakse. See võimaldab
# vana ASCII-teksti-otsimootorit jooksutavaid virtuaalseadmeid aastaid muutmata
# kujul kasutada. Modernsete pilveteenuste korral kasutades saab vähemalt
# osaliselt ära jätta majutusfirma serveris oleva veebitarkvara uuenduse iga
# kord kui Unicode'i toetus-teeki seoses Unicode tähemärkide standardisse
# lisandumisega uuendatakse.
#
# Tänan lugemast :-)
#==========================================================================

def s_konverteerin_ühe_sõna_asciijadaks(s_konverteeritav_sõna)
   ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv=s_konverteeritav_sõna.codepoints

   puts("\n"+ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv.to_s)
   # Ruby standardteegi jaapanlastest
   # autorid eesti keele roppusi ei tundnud.
   # puts -> "put string"

   s_unicode_tähemärgid_ascii_tähemärkide_jadaks_konverteeritult=""
   i_Unicode_tähemärkide_arv_sõnas=ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv.size
   i_Unicode_tähemärkide_arv_sõnas.times do |ix_massiivi_indeks| # 0..(i_Unicode_tähemärkide_arv_sõnas-1)
      # "toretäisarv.each" on lühem viis Rubys selliseid tsükleid
      # kirjutada, aga see ".each" ju oma semantikas ei ütle midagi
      # elementide järjekorra kohta, lubatud on vaid, et kõik elemendid
      # käiakse läbi, mistõttu ma kirjutan alati nürimalt ja pikemalt
      # ise indeksite kasutamisega koodi. Ei mingit mitmeti mõistmist!
      # See kood siin on muidugi lõdvalt näitena ekirja osana kirjutatud.
      # Päriselt kasutatavas tarkvaras teen kontrollide ja kiirushäkkide
      # tõttu veel koodimahukamalt.
      i_unicode_tähemärgi_kood=ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv[ix_massiivi_indeks]
      s_unicode_tähemärgi_kood=i_unicode_tähemärgi_kood.to_s # 10-nendsüsteemis
      #s_unicode_tähemärgi_kood=i_unicode_tähemärgi_kood.to_s(16) # 16-nendsüsteemis
      #s_unicode_tähemärgi_kood=i_unicode_tähemärgi_kood.to_s(26) # 26-nendsüsteemis
      s_unicode_tähemärk_asciiks_konverteeritult="a"+s_unicode_tähemärgi_kood
      s_unicode_tähemärgid_ascii_tähemärkide_jadaks_konverteeritult<<s_unicode_tähemärk_asciiks_konverteeritult
   end # loop
   return s_unicode_tähemärgid_ascii_tähemärkide_jadaks_konverteeritult
end # s_konverteerin_ühe_sõna_asciijadaks


def s_konverteerin_asciijada_tagasi_unicode_tähemärkide_jadaks(s_asciijada)
   # Kuna see siin on idee-selgitus-kood, siis ei mingeid kontrolle,
   # adekvaatseid veateateid ega muud sarnast, mis päriselt kasutuses olevas
   # tarkvaras elementaarne on. Eeldus on, et s_asciijada on korrektne sõne, jne.
   ar_tähemärgid_asciina=s_asciijada.scan(/[a][0123456789]+/)
   #puts(ar_tähemärgid_asciina.to_s) # George Michael'i videos "Too Funky" on ühe modelli ekraaninimeks ka Tyra.

   ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv=Array.new
   i_len=ar_tähemärgid_asciina.size
   i_len.times do |ix|
      s_ascii=ar_tähemärgid_asciina[ix]
      si_unicode=s_ascii[1..(-1)]  # "a42" -> "42"
      i_unicode=si_unicode.to_i
      #i_unicode=s_unicode.to_i(16)
      #i_unicode=s_unicode.to_i(26)
      ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv.push(i_unicode)
   end # loop
   s_unicode_sõna=ar_ühe_sõna_unicde_tähemärkide_koodide_massiiv.pack("U*")
   return s_unicode_sõna
end # s_konverteerin_asciijada_tagasi_unicode_tähemärkide_jadaks

s_sõna="tere"
s_sõna_asciijadaks_konverteeritult=s_konverteerin_ühe_sõna_asciijadaks(s_sõna)
puts("\nSõna \""+s_sõna+
"\"\n           on konverteeritult: \""+s_sõna_asciijadaks_konverteeritult+"\"\n")
s_tagasikonverteeritu=s_konverteerin_asciijada_tagasi_unicode_tähemärkide_jadaks(
s_sõna_asciijadaks_konverteeritult)
puts("ja see tagasi konverteeritult: \""+s_tagasikonverteeritu+"\"\n\n")

#
# Tänan lugemast ja proovimast :-)
#
#==========================================================================
# S_VERSION_OF_THIS_FILE="9bc4be1d-3211-442c-a1d9-431130b04ae7"
#==========================================================================
