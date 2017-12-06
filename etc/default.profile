#
# Dynamically set the command prompt with the board type based on the serial
# number of the board.  In irvine-01, we had flt and gnd boards.
#
export PATH=/sbin:/usr/sbin:$PATH:/usr/local/sbin:/usr/local/bin
#export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
unset boardType
Serial=$(awk '/Serial/ {print substr($3,length($3)-3)}' /proc/cpuinfo)
case "$Serial" in
     8211)
       # irvine-02, formerly the gnd board
       boardType="flt"
     ;;
     8212)
       # irvine-01
       boardType="flt"
     ;;
esac
PS1=`uname -n`'-${boardType-"unknown"}':'$PWD'#' ' ; export PS1
