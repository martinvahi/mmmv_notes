#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
else
   require  "kibuvits_msgc.rb"
end # if
#==========================================================================

=begin
   aadress:  
            Teha see asi kihtidena, nagu on interneti korral. Igal kihil on oma aadressi-osa.

ht_data_packet['protocols']=ar_hops
ar_hops<<ht_comlayer_for_hop1
ar_hops<<ht_comlayer_for_hop2
ar_hops<<ht_comlayer_for_hop3

ht_data_packet['s_data_packet_type']="ping"||"transit'||'broadcast'  
PING on v8rgu struktuuri teada saamiseks.

ht_data_packet['s_max_oneway_hopcount'] seab piirangu, '-1' t2hendab et piirangut pole
ht_data_packet['s_number_of_hopping_direction_changes']=0 kuid ==1 tagasiteel. 
ht_data_packet['s_hopcount']++ igas s8lmes.
ht_data_packet['s_priority']== sama mis UNIX'i protsessidel. Vaikimisi ==10
ht_data_packet['s_data_packet_id']==GUID v8i muidu mingi s8ne.
ht_data_packet['s_hopping_start_timestamp'+s_number_of_hopping_direction_changes]==unix_time integer


ht_data_packet['s_hoplog_ids_'+s_hopcount]<<s_comlayer_instance_id
ht_data_packet['s_hoplog_data_'+s_hopcount']<<s_whatever_else usually an empty string.



Iga ht_protocol sisaldab v2lju: s_comlayer_protocol_name, ht_comlayer_address, ht_data
ja TCP_IP korral on ht_comlayer_address v2ljad j2rgmised: IP-aadress v8i URL, port, 

V8imalikke s_comlayer_protocol_name v22rtusi: TCP_IP||filesport||linux_pipe||streams_2_devices
fileport on tavaportide asendus, kus suhtlus k2ib yle failisysteemi.

eelviimane comlayer v8ib olla: kibuvits_hive
                           s_channel==hive_control_channel||hive_errors_channel, 
                           s_command==selfdestruct||instantiate_client||start_client_selfdestruction_sequence||transit||ping||broadcast
                           ht_data_for_comlayer
                            |
                            +--ht_data_2_forward, 
                            +--ar_applications_ids



viimane comlayer on n2iteks: applicationlevel_phoneing, kus on 

s_channel_name===applications_main_channel||applications_error_channel||

vastuv8tja_isendi_lokaalne_telefoninumber, 
                           teate tyyp (phonecall processor name).

   k8ne parameetreid: soovituslik max viide, andmete formaat (text, ht_of_text,binary), data
   automaatselt lisatavad parameetrid: GUID-p8hine ID, tarup8hine GUIDi sisaldav sessiooni-ID, saatja aadress

   Tarule saab rakendada globaalseid filtreid, mis tegelevad kogu liiklusega. 
   N2iteks krypto, ja veakontroll.

   M8tiskleda ka selle yle, et kuidas toimub kommunikatsioon olukorras, kus
   Ruby jookseb Network Address Translation'i taga, v2iteks virtuaalmasins ja
   LAN'is on mitu fyysilist masinat, kus jookseb igayhes mitu virtuaalmasinat. Kuidas
   selle IP-aadresside asjaga siis saab, kui yhe fyysilise masina peal jooksvast 
   vituaalmasinast soovitakse luua yhendus teisel fyysilisel masinal jooksvasse
   virtuaalmasinasse v8i lausa samal fyysilisel masinal soovitakse yhest vituaalmasinast
   teise yhenduda.

   Samas masinas jooksvad protsessid saavad omavahel k8ige efektiivsemalt suhelda
   "named pipe" nimeliste faili imiteerivate asjade kaudu, mis on Windowsil ja Unixil 
   raja poolest tsipa erinevad ja mida tuleb ise luua ja enne programmi sulgumist ka 2ra kustutada.
   Teha mingi abstraktsioon Ruby 2 l8ime vahelise toru ning 2 Opsysteemi protsessi 
   vahelise toru ning yle v8rgu jooksvate torude jne. igasugu torude vahel. Bonnet\isse
   torude abstraktsiooniklassid. Windooza ja Linuxi jaoks on vaja eraldi nimega toru 
   realisatsiooniklassi. Protokollis teha eraldi kanal programmi peal8ime kokkuvarisemisest
   tuleneva sulgemise signaalile (kill) ning viisakast sulgemisest tulenevale signaalile, jne.
   nii et programmiisendi spetsiifilised Opsysteemiprotsesside torud koos alamprotsessidega
   saaks sobivalt, garanteeritult, suletud ja kustutatud.
 
   Alustada kogu seda lugu hoopis dokumentatsiooni kirjutamisest, kus siis lahti
   kirjutada ka see bussi osa. Piletite systeem tuleb ka kuidagi disaini
   sisse panna, automatiseerida. T8en2oliselt toimib piletite systeem l2bi
   nonde globaalsete taru-filtrite. Selle v8iks teha midagi
   sellist, et on loendur, mille v22rtus vastab pileti numbrile ja mida
   kasutamata piletite loomise k2igus inkrementeeritakse ning kliendid peavad 
   eelnevalt kysima omale kasutamata pileteid ning k8ik v2lja jagatud piletid asuvad paisktabelis.
   Sessiooni ID, mis on GUID, luuakse serveril sessiooni avamise k2igus.

Taru m8te on et saab t66s hoida hulga rakenduse isendeid ilma, et oleks vaja 
rakenduste k2ivitamisel/sulgemisel globaalseid algseadistusi ja parsimisi teha.
Ka hoiab see tarus olevate rakenduste arvelt pordinumbreid kokku. Tarul peaks siis
olema eraldi kanal rakenduste k2ivitamiseks.

# soovituslik maksimaalne viide peaks kohalikel k8nedel olema vaikimisi 0 ja
# kaug-k8nede korral v8iks olla mingi arvutusalgoritm, mis seda muudab.
# See peaks arvutama ka v8rguyhenduste kiirust, n2iteks tehes m88tmisi. 
# seega, yhenduse kiiruse m88tmise osa peaks siin (pigem telefonijaamas) 
# ka sees olema ja IP-aadsside j2rgi paisktabelis. :-) >
=end


class Kibuvits_hive
   def initialize
   end #initialize

   def connect i_port_number=48413,
   end # connect

end # class Kibuvits_hive


# It's meant to be a field of every phone.
# There's one phonestation per application. The hive's use
# Kibuvits_hive_router
class Kibuvits_phonestation
   attr_reader :s_my_IP_address, :i_my_port

   def initialize
      @s_my_IP_address=""
      @i_my_port=4444 # subject to studying
   end #initialize



end # class Kibuvits_phonestation

class Kibuvits_phone
   attr_reader :ob_phonestation
   def initialize ob_phonestation
      @ob_phonestation=ob_phonestation
   end #initialize

   public
   def Kibuvits_tunnel.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_tunnel.test_sar"
      return ar_msgs
   end # Kibuvits_tunnel.selftest
end # class Kibuvits_phone
#=========================================================================
