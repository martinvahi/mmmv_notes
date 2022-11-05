#!/usr/bin/env ruby
#--- start of a distracting hack to keep this example working -------------
if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   require(ob_pth_0.parent.parent.parent.to_s+"/src/include/kibuvits_boot.rb")
end # if
require  KIBUVITS_HOME+"/src/include/kibuvits_all.rb"
#==========================================================================

class Kibuvits_security_core_doc

   def initialize
   end # initialize

   private

   def i_get_nsa_cpu_per_20_years
      i_nsa_cpu_per_sec=Kibuvits_security_core.i_nsa_cpu_cycles_per_second_t1()
      i_nsa_cpu_per_year=i_nsa_cpu_per_sec*3600*24*(365+1)
      i_nsa_cpu_per_20_years=i_nsa_cpu_per_year*20
      return i_nsa_cpu_per_20_years
   end # i_get_nsa_cpu_per_20_years

   def doc_study_n_of_necessary_collisions_t1_core(i_collision_batch=4)
      i_nsa_cpu_per_20_years=i_get_nsa_cpu_per_20_years()

      # As there are only about 26 characters in
      # the Latin alphabet, the number of sequential
      # characters that collide should be roughly
      # smaller than 10. It's OK to collide more, if the
      # colliding characters are spread.
      #
      # (i_collision_batch)^(i_n_of_rounds)~i_nsa_cpu_per_20_years
      #
      # log_ (i_nsa_cpu_per_20_years) == i_n_of_rounds
      #     i_collision_batch
      #======================================
      #     log_ (i_nsa_cpu_per_20_years)
      #         2
      # ----------------------------------- = fd_n_of_rounds
      #     log_ i_collision_batch
      #         2
      #======================================
      #

      fd_n_of_rounds=(Math.log2(i_nsa_cpu_per_20_years))/
      (Math.log2(i_collision_batch))

      # The "+1" is related to the sqr(keyspace) part of the
      # brute force cracking. Assumption is that 2<=i_collision_batch.
      i_n_of_rounds=fd_n_of_rounds.round+1

      kibuvits_writeln(" "*16+"about "+i_n_of_rounds.to_s+
      " rounds for a batch of "+i_collision_batch.to_s+" ")
      #
      # The answer: it takes about 32 rounds for a batch of 8
      #                            46 rounds for a batch of 4
      #
   end # doc_study_n_of_necessary_collisions_t1_core

   public


   def doc_study_n_of_necessary_collisions_t1
      kibuvits_writeln("\n\n")
      kibuvits_writeln("To keep the NSA datacenters busy for "+
      "20 years, it takes:\n")
      [2,4,5,6,8,10,12,16,20,32,64].each do |i|
         doc_study_n_of_necessary_collisions_t1_core(i)
      end  #loop
      kibuvits_writeln("\n\n")
   end # doc_study_n_of_necessary_collisions_t1


   def doc_hash_length_by_countdown_t1
      i_base_x1=Kibuvits_security_core.ar_s_set_of_alphabets_t1.size
      i_base_x2=26
      i_n=i_get_nsa_cpu_per_20_years()
      #---------------
      func_n_of_digits=lambda do |i_base|
         i_digits=((Math.log2(i_n))/(Math.log2(i_base))).round
         return i_digits
      end # func_n_of_digits
      #---------------
      i_number_of_digits_x1=func_n_of_digits.call(i_base_x1)
      i_number_of_digits_x2=func_n_of_digits.call(i_base_x2)
      kibuvits_writeln("\n\n")
      kibuvits_writeln("If the NSA cluster were to count from 0 to N \n"+
      "for 20 years by i++ and the \n"+
      "\n      N were of base "+i_base_x1.to_s+",\n\n"+
      "then the N would consist of approximately \n"+
      "\n    "+i_number_of_digits_x1.to_s+" digits.\n\n"+
      "if the N were of base "+i_base_x2.to_s+",\n"+
      "then the N would consist of approximately \n"+
      "\n    "+i_number_of_digits_x2.to_s+" digits.\n\n"+
      "\n\n")
   end # doc_hash_length_by_countdown_t1


   def run
      doc_study_n_of_necessary_collisions_t1()
      doc_hash_length_by_countdown_t1()
   end # run


end # class Kibuvits_security_core_doc

#Kibuvits_security_core_doc.new.run


#==========================================================================
