#!/usr/bin/env bash 

S_FP_RUBY=`which ruby`

if [ "$S_FP_RUBY" == "" ]; then
       echo ""        
       echo "This application requires the 'ruby' to be on the PATH,"        
       echo "but it isn't on the PATH."        
       echo "GUID=='40c83d44-5d46-4e54-a519-a3c1a01161e7'"        
       echo ""        
       exit 1 # exit with an error
fi

S_TMP_0="`which identify`"
if [ "$S_TMP_0" == "" ]; then
       echo ""        
       echo "This application requires the ImageMagick console tool,"        
       echo "'identify' to be on the PATH, but it isn't on the PATH."        
       echo "GUID=='49f94ac3-cf50-49d9-8419-a3c1a01161e7'"        
       echo ""        
       exit 1 # exit with an error
fi
S_TMP_0="`which convert`"
if [ "$S_TMP_0" == "" ]; then
       echo ""        
       echo "This application requires the ImageMagick console tool,"        
       echo "'convert' to be on the PATH, but it isn't on the PATH."        
       echo "GUID=='87851b4b-d7b5-4223-8519-a3c1a01161e7'"        
       echo ""        
       exit 1 # exit with an error
fi

#------------------------------------------------------------

S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_CORE="$S_FP_DIR/bonnet/image_edge_length_limiter_t1_core.rb"
S_FP_origin="$S_FP_DIR/originals"
S_FP_destination="$S_FP_DIR/conversion_result"
S_FP_FUNC_X_IS_GREATER_THAN_0="$S_FP_DIR/bonnet/func_x_is_greater_than_zero.rb"

#------------------------------------------------------------

mkdir -p $S_FP_origin
chmod -f -R 0700 $S_FP_origin

mkdir -p $S_FP_destination
chmod -f -R 0700 $S_FP_destination
rm -fr $S_FP_destination
mkdir -p $S_FP_destination

#------------------------------------------------------------
S_EDGE_MAX_WIDTH="$1"

fun_get_edge_max_width () {
    local SB_ASK="t"
    local S_CMD="$S_FP_RUBY $S_FP_FUNC_X_IS_GREATER_THAN_0 "
    local S_EMW="$S_EDGE_MAX_WIDTH"
    local SB_FUNC_X_IS_GREATER_THAN_0_OUTPUT="f"
    while [ "$SB_ASK" == "t" ]; 
    do
           # This version is a misfortunate hack.
           # The correct version would have all of the UI
           # related code at the Ruby side.
           if [ "$S_EMW" != "" ]; then
                   SB_FUNC_X_IS_GREATER_THAN_0_OUTPUT=`$S_CMD $S_EMW`;
           fi
           if [ "$SB_FUNC_X_IS_GREATER_THAN_0_OUTPUT" == "t" ]; then
                   SB_ASK="f"
           else
                   echo ""        
                   read -p "Please enter the image edge maximum length in pixels: " S_EMW
                   echo ""        
           fi
    done
    S_EDGE_MAX_WIDTH="$S_EMW"
} # fun_tere
 
fun_get_edge_max_width 
#echo "$S_EDGE_MAX_WIDTH px"

#------------------------------------------------------------
echo ""
echo "Converting ... "
$S_FP_RUBY $S_FP_CORE $S_EDGE_MAX_WIDTH # $2 $3 $4 $5 $6 $7 $8 $9 
echo "Conversion process stopped."
unset S_EDGE_MAX_WIDTH

exit 0 # No errors.

