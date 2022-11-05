#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 Redistribution and use in source and binary forms, with or
 without modification, are permitted provided that the following
 conditions are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer
   in the documentation and/or other materials provided with the
   distribution.
 * Neither the name of the Martin Vahi nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end
#==========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"

#==========================================================================

# The class Kibuvits_coords is a namespace for coordinate
# conversion/calculation related code.
class Kibuvits_coords

   def initialize
   end # initialize

   # The material at the following address was really helpful:
   # http://geographyworldonline.com/tutorial/instructions.html
   #
   # This function returns 2 whole numbers, i_x, i_y, where
   # 0<=i_x<=(i_world_map_width-1)
   # 0<=i_y<=(i_world_map_height-1)
   def x_latitude_and_longitude_2_world_map_x_y_t1(fd_latitude,fd_longitude,
      i_world_map_width,i_world_map_height)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Fixnum,Rational,Float,Bignum], fd_latitude
         kibuvits_typecheck bn, [Fixnum,Rational,Float,Bignum], fd_longitude
         kibuvits_typecheck bn, [Fixnum,Bignum], i_world_map_width
         kibuvits_typecheck bn, [Fixnum,Bignum], i_world_map_height
      end # if KIBUVITS_b_DEBUG
      if (90<fd_latitude)
         msg="90< fd_latitude=="+fd_latitude.to_s
         kibuvits_throw(msg)
      end # if
      if (180<fd_longitude)
         msg="180 < fd_longitude=="+fd_longitude.to_s
         kibuvits_throw(msg)
      end # if
      if (fd_latitude<(-90))
         msg="fd_latitude=="+fd_latitude.to_s+" < (-90) "
         kibuvits_throw(msg)
      end # if
      if (fd_longitude<(-180))
         msg="fd_longitude=="+fd_longitude.to_s+" < (-180) "
         kibuvits_throw(msg)
      end # if

      if (i_world_map_width<1)
         msg="i_world_map_width=="+i_world_map_width.to_s+" < 1 "
         kibuvits_throw(msg)
      end # if
      if (i_world_map_height<1)
         msg="i_world_map_height=="+i_world_map_height.to_s+" < 1 "
         kibuvits_throw(msg)
      end # if

      fd_lat=fd_latitude.to_r # North-wards, [-90,90]
      fd_long=fd_longitude.to_r # East-wards [-180,180]
      # The North pole and "East pole" (from England) are with
      # positive values. The general idea of the calculations:
      # http://urls.softf1.com/a1/krl/frag2/
      fd_r=(i_world_map_height*1.0)/2
      fd_sin_alpha=Math.sin(fd_lat)
      #fd_cos_alpha=Math.cos(fd_lat)
      #fd_r2=fd_r*fd_cos_alpha
      fd_h2=fd_r*fd_sin_alpha
      i_y=(fd_r-fd_h2).to_f.round(0)
      fd_w2=(i_world_map_width*1.0)/2
      fd_2=fd_long/180.0
      i_x=(fd_w2+(fd_2*fd_w2)).to_f.round(0)

      i_x=i_world_map_width-1 if (i_world_map_width-1)<i_x
      i_y=i_world_map_height-1 if (i_world_map_height-1)<i_y
      i_x=0 if i_x<0
      i_y=0 if i_y<0
      return i_x,i_y
   end # x_latitude_and_longitude_2_world_map_x_y_t1


   def Kibuvits_coords.x_latitude_and_longitude_2_world_map_x_y_t1(
      fd_latitude,fd_longitude,i_world_map_width,i_world_map_height)
      i_x,i_y=Kibuvits_coords.instance.x_latitude_and_longitude_2_world_map_x_y_t1(
      fd_latitude,fd_longitude,i_world_map_width,i_world_map_height)
      return i_x,i_y
   end # Kibuvits_coords.x_latitude_and_longitude_2_world_map_x_y_t1

   #----------------------------------------------------------------------

   def i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      bn=binding()
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck bn, [Fixnum,Bignum], i_initial_width
         kibuvits_typecheck bn, [Fixnum,Bignum], i_initial_height
         kibuvits_typecheck bn, [Fixnum,Bignum], i_new_edge_length
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_scale_by_width
      end # if
      kibuvits_assert_is_smaller_than_or_equal_to(bn,
      1,[i_initial_width,i_initial_height,i_new_edge_length],
      "\nGUID=='61dcfb11-317b-4d15-bb3e-c1b241014dd7'\n")

      i_width_out=i_initial_width
      i_height_out=i_initial_height
      if b_scale_by_width
         if i_initial_width==i_new_edge_length
            return i_width_out,i_height_out
         end # if
      else
         if i_initial_height==i_new_edge_length
            return i_width_out,i_height_out
         end # if
      end # if

      # To keep the calculations that take place after the
      # call to this function more effective, the output of
      # this function is partly enforced to be in Fixnum format.
      fd_width_0=nil
      fd_height_0=nil
      fd_width_1=nil
      fd_height_1=nil
      fd_len_new=nil
      fd_ref=640000.0
      b_use_Float=false
      if (i_initial_width<fd_ref)&&(i_initial_height<fd_ref)&&(i_new_edge_length<fd_ref)
         fd_width_0=i_initial_width.to_f
         fd_height_0=i_initial_height.to_f
         fd_len_new=i_new_edge_length.to_f
         b_use_Float=true
      else
         fd_width_0=i_initial_width.to_r
         fd_height_0=i_initial_height.to_r
         fd_len_new=i_new_edge_length.to_r
      end # if

      if b_scale_by_width
         fd_new_dev_old=fd_len_new/fd_width_0
         fd_width_1=fd_len_new
         fd_height_1=fd_height_0*fd_new_dev_old
      else
         fd_new_dev_old=fd_len_new/fd_height_0
         fd_width_1=fd_width_0*fd_new_dev_old
         fd_height_1=fd_len_new
      end # if
      i_width_out=fd_width_1.round.to_i
      i_height_out=fd_height_1.round.to_i

      i_width_out=1 if i_width_out==0
      i_height_out=1 if i_height_out==0
      return i_width_out,i_height_out
   end # i_i_scale_rectangle

   def Kibuvits_coords.i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      i_width_out,i_height_out=Kibuvits_coords.instance.i_i_scale_rectangle(
      i_initial_width,i_initial_height,i_new_edge_length,b_scale_by_width)
      return i_width_out,i_height_out
   end # Kibuvits_coords.i_i_scale_rectangle

   #----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_coords

#--------------------------------------------------------------------------

#==========================================================================
