#!/usr/bin/env ruby
#==========================================================================
# Esmane autor: Martin.Vahi@softf1.com
# Litsens: rahvapärand ("public domain")
# Esmaversiooni kirjutamise kuupäev: 2020_04_13
#--------------------------------------------------------------------------

s_ekirjast_kopeeritud_tekstilõik=<<TEKSTIPIIRE
palun kopeerida siinse rea asemele ilma, et ekirja teksti ridu muudaks. Tänan.
TEKSTIPIIRE


# Idee on, et tegelikult igal tähemärgil
# on Unicode's ju oma kood ja kui välja mõelda,
# kuidas täisarvude jadasid kuidagi nii
# teksti "ära peita", et tekst kuidagi ilusti
# loetav on, siis võibki neid täisarvude jadasid
# teksti ära peita. Näiteks võib üks arv
# olla ühel real olev sõnade arv või tühikute arv.
# Antud näites üritan loomingulisem olla ja
# mis seal salata, mul tekkis kiusatus, et
# kas ma suudan näiteks 30min jooksul midagi
# kstra primitiivset eriti väikese koodiga
# lihtsalt näiteks, demoks, vaid Sulle kirja
# kirjutamise osana, kokku kirjutada.
class Primitiivse_steganograafia_demo_X1le

   attr_reader :s_program_version

   def initialize
      @s_program_version="1cc65943-ece4-4543-93d1-9340d0d044e7"
   end # initialize

   private

   # Harilikult ma nii labaselt, kontrollide
   # ja testide vabalt ei kirjuta. Näiteks siin ma ju
   # ei testi, et kas i_in on üldse positiivne täisarv.
   # Praktikas ma muidugi kirjutaks ka siia siis tüübitestid ja puha,
   # aga see kõik muudaks koodi pikemaks ja tüütumini loetavaks,
   # mistõttu ma siinses e-kiri-programmis teen nagu
   # akadeemikud, et kirjutan täielikku käkk-koodi, kus
   # reaalse eluga enam-vähem üldse ei arvestata.
   def ar_täisarv_kahendsüsteemi_numbriteks_littleendian(i_in)
      #--------------------------
      # irb(main):008:0> i_in=6
      # irb(main):009:0> i_in.to_s(2).scan(/[01]/)
      # => ["1", "1", "0"]
      # irb(main):010:0> i_in.to_s(2).scan(/[01]/)[0]
      # => "1"
      # irb(main):011:0> i_in.to_s(2).scan(/[01]/).reverse
      # => ["0", "1", "1"]
      #--------------------------
      ar_kahendsüsteemis_arvu_numbrid=i_in.to_s(2).scan(/[01]/)
      ar_kahendsüsteemis_arvu_numbrid.reverse!
      return ar_kahendsüsteemis_arvu_numbrid
   end # ar_täisarv_kahendsüsteemi_numbriteks_littleendian


   public

   # Viskab erindi, kui kuvatavat teksti on peidetava tkesti
   # peitmiseks liiga vähe. Testimiseks võid mingit
   # jura kuskilt ajaveebist või mõnest minu pikast
   # kirjast kuvatavaks tekstiks kasutada.
   #
   # Kodeerimine käib siin nii, et iga tekstirida kodeerib
   # ühe positiivse täisarvu ja 1. reale peidetud arv
   # kajastab järgnevate ridade arvu, kus arv ei ole pseudo-juhu-arv.
   # Peidetavad arvud teisendatakse peitmise käigus kahendsüsteemi.
   def exc_s_üritan_kodeerida(s_peidetav_tekst,s_kuvatav_tekst)
      #---------------------------
      ar_peidetav_base_10=s_peidetav_tekst.codepoints # Unicode koodide massiiv
      ar_of_ar=Array.new
      i_kahendsüsteemi_numbrite_koguarv=0
      ar_peidetav_base_10.length.times do |ix| # algab nullist
         ar=ar_täisarv_kahendsüsteemi_numbriteks_littleendian(ar_peidetav_base_10[ix])
         i_kahendsüsteemi_numbrite_koguarv=i_kahendsüsteemi_numbrite_koguarv+ar.length
         ar_of_ar.push(ar)
      end # loop
      #---------------------------
      # See kood siin on mu tava-stiilist ikka kohutavalt erinevalt kirjutatud,
      # aga vahelduseks on päris lahe nii lõdvalt, lohakalt, kirjutada :-D
      s_0=s_kuvatav_tekst.gsub(/[\s\n\t\r]+/," ")
      s_1=s_0.gsub(/^[\s]+/,"")
      s_0=s_1.gsub(/[\s]+$/,"")
      ar_s8nad=s_0.scan(/[^\s]+/)
      ix_s8nad=0 # massivi ar_s8nad indeksiloendur, tavalien täisarv
      s_steganograafiline_tekst="" # väljund, kui erindit ei visata
      #---------------------------
      func_0=lambda do |ar_tähemärk_base_2_formarg|
         s_kuvatav_rida=""
         ar_tähemärk_base_2_formarg.length.times do |ix_kahendsüsteemi_number| # albab nullist
            s_kahendsüsteemi_number=ar_tähemärk_base_2_formarg[ix_kahendsüsteemi_number]
            i_kahendsüsteemi_number=s_kahendsüsteemi_number.to_i(2) # sõnest täisarvuks
            if 0 < i_kahendsüsteemi_number # saab olla vaid kas 0 või 1
               s_kuvatav_rida=s_kuvatav_rida+"  " # kaks tühikut
            else
               s_kuvatav_rida=s_kuvatav_rida+" " # üks tühik
            end # if
            s_s8na=ar_s8nad[ix_s8nad]
            s_kuvatav_rida=s_kuvatav_rida+s_s8na
            ix_s8nad=ix_s8nad+1
         end # loop
         #----------------------
         s_steganograafiline_tekst=s_steganograafiline_tekst+s_kuvatav_rida+"\n"
      end # func_0
      #---------------------------
      if ar_of_ar.length != ar_peidetav_base_10.length
         # No ma ei pidanud vastu, pidin siia testi lisama,
         # mis ühtlasi on dokumentatsiooniks. Tavakoodis oleks see
         # ümbritsetud silumis-režiimi testiva if-lausega.
         raise(Exception.new("Kood on vigane.\n"+
         "GUID=='af12e822-9763-45cc-84d1-9340d0d044e7'\n\n"))
      end # if
      ar_0=ar_täisarv_kahendsüsteemi_numbriteks_littleendian(ar_peidetav_base_10.length)
      i_kahendsüsteemi_numbrite_koguarv=i_kahendsüsteemi_numbrite_koguarv+ar_0.length
      if ar_s8nad.length < i_kahendsüsteemi_numbrite_koguarv
         # Idee on nagu puude ehitamise algoritmil, kus
         # kõigepealt võetakse üks varreta pulgakomm ( O )ja siis
         # hakatakse magusatele pallidele ühendama varrega pulgakomme ( --O )
         # viisil, et pulgakommi varre pallita ots ühendub
         # mõne puus juba olemasoleva palliga. Erinevus on vaid selles,
         # et siinses steganograafiaprogrammis
         # jäetakse juurtipp, "varreta pulgakomm", alguses panemata.
         # Sõna on pulgakommi pall ("graafi tipp") ja varre pikkusega
         # määratakse, et kas salvestatav number on 1 või 0.
         #
         # Kõrvalmärkusena: kuna puid ehitatakse niivisi pulgakommidest,
         # siis on jube lihtne puu tippude arvu järgi puu servade arvu
         # teada saada: kõik pulgakommid on täpselt ühe
         # varrega, välja arvatud see päris 1., millel vars ("graafi serv") puudus.
         raise(Exception.new("\n\nKuvatavas tekstis on hetkel\n"+
         ar_s8nad.length.to_s+" sõna, aga vaja läheb minimaalselt \n"+
         i_kahendsüsteemi_numbrite_koguarv.to_s+" sõna.\n\n"))
         # Meenutuseks: arv koosneb numbritest ja
         # kahendsüsteemi arvul 111 on kolm numbrit.
         # Inglise keelne sõna "number" tõlge eesti keeles on "arv" ja
         # eesti keelse sõna "number" tõlge inglise keeles on "digit".
         # Sõna "digital" võib eesti keelde tõlkida ka kui "numbriline".
      end # if
      #---------------------------
      func_0.call(ar_0)
      ar_of_ar.length.times do |ix_ar_of_ar| # algab nullist
         ar_tähemärk_base_2=ar_of_ar[ix_ar_of_ar]
         func_0.call(ar_tähemärk_base_2)
      end # loop
      #---------------------------
      func_ar_rand_b2=lambda do
         # Koodi kompaktsuse nimel kohutavalt lohakalt mul siin kirjutatud.
         ix_ar_of_ar_max_plus_1=ar_of_ar.length
         ix=rand(ix_ar_of_ar_max_plus_1)
         ar_lambda_0=ar_of_ar[ix]
         return ar_lambda_0
      end # func_ar_rand_b2
      ix_s8nad_max=ar_s8nad.length-1
      func_i_veel_lisatavate_s8nade_arv=lambda do
         i_out=ix_s8nad_max-ix_s8nad+1
         return i_out
      end # func_i_veel_lisatavate_s8nade_arv
      ix_0=0
      while ix_s8nad <= ix_s8nad_max
         ar=func_ar_rand_b2.call
         i_s8nu_j2rgi=func_i_veel_lisatavate_s8nade_arv.call
         if ar.length <= i_s8nu_j2rgi
            func_0.call(ar)
            #next
         else
            s_kuvatav_rida=""
            i_s8nu_j2rgi.times do |ix|
               s_s8na=ar_s8nad[ix_s8nad]
               s_kuvatav_rida=s_kuvatav_rida+(" "*(rand(2)+1))+s_s8na
               ix_s8nad=ix_s8nad+1
            end # loop
            s_steganograafiline_tekst=s_steganograafiline_tekst+s_kuvatav_rida+"\n"
         end # if
      end # loop
      #---------------------------
      return s_steganograafiline_tekst
   end # exc_s_üritan_kodeerida

   # Kui sõnumit pole, tagastab tühja sõne.
   def s_dekodeerin(s_kuvatav_tekst)
      ar_read_0=s_kuvatav_tekst.scan(/[^\n\r]+/)
      ar_read_1=Array.new
      ar_read_0.length.times do |ix| # algab nullist
         s_rida=ar_read_0[ix].gsub(/[\s\t\n\r]+$/,"")
         ar_read_1.push(s_rida)
      end # loop
      #---------------------------
      ar_ridadesse_peidetud_täisarvud=Array.new
      ar_read_1.length.times do |ix| # algab nullist
         s_rida=ar_read_1[ix]
         #---------
         s_0=s_rida.gsub(/[\s\t]+/,"")
         next if s_0=="" # jätab tühja rea analüüsimata
         #---------
         ar_rea_pulgakommide_varred=s_rida.scan(/[\s]+/)
         ar_b2_numbrid=Array.new
         #---------
         ar_rea_pulgakommide_varred.length.times do |ix_1|
            s_vars=ar_rea_pulgakommide_varred[ix_1]
            i_number=nil
            if s_vars==" "
               i_number=0
            else
               if s_vars=="  "
                  i_number=1
               else
                  raise(Exception.new("Kood on vigane.\n"+
                  "GUID=='6734cd19-29f0-488e-a2c1-9340d0d044e7'\n"))
               end # if
            end # if
            ar_b2_numbrid.push(i_number)
         end # loop
         #---------
         s_b2_arv=""
         ar_b2_numbrid.reverse! # little-endian -> big-endian
         ar_b2_numbrid.length.times do |ix_1|
            s_b2_arv=s_b2_arv+ar_b2_numbrid[ix_1].to_s
         end # loop
         i_b2_arv=s_b2_arv.to_i(2)
         #---------
         ar_ridadesse_peidetud_täisarvud.push(i_b2_arv)
      end # loop
      #---------------------------
      i_peidetud_teksti_pikkus=ar_ridadesse_peidetud_täisarvud[0]
      ar_peidetud_teksti_unicode_koodid=Array.new
      i_peidetud_teksti_pikkus.times do |ix|
         ix_1=ix+1
         ar_peidetud_teksti_unicode_koodid.push(ar_ridadesse_peidetud_täisarvud[ix_1])
      end # loop
      #---------------------------
      s_peidetud_tekst=ar_peidetud_teksti_unicode_koodid.pack("U*")
      return s_peidetud_tekst
   end # s_dekodeerin


