#!/usr/bin/env ruby
=begin
Antud faili autor: Martin.Vahi@softf1.com
Antud faili litsensiks on rahvapärand ("public domain").

SPDX-License-Identifier: 0BSD

Testimisparameetrid ("rubi -v", "uname -a")
    ruby 4.0.2 (2026-03-17 revision d3da9fec82) +PRISM [x86_64-linux]
    Linux terminal01 6.1.0-51-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.177-1 (2026-07-16) x86_64 GNU/Linux

Fail loodi 2026_09_22 tuttavate vahelise epostitsi peetava debati
alamosaks ning minu(Martin.Vahi@softf1.com) üllatuseks oli antud
simulatsiooni korral just tulemus, et isegi kui algseisus on 99%
kogu ühiskonnast niiölelda rikkad, kes suudavad oma lastele
hariduse ja hariduse omandamisel kuluva elamisraha kinni maksta, on
ühiskonna rikaste protsent vaid paari generatsiooniga ligikaudu üks
konstant, mis sõltub enam-vähem vaid sellest, kui palju oma lastele
haridust ja õppimisaegset elu-olu kinni maksata MITTE JAKSAVATE
vanemate lastele kogu hariduse omandamine "maksurahast" või rikaste
grantidest kinni makstakse. Antud lihtsat simulatsiooni kirjutama
asudes ma ei osanud arvata, et ühiskonnas olev rikaste protsent
nii vähese generatsioonide arvuga enam-vähem üheks konstnandiks
koondub. Tagantjärgi matemaatiliselt asja vaadates näib see ju
iseenesest mõistetav olevat, aga vähemalt minu korral tuleb asjad
tihtilugu välja kirjutada, et ma neist aru saaks.

Poliitiliselt tähendab antud simulatsiooni tulemus seda, et "tasuta
kõrgharidus" on HÄDAVAJALIK isegi kui mingil hetkel on kõigil
lapsevanematel raha, et oma lastele ise kõik vabalt, kasvõi
möödaminnes, välja maksta. S.t. argument, et asi X maksab nii vähe,
et kõigil on nii kui nii raha see ise kinni maksta, antud kontekstis
ei päde isegi siis, kui kõigil ongi päriselt raha, et asi X lausa
möödaminnes kinni maksta!

Siit tekib mul järgmine mõte, et mis muudes valdkondades "tasuta
teenused" hädavajalikud on isegi olukorras, kus inimestele ei tekita
raskusi need teenused ise välja maksta. Mu esmamõte 2026_09_22 seisuga
selles osas on, et seni, kuniks inimesed spetsialiseeruvad, seni ei
näe nad ka enda erialast välja jäävaid ohte ja probleeme, millest
siis ka nende küündimatus näha vastavaid investeeringu-vajadusi
isegi kui investeering on 2026. aasta Eesti palkade kontekstis sõna
otseses mõttes 10€ (kümme eurot).  Illustratsiooniks sobib
kuhugi reisile minevatele lähedastele mõne väikese, lihtsa,
suhteliselt odava asja kaasa sokutamine a la pakk lõikoplaste suvilasse
minejatele, USB-laadimis-juhe, mingi kirjutusvahend auto kindalaekasse,
jne.  Kapitalistliku anarhistina väidan, et see ei ole õigustus
kommunismiks ega inimestelt, ka rikastelt inimestelt, vastu nende
tahtmist vara röövimiseks/maksustamiseks, vaid pigem on see õigustus,
et vabatahtlikel annetustel põhinevatel mittetulundusühingutel on
kõvasti kasulikku tööd teha!

Tänan lugemast.

=end


