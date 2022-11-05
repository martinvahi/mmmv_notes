#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_formula.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_GUID_generator.rb"
   require  "kibuvits_formula.rb"
end # if
require "singleton"
require "bigdecimal"
#==========================================================================

# The class Kibuvits_units is for various unit conversion
# related tasks. The units themselves are expected to be
# stored as Kubuvits_formula instances.
#
# For sake of speed the formulas are not allowed to
# use powers in any other form than series of multiplications,
# i.e. in stead of m^3 the formula should contain m*m*m.
# The alternative would be to start calling formula transformations
# from the Kibuvits_units, which affects speed.
#
# For the sake of precision, the BigDecimal class is used
# in stead of the ordinary floating point numbers.
class Kibuvits_units
   @@lc_s_formulicle_name='s_formulicle_name_'
   @@lc_ar_formulicle_elements='ar_formulicle_elements_'


   def init_ht_si_units
      # TODO: Actually, one can not always convert units by
      # multipliying the origin unit with some constant and
      # get the destination unit. One should use functional
      # programming approach here: one function per
      # graph edge. It will be truly tedious, but it's correct.
      @ht_si_units=Hash.new
      ht=Hash.new
      ht['cm']=BigDecimal((100.0).to_s)
      ht['mm']=BigDecimal((100.0*10).to_s)
      ht['km']=BigDecimal((1.0/1000).to_s)
      @ht_si_units['m']=ht

      ht=Hash.new
      ht['g']=BigDecimal((1000).to_s)
      ht['mg']=BigDecimal((1000*1000).to_s)
      ht['t']=BigDecimal((1.0/1000).to_s)
      @ht_si_units['kg']=ht

      ht=Hash.new
      ht['ms']=BigDecimal((1000).to_s)
      ht['min']=BigDecimal((1.0/60).to_s)
      ht['h']=BigDecimal((1.0/3600).to_s)
      @ht_si_units['s']=ht

      ht=Hash.new
      ht['mA']=BigDecimal((1000).to_s)
      @ht_si_units['A']=ht # electric current

      ht=Hash.new
      @ht_si_units['K']=ht # temperature

      ht=Hash.new
      @ht_si_units['cd']=ht # candela

      ht=Hash.new
      @ht_si_units['mol']=ht # number of particles

   end # init_ht_si_units

   def initialize
      @ht_unit_2_si_class=Hash.new
      init_ht_si_units()
   end #initialize



   private
   def Kibuvits_units.test_1
      #if !kibuvits_block_throws{Kibuvits_str.datestring_for_fs_prefix(42)}
      #   kibuvits_throw "test 1"
      #end # if
      #kibuvits_throw "test 2 "+s if s!="2000_01_21"
   end # Kibuvits_units.test_1

   public
   include Singleton
   def Kibuvits_units.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_units.test_1"
      return ar_msgs
   end # Kibuvits_units.selftest

end # class Kibuvits_units

#=========================================================================