end # class Primitiivse_steganograafia_demo_X1le

#--------------------------------------------------------------------------

ob=Primitiivse_steganograafia_demo_X1le.new

#s_kuvatav_tekst=s_ekirjast_kopeeritud_tekstilõik
# s_kuvatav_tekst=<<TEKSTIPIIRE
# See tekst siin formaaditakse ümbr nii, et formaaditud
# tekst hakkab sisaldama "peidetud" sõnumit.
# TEKSTIPIIRE

#s_peidetav_tekst="Suur saladus"
#s_steganotekst=ob.exc_s_üritan_kodeerida(s_peidetav_tekst,s_kuvatav_tekst)
s_steganotekst=s_ekirjast_kopeeritud_tekstilõik

# s_steganotekst=<<TEKSTIPIIRE
# Siinse rea asemele võib kopeerida-asetada steganoteksti
# TEKSTIPIIRE

#puts s_steganotekst # ja ma ei ropenda, "puts" on "put string" akronüüm,
# kuigi, huvitav, milline oleks 
# <osa roppusi mmmv_notes koopiast M.V. poolt kustutatud>
# elekroonikutel on olemas elekroonikakomponent nimega "türistor"
# https://et.wikipedia.org/wiki/T%C3%BCristor
# <osa roppusi mmmv_notes koopiast M.V. poolt kustutatud>


s_dekodeeritud=ob.s_dekodeerin(s_steganotekst)
puts "\nDekodeeritud tekst on: "+s_dekodeeritud+"\n"

#==========================================================================