# Antud kood on eriti lõdvalt, akadeemilises stiilis, kirjutatud, s.t.
# peaaegu ei mingeid sisendikontrolle ega vahekontrolle.
class Simulatsioon
   def initialize (fd_01, fd_02, fd_03, fd_04)
      # Protsendi määramispiirkond on reaalarv kinnises lõigus [0;100]
      @fd_01_rikaste_protsent_kogu_ühiskonnas=fd_01
      @fd_02_rikaste_järglaste_protsent_kel_on_äriinstinkt_ja_sobivalt_suur_IQ=fd_02 # protsent protsendist

      i_planeet_Maa_elanikkonna_suurus=13*(10**9) # 13 miljardit, lihtsustatult, Wikipedia-soga-andmete põhjal

      # Idee on, et matemaatiliselt on (0,0000001)^999999999999999999999999999999
      # ju suurem nullist, aga "pool inimest" või "üks kümnendik inimesest"
      # ei lähe arvesse ühe inimesena ka siis, kui see inimene rikas on.
      # Lihtsustatult saab kogu planeedi inimkonna suuruseks valida 13 miljardit,
      # mis tähendab, et 1 inimene sellest 13 miljardist on protsendina:
      @fd_nullist_suurem_rikaste_protsent_kogu_ühiskonnas_mis_lihtsustatakse_nulliks=0+
      (1.to_r/i_planeet_Maa_elanikkonna_suurus)*100

      # Tõenäosuse määramispiirkond on reaalarv kinnises lõigus [0;1] (jah, nullist üheni, siin pole kirjaviga)
      @fd_03_tõenäosus_et_vaese_inimese_järglane_on_äriinstinktiga_ja_sobivalt_suure_IQga=fd_03
      @fd_04_tõenäosus_et_vaese_inimese_järglane_saab_õppegrandi_ja_stipendiumi=fd_04

      # formaalsusena, ma ei suutnud seda koodi siiski täiesti sisendkontrollita jätta
      throw(Exception.new("GUID=='45e598c4-a064-4ccd-8124-03b150619ae7'")) if fd_01 < 0
      throw(Exception.new("GUID=='48c714a0-1bc5-447e-a934-03b150619ae7'")) if fd_02 < 0
      throw(Exception.new("GUID=='b1a7d68c-cacb-4286-9744-03b150619ae7'")) if fd_03 < 0
      throw(Exception.new("GUID=='165c0472-5b44-4ba8-b214-03b150619ae7'")) if fd_04 < 0
      throw(Exception.new("GUID=='4c76e183-d159-470e-8924-03b150619ae7'")) if 100 < fd_01
      throw(Exception.new("GUID=='156713f1-4698-42b2-8934-03b150619ae7'")) if 100 < fd_02
      throw(Exception.new("GUID=='13be1ce1-c68f-460d-8e14-03b150619ae7'")) if 1 < fd_03
      throw(Exception.new("GUID=='551745a2-922b-4bae-ad34-03b150619ae7'")) if 1 < fd_04
      @fd_01_rikaste_protsent_kogu_ühiskonnas.freeze # algkonstant simulatsioonis
      @fd_02_rikaste_järglaste_protsent_kel_on_äriinstinkt_ja_sobivalt_suur_IQ.freeze
      @fd_03_tõenäosus_et_vaese_inimese_järglane_on_äriinstinktiga_ja_sobivalt_suure_IQga.freeze
      @fd_04_tõenäosus_et_vaese_inimese_järglane_saab_õppegrandi_ja_stipendiumi.freeze
      @fd_nullist_suurem_rikaste_protsent_kogu_ühiskonnas_mis_lihtsustatakse_nulliks.freeze
   end # initialize

   private

   public

   # Negatiivne väljundarv tähistab olukorda, et rikaste elimineerumiseni
   # kulub rohkem põlvkondi kui i_maksimaalne_iteratsioonide_arv.
   def i_rikaste_elimineerumiseni_kuluv_põlvkondade_arv(i_maksimaalne_iteratsioonide_arv, i_konsoolile_väljastamise_intervall=1)
      if i_maksimaalne_iteratsioonide_arv.class != Integer
         throw(Exception.new("GUID=='82d06b68-2fbf-4a52-b624-03b150619ae7'"))
      end # if
      if i_konsoolile_väljastamise_intervall.class != Integer
         throw(Exception.new("GUID=='2f6406d2-d8f3-43e8-b744-03b150619ae7'"))
      end # if
      if i_maksimaalne_iteratsioonide_arv < 1
         throw(Exception.new("GUID=='86b33278-53e1-475d-b3c4-03b150619ae7'"))
      end # if
      if i_konsoolile_väljastamise_intervall < 1
         throw(Exception.new("GUID=='38d6b961-c5b5-4a27-9954-03b150619ae7'"))
      end # if

      fd_01=0.to_r+@fd_01_rikaste_protsent_kogu_ühiskonnas
      fd_01_rikastelt=nil
      fd_01_vaestelt=nil
      fd_vaeste_protsent_ühiskonnas=nil
      fd_02=@fd_02_rikaste_järglaste_protsent_kel_on_äriinstinkt_ja_sobivalt_suur_IQ # protsent protsendist
      fd_03=@fd_03_tõenäosus_et_vaese_inimese_järglane_on_äriinstinktiga_ja_sobivalt_suure_IQga
      fd_04=@fd_04_tõenäosus_et_vaese_inimese_järglane_saab_õppegrandi_ja_stipendiumi
      i_iteratsioonide_arv=0
      b_populatsioon_on_vaesunud=false
      while ( !b_populatsioon_on_vaesunud && (i_iteratsioonide_arv<i_maksimaalne_iteratsioonide_arv) )
         if (i_iteratsioonide_arv%i_konsoolile_väljastamise_intervall)==0
            printf(i_iteratsioonide_arv.to_s+":"+(fd_01.to_f.round(8)).to_s+"  ")
         end # if
         i_iteratsioonide_arv=i_iteratsioonide_arv+1
         fd_vaeste_protsent_ühiskonnas=100.to_r-fd_01
         fd_01_rikastelt=fd_01*(fd_02/100)
         fd_01_vaestelt=fd_vaeste_protsent_ühiskonnas*fd_03*fd_04
         fd_01=fd_01_rikastelt+fd_01_vaestelt
         if fd_01 <= @fd_nullist_suurem_rikaste_protsent_kogu_ühiskonnas_mis_lihtsustatakse_nulliks
            fd_01=0
            b_populatsioon_on_vaesunud=true
         end # if
      end # tsükkel
   end # i_rikaste_elimineerumiseni_kuluv_põlvkondade_arv

