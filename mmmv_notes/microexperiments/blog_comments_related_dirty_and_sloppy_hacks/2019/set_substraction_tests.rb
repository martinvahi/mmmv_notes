#!/usr/bin/env ruby
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain
#
# The code in this file is in Estonian, because this file is
# part of a personal correspondance between 2 Estonians.
#
# Some of the ideas at 
#
#    https://cs.stackexchange.com/questions/17984/computing-set-difference-between-two-large-sets
#    (archival copy: https://archive.is/ZJxa4 )
#
# revolve around the idea of sorting the set storing arrays 
# before trying to compute the set substraction.
#
#--------------------------------------------------------------------------


# Antud klass on primitiivne simulaator simuleerimaks
# olukorda, kus kõvaketas_1 pealt üritatakse kopeerida
# kõik need failid, mida kõvaketas_2 veel ei sisalda,
# kõvaketas_2 peale. Kõvaketta analoogiks on hulk ning
# kuna indekseerimata failide üles otsimine
# kõvakettalt on massiivist elementide otsimisele
# sarnasem kui paisktabelist elementide otsimisele,
# siis on tõetruuma töösammude mõõtmistulemuse
# saamiseks siin simulaatoris hulgad kujutatud
# massiivide, mitte paisktabelitena. Simuleerimisparameetreid
# saab muuta meetodi jooksutan(...) sisendparameetrite kaudu.
class Yliprimitiivne_simulaator

   private

   # Loob uue massiivi, mille sisu ühildub
   # ar_sisend sisuga, kuid kus elemendid on
   # juhuslikult segi paisatud.
   def ar_permutatsioon(ar_sisend)
      if ar_sisend.class!=Array
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='fc2118b3-2dc9-4f48-b119-0232e0b013e7'\n\n"))
      end # if
      #--------------------
      ar_perm=Array.new
      i_len=ar_sisend.size
      return ar_perm if i_len==0
      #--------------------
      ht_0=Hash.new
      func_0=lambda do |ar_in,ar_out|
         if ar_in.size!=ar_out.size
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID=='332c14b5-35f0-411b-8049-0232e0b013e7'\n\n"))
         end # if
         #----------------
         ht_0.clear
         ix_ar_out=0
         ix_ar_in=0
         i_len=ar_in.size # == ar_out.size
         i_0=i_len*2
         i_0.times do
            ix_ar_in=rand(i_len) # min == 0, max == (i_len-1)
            if !ht_0.has_key? ix_ar_in
               ar_out[ix_ar_out]=ar_in[ix_ar_in]
               ht_0[ix_ar_in]=42
               ix_ar_out+=1
            end # if
         end # loop
         i_len.times do |ix_0|
            next if ht_0.has_key? ix_0
            ar_out[ix_ar_out]=ar_in[ix_0]
            ix_ar_out+=1
         end # loop
         ht_0.clear # should someone else want to use that tmp var
         if 2<=i_len
            # Useless if-clause, if this lambda
            # function is called multiple times, but
            # makes it slightly better for a single call.
            ix_end=i_len-1
            x_0=ar_out[0]
            x_end=ar_out[ix_end]
            ar_out[0]=x_end
            ar_out[ix_end]=x_0
         end # if
         ar_out.reverse!
      end # func_0
      #--------------------
      ar_0=[]+ar_sisend
      ar_1=[]+ar_sisend
      func_1=lambda do |i_n|
         if i_n<1
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID=='2379eb72-648e-4cff-8258-0232e0b013e7'\n\n"))
         end # if
         i_n.times do
            func_0.call(ar_0,ar_1)
            func_0.call(ar_1,ar_0)
         end # loop
      end # func_1
      #--------------------
      func_1.call(3)
      ar_perm=ar_0
      return ar_perm
   end # ar_permutatsioon

   # Kuna arvu hulga definitsiooni kohaselt
   # saab üks arv moodustada ühes ja samas arvude hulgas
   # vaid ühe elemendi, siis ei tohi arvuhulga analoogiks
   # loodav arvude massiiv sisaldada ühtegi arvu rohkem kui üks kord.
   def ar_algväärtustan_hulga(i_elementide_arv)
      cl=i_elementide_arv.class
      # Alates Ruby versioon 2.4.0 klasse Fixnum ja Bignum
      # enam täisarvutüübina ei kasutata, välja arvatud tagasiühilduvuseks.
      if (cl!=Integer)&&(cl!=Fixnum)&&(cl!=Bignum)
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='2eea5df3-d240-44bf-ab38-0232e0b013e7'\n\n"))
      end # if
      if i_elementide_arv<0
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='4b6ff685-e550-4ad3-a238-0232e0b013e7'\n\n"))
      end # if
      #--------------------
      ar_väljund=Array.new
      return ar_väljund if i_elementide_arv==0
      ar_0=Array.new
      i_elementide_arv.times{|i| ar_0<<i}
      ar_väljund=ar_permutatsioon(ar_0)
      return ar_väljund
   end # ar_algväärtustan_hulga

   public

   def initialize
      @ar_hulk_suur=ar_algväärtustan_hulga(10000)
      @ar_hulk_väike=ar_algväärtustan_hulga(2000)
   end # initialize

   # Oleks see lihtsalt tarkvara, siis oleks siin kasutusel
   # midagi efektiivsemat, aga kuna see siin on
   # kõvaketastel failidega tegelemise simulatsioon,
   # mistõttu tuleb jäljendada simuleeritavat tegevust.
   def ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
      ar_hulk_a,ar_hulk_b,ht_opmem,b_v2line_tsykkel_yle_a=true)
      #------------------------------------------
      if ar_hulk_a.class!=Array
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='524e9ad6-ebcb-479e-a258-0232e0b013e7'\n\n"))
      end # if
      if ar_hulk_b.class!=Array
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='112a3fb2-4b16-4ecb-a028-0232e0b013e7'\n\n"))
      end # if
      if ht_opmem.class!=Hash
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='11d31c91-cebf-4d39-8738-0232e0b013e7'\n\n"))
      end # if
      cl=b_v2line_tsykkel_yle_a.class
      if (cl!=TrueClass)&&(cl!=FalseClass)
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='1db4ba33-e72e-480a-9118-0232e0b013e7'\n\n"))
      end # if
      #------------------------------------------
      b_m88da=false
      i_sammud_0=nil
      if ht_opmem.has_key? "i_sammud_0"
         i_sammud_0=ht_opmem["i_sammud_0"]
         b_m88da=true
      end # if
      #------------------------------------------
      ar_vahe=Array.new
      if b_v2line_tsykkel_yle_a
         ar_hulk_a.each do |i_elem_a|
            b_leidub_hulgas_b=false
            ar_hulk_b.each do |i_elem_b|
               i_sammud_0+=1 if b_m88da
               if i_elem_a==i_elem_b
                  b_leidub_hulgas_b=true
                  break
               end # if
            end # tsükkel
            ar_vahe<<i_elem_a if !b_leidub_hulgas_b
         end # tsükkel
      else
         ht_intersection=Hash.new
         ar_hulk_b.each do |i_elem_b|
            b_leidub_hulgas_a=false
            ar_hulk_a.each do |i_elem_a|
               i_sammud_0+=1 if b_m88da
               if i_elem_a==i_elem_b
                  b_leidub_hulgas_a=true
                  break
               end # if
            end # tsükkel
            ht_intersection[i_elem_b]=42 if b_leidub_hulgas_a
         end # tsükkel
         ar_hulk_a.each do |i_elem_a|
            i_sammud_0+=1 if b_m88da
            ar_vahe<<i_elem_a if !ht_intersection.has_key? i_elem_a
         end # tsükkel
      end # if
      #------------------------------------------
      if b_m88da
         ht_opmem["i_sammud_0"]=i_sammud_0
      end # if
      #------------------------------------------
      return ar_vahe
   end # ar_hulkade_vahe_a_miinus_b_realisatsioon_01

   def s_tulemused(ht_opmem)
      if ht_opmem.class!=Hash
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='2108dab2-2e4b-480f-8c58-0232e0b013e7'\n\n"))
      end # if
      #------------------------------------------
      i_sammud_a_miinus_b=ht_opmem["i_sammud_a_miinus_b"]
      i_sammud_b_miinus_a=ht_opmem["i_sammud_b_miinus_a"]
      i_sammud_a_miinus_b_režiim_2=ht_opmem["i_sammud_a_miinus_b_režiim_2"]
      i_sammud_b_miinus_a_režiim_2=ht_opmem["i_sammud_b_miinus_a_režiim_2"]
      ar_hulk_a=ht_opmem["ar_hulk_a"]
      ar_hulk_b=ht_opmem["ar_hulk_b"]
      #------------------------------------------
      s_väljund=""
      s_väljund<<"\n\n"
      s_väljund<<"--------------------------------------------------\n"
      s_väljund<<"i_sammud_a_miinus_b=="+i_sammud_a_miinus_b.to_s+"\n"
      s_väljund<<"i_sammud_b_miinus_a=="+i_sammud_b_miinus_a.to_s+"\n"
      s_väljund<<"i_sammud_a_miinus_b_režiim_2=="+i_sammud_a_miinus_b_režiim_2.to_s+"\n"
      s_väljund<<"i_sammud_b_miinus_a_režiim_2=="+i_sammud_b_miinus_a_režiim_2.to_s+"\n"
      s_väljund<<"ar_hulk_a.size=="+ar_hulk_a.size.to_s+"\n"
      s_väljund<<"ar_hulk_b.size=="+ar_hulk_b.size.to_s+"\n"
      s_väljund<<"--------------------------------------------------\n"
      s_väljund<<"\n\n"
   end # s_tulemused

   def jooksutan(i_hulga_a_elementide_arv,
      i_hulga_b_elementide_arv)
      #------------------------------------------
      cl=i_hulga_a_elementide_arv.class
      if (cl!=Integer)&&(cl!=Fixnum)&&(cl!=Bignum)
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='21b5b373-c1e3-45fd-bb48-0232e0b013e7'\n\n"))
      end # if
      cl=i_hulga_b_elementide_arv.class
      if (cl!=Integer)&&(cl!=Fixnum)&&(cl!=Bignum)
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='45bce31d-49b7-45c4-b238-0232e0b013e7'\n\n"))
      end # if
      if i_hulga_a_elementide_arv<0
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='c32e03b2-80ea-4ad4-a258-0232e0b013e7'\n\n"))
      end # if
      if i_hulga_b_elementide_arv<0
         raise(Exception.new("\n\nPalun lugege programmi koodi.\n"+
         "GUID=='f8e3ceba-dd1f-462d-8318-0232e0b013e7'\n\n"))
      end # if
      #------------------------------------------
      ht_opmem=Hash.new
      ar_hulk_a=ar_algväärtustan_hulga(i_hulga_a_elementide_arv)
      ar_hulk_b=ar_algväärtustan_hulga(i_hulga_b_elementide_arv)
      ht_opmem["ar_hulk_b"]=ar_hulk_b
      ht_opmem["ar_hulk_a"]=ar_hulk_a
      #------------------------------------------
      ht_opmem["i_sammud_0"]=0
      ar_vahe_a_miinus_b=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
      ar_hulk_a,ar_hulk_b,ht_opmem,true)
      i_sammud_0=ht_opmem["i_sammud_0"]
      ht_opmem["i_sammud_a_miinus_b"]=i_sammud_0
      #------------------------------------------
      ht_opmem["i_sammud_0"]=0
      ar_vahe_b_miinus_a=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
      ar_hulk_b,ar_hulk_a,ht_opmem,true)
      i_sammud_0=ht_opmem["i_sammud_0"]
      ht_opmem["i_sammud_b_miinus_a"]=i_sammud_0
      #------------------------------------------
      ht_opmem["i_sammud_0"]=0
      ar_vahe_a_miinus_b=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
      ar_hulk_a,ar_hulk_b,ht_opmem,false)
      i_sammud_0=ht_opmem["i_sammud_0"]
      ht_opmem["i_sammud_a_miinus_b_režiim_2"]=i_sammud_0
      #------------------------------------------
      ht_opmem["i_sammud_0"]=0
      ar_vahe_b_miinus_a=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
      ar_hulk_b,ar_hulk_a,ht_opmem,false)
      i_sammud_0=ht_opmem["i_sammud_0"]
      ht_opmem["i_sammud_b_miinus_a_režiim_2"]=i_sammud_0
      #------------------------------------------
      puts(s_tulemused(ht_opmem))
   end # jooksutan


   def selftest_01
      ht_opmem=Hash.new
      5.times do
         ar_hulk_b=ar_algväärtustan_hulga(100)
         ar_hulk_a=ar_algväärtustan_hulga(20)
         ht_opmem["ar_hulk_b"]=ar_hulk_b
         ht_opmem["ar_hulk_a"]=ar_hulk_a
         #----------
         ht_opmem["i_sammud_0"]=0
         ar_0=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
         ar_hulk_b,ar_hulk_a,ht_opmem,true)
         ar_1=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
         ar_hulk_b,ar_hulk_a,ht_opmem,false)
         #----------
         i_len=ar_0.size
         if i_len==0
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID=='744a9889-e0a3-4a9c-bc17-0232e0b013e7'\n\n"))
         end # if
         if ar_0.size!=ar_1.size
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID=='a4206a7f-e47b-444e-bb37-0232e0b013e7'\n\n"))
         end # if
         if ar_0[0]==ar_0[1]
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID=='7260f1a1-d941-409f-9d27-0232e0b013e7'\n\n"))
         end # if
         if ar_1[0]==ar_1[1]
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID=='38c608ec-6e09-41ef-8497-0232e0b013e7'\n\n"))
         end # if
         #----------
         ar_0.sort!
         ar_1.sort!
         x_0=nil
         x_1=nil
         i_len.times do |ix|
            x_0=ar_0[ix]
            x_1=ar_1[ix]
            if x_0!=x_1
               raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
               "GUID=='4d372644-0633-49e5-a627-0232e0b013e7'\n\n"))
            end # if
         end # loop
         #----------
      end # loop
   end # selftest_01

   def selftest_02_aid(ar_hulk_a,ar_hulk_b,ar_expected,s_guid)
      if s_guid.class!=String
         raise(Exception.new("\n\nTesti kood on vigane.\n"+
         "GUID=='3e2fa141-97e6-4b87-b137-0232e0b013e7'\n\n"))
      end # if
      #----------
      ht_opmem=Hash.new
      ht_opmem["ar_hulk_b"]=ar_hulk_b
      ht_opmem["ar_hulk_a"]=ar_hulk_a
      #----------
      ht_opmem["i_sammud_0"]=0
      ar_0=ar_hulkade_vahe_a_miinus_b_realisatsioon_01(
      ar_hulk_a,ar_hulk_b,ht_opmem,true)
      #----------
      i_len=ar_0.size
      ar_expected.sort!
      ar_0.sort!
      x_0=nil
      x_1=nil
      i_len.times do |ix|
         x_0=ar_0[ix]
         x_1=ar_expected[ix]
         if x_0!=x_1
            raise(Exception.new("\n\nSiinse meetodi realisatsioon on vigane.\n"+
            "GUID_CANDIDATE=='"+s_guid+"'\n"+
            "x_0=="+x_0.to_s+"\n"+
            "x_1=="+x_1.to_s+"\n"+
            "GUID=='83fe9b1e-e96a-416a-be87-0232e0b013e7'\n\n"))
         end # if
      end # loop
   end # selftest_02_aid

   def selftest_02
      ar_hulk_a=[0,1,2,3,4,5,6,7]
      ar_hulk_b=[0,1,2,5]
      ar_expected=[3,4,6,7]
      selftest_02_aid(ar_hulk_a,ar_hulk_b,ar_expected,
      "360a8512-7dad-4786-8459-0232e0b013e7")
      #----------------
      ar_hulk_a=[0,1]
      ar_hulk_b=[0,1]
      ar_expected=[]
      selftest_02_aid(ar_hulk_a,ar_hulk_b,ar_expected,
      "544f4fd4-b083-4afe-b218-0232e0b013e7")
      #----------------
      ar_hulk_a=[7]
      ar_hulk_b=[9]
      ar_expected=[7]
      selftest_02_aid(ar_hulk_a,ar_hulk_b,ar_expected,
      "15146283-173c-4e7a-af18-0232e0b013e7")
      #----------------
      ar_hulk_a=[7,234]
      ar_hulk_b=[9,9214,344]
      ar_expected=[234,7]
      selftest_02_aid(ar_hulk_a,ar_hulk_b,ar_expected,
      "3f0dd9b4-174e-4140-9a28-0232e0b013e7")
      #----------------
      ar_hulk_a=[]
      ar_hulk_b=[]
      ar_expected=[]
      selftest_02_aid(ar_hulk_a,ar_hulk_b,ar_expected,
      "c3f531e7-7848-4c47-ab28-0232e0b013e7")
      #----------------
   end # selftest_02

end # class Yliprimitiivne_simulaator

#--------------------------------------------------------------------------
#Yliprimitiivne_simulaator.new.selftest_01
#Yliprimitiivne_simulaator.new.selftest_02
Yliprimitiivne_simulaator.new.jooksutan(5000,100)

#--------------------------------------------------------------------------
=begin console output citation
--------------------------------------------------
i_sammud_a_miinus_b==495050
i_sammud_b_miinus_a==259567
i_sammud_a_miinus_b_režiim_2==264567
i_sammud_b_miinus_a_režiim_2==495150
ar_hulk_a.size==5000
ar_hulk_b.size==100
--------------------------------------------------
=end console output citation
#==========================================================================
