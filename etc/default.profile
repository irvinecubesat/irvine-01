export PATH=/sbin:/usr/sbin:$PATH:/usr/local/sbin:/usr/local/bin
#export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
unset boardType
Serial=$(awk '/Serial/ {print substr($3,length($3)-3)}' /proc/cpuinfo)
case "$Serial" in
     8211)
       boardType="gnd"
     ;;
     8212)
       boardType="flt"
     ;;
esac
PS1=`uname -n`'-${boardType-"unknown"}':'$PWD'# ; export PS1
