#!/usr/bin/env ruby
#===========================================================================
=begin
    Author: Martin.Vahi@softf1.com
    Koodi kirjutamise kuupäev: 2025_03_31
    Antud fail on rahvapärand ("public domain").
    SPDX-License-Identifier: 0BSD
    S_VERSION_OF_THIS_FILE="3e7fc8b1-0eac-4839-a5d7-93c190f139e7"
=end
#===========================================================================

ar_müra_1=Array.new
ar_müra_2=Array.new
ar_müra_3=Array.new
i_mõõdetud_müra_maksimumamplituud=10
fd_rääkija_jutt=i_mõõdetud_müra_maksimumamplituud*2 # ehk siin näites jutt on ainult poole valjem kui müra
i_mõõtmiste_arv=10 # ühtlasi ka näidisandmete massiivi pikkus
fd_0=nil
fd_1=0.to_r
fd_2=0.to_r
fd_3=0.to_r
n=0+i_mõõtmiste_arv
func_fd_juhuslik_müra_ühes_mikrofonis=lambda do
   fd_müra_amplituud=(rand(i_mõõdetud_müra_maksimumamplituud)).to_r
   fd_müra=fd_müra_amplituud
   fd_müra=(-1)*fd_müra_amplituud if rand(2)==0
   return fd_müra
end # func_fd_juhuslik_müra_ühes_mikrofonis
n.times do |ix|
   #----------------
   fd_0=func_fd_juhuslik_müra_ühes_mikrofonis.call()
   fd_1=fd_1+fd_0.abs
   ar_müra_1<<fd_0
   #----------------
   fd_0=func_fd_juhuslik_müra_ühes_mikrofonis.call()
   fd_2=fd_2+fd_0.abs
   ar_müra_2<<fd_0
   #----------------
   fd_0=func_fd_juhuslik_müra_ühes_mikrofonis.call()
   fd_3=fd_3+fd_0.abs
   ar_müra_3<<fd_0
   #----------------
end # tsükli lõpp
fd_mikrofon_1_müra_amplituudi_aritmeetiline_keskmine=(fd_1/i_mõõtmiste_arv)
fd_mikrofon_2_müra_amplituudi_aritmeetiline_keskmine=(fd_2/i_mõõtmiste_arv)
fd_mikrofon_3_müra_amplituudi_aritmeetiline_keskmine=(fd_3/i_mõõtmiste_arv)
fd_mikrofon_1_mürasignaalsuhe=fd_mikrofon_1_müra_amplituudi_aritmeetiline_keskmine/fd_rääkija_jutt
fd_mikrofon_2_mürasignaalsuhe=fd_mikrofon_2_müra_amplituudi_aritmeetiline_keskmine/fd_rääkija_jutt
fd_mikrofon_3_mürasignaalsuhe=fd_mikrofon_3_müra_amplituudi_aritmeetiline_keskmine/fd_rääkija_jutt
ar_mürade_summa=Array.new
fd_0=nil
fd_1=0.to_r
n.times do |ix|
   fd_0=(ar_müra_1[ix]+ar_müra_2[ix]+ar_müra_3[ix])
   ar_mürade_summa<<fd_0
   fd_1=fd_1+fd_0.abs
end # tsükli lõpp
fd_mürade_summa_amplituudi_aritmeetiline_keskmine=(fd_1/i_mõõtmiste_arv)
fd_mikrofonideülene_mürasignaalsuhe=fd_mürade_summa_amplituudi_aritmeetiline_keskmine/(3*fd_rääkija_jutt)
printf("\n Tulemus: \n"+
"ar_müra_1=="+ar_müra_1.to_s+"\n"+
"ar_müra_2=="+ar_müra_2.to_s+"\n"+
"ar_müra_3=="+ar_müra_3.to_s+"\n"+
"fd_mikrofon_1_müra_amplituudi_aritmeetiline_keskmine="+fd_mikrofon_1_müra_amplituudi_aritmeetiline_keskmine.to_f.round(4).to_s+"\n"+
"fd_mikrofon_2_müra_amplituudi_aritmeetiline_keskmine="+fd_mikrofon_2_müra_amplituudi_aritmeetiline_keskmine.to_f.round(4).to_s+"\n"+
"fd_mikrofon_3_müra_amplituudi_aritmeetiline_keskmine="+fd_mikrofon_3_müra_amplituudi_aritmeetiline_keskmine.to_f.round(4).to_s+"\n"+
"fd_mikrofon_1_mürasignaalsuhe="+fd_mikrofon_1_mürasignaalsuhe.to_f.round(4).to_s+"\n"+
"fd_mikrofon_2_mürasignaalsuhe="+fd_mikrofon_2_mürasignaalsuhe.to_f.round(4).to_s+"\n"+
"fd_mikrofon_3_mürasignaalsuhe="+fd_mikrofon_3_mürasignaalsuhe.to_f.round(4).to_s+"\n"+
"ar_mürade_summa=="+ar_mürade_summa.to_s+"\n"+
"fd_mürade_summa_amplituudi_aritmeetiline_keskmine=="+fd_mürade_summa_amplituudi_aritmeetiline_keskmine.to_f.round(4).to_s+"\n"+
"fd_mikrofonideülene_mürasignaalsuhe="+fd_mikrofonideülene_mürasignaalsuhe.to_f.round(4).to_s+"\n"+
"\n")

fd_0=((fd_mikrofon_1_mürasignaalsuhe+fd_mikrofon_2_mürasignaalsuhe+fd_mikrofon_3_mürasignaalsuhe)/3)
if fd_mikrofonideülene_mürasignaalsuhe < fd_0
   printf("\n\e[32m Mitme mikrofoni kasutamisel mürasignaalsuhe vähenes ehk olukord muutus paremaks.\e[39m\n\n")
end # if