end # class Simulatsioon

def main()
   ob_simulatsioon=Simulatsioon.new(
   fd_01_rikaste_protsent=99, # 99% tähendab, et peaaegu kõik lapsevanemad suudavad oma järglaste hariduse ise kinni maksta
   fd_02_rikaste_rikkana_püsivate_järglaste_protsent=30,

   # 0.4 kasutaksin siis, kui kõik ülikoolilõpetajad oleks
   # äri-instinktiga. Eestis umbes 50% inimestest saab ülikooli sisse,
   # aga mingi osa langeb neist ka välja ning ülikoolist diplomi
   # kätte saanuist veel vaid murdosa hakkab vabakutseliseks juristiks,
   # hamba-arstiks, inseneriks, ... aga antud simulatsiooni eeldus
   # on, et luuakse hierarhia ja elatakse teiste töölt protsenti
   # võttes, mitte ei töötata oma enda töö abil arveid kirjutava
   # vabakutselisena, mistõttu 0.1 on väga suur arv siin.
   fd_03_tõenäosus_et_vaese_inimese_järglane_suudab_saada_rikkaks_kui_talle_haridus_ja_õppeaja_elamiskulud_kinni_makstakse=0.1,

   # ----mistral.ai--juturoboti---tsitaadi---algus---------------
   # 15–20% of U.S. undergraduate students receive a full
   # tuition grant (covering the entire cost of tuition, but
   # not necessarily fees, room, or board).
   #
   # 30–35% of students receive some form of grant aid
   # (partial or full), but most of these awards do not cover
   # the full cost of tuition.
   # ----mistral.ai--juturoboti---tsitaadi---lõpp----------------
   # Seega 35% on päris lahke variant, ääri-veeri võib
   # siinses simulatsioonis upitada ka ehk 40% peale.
   fd_04_tõenäosus_et_vaese_inimese_järglane_saab_õppegrandi_ja_stipendiumi=0.40) # meetodi-väljakutse lõppsulg

   i_maksimaalne_iteratsioonide_arv=100
   x0=ARGV[0]
   i_maksimaalne_iteratsioonide_arv=x0.to_i if x0!=nil

   i_konsoolile_väljastamise_intervall=1
   x1=ARGV[1]
   i_konsoolile_väljastamise_intervall=x1.to_i if x1!=nil

   ob_simulatsioon.i_rikaste_elimineerumiseni_kuluv_põlvkondade_arv(
   i_maksimaalne_iteratsioonide_arv,i_konsoolile_väljastamise_intervall)
end # main
main
