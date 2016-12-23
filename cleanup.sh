#!/bin/sh

FAKEROOT=/opt/toolchain/toolchain-arm-linux/bin/fakeroot
mv etc/inittab etc/inittab.old
cat etc/inittab.old | grep -v beacon > etc/inittab
rm etc/inittab.old

if [ -e etc/inittab.append ] ; then
   cat etc/inittab.append >> etc/inittab
   rm -f etc/inittab.append
fi

if [ -e usr/local/etc/inittab.append ] ; then
   cat usr/local/etc/inittab.append >> usr/local/etc/inittab
   rm -f usr/local/etc/inittab.append
fi

#
# Skip removing these directories since this causes problems with crontab
#
#for dir in log lock run spool cache; do
#   $FAKEROOT rm -rf var/$dir
#   $FAKEROOT mkdir -p var/$dir
#done

rm -rf .stamp* dev-tag.sh .git

$FAKEROOT chmod 755 .
$FAKEROOT chmod 755 root
$FAKEROOT cat ~/.ssh/id_rsa.pub >root/.ssh/authorized_keys
$FAKEROOT chmod -R 700 root/.ssh
$FAKEROOT chmod 600 etc/shadow
echo Built: `date` >> etc/issue
echo >> etc/issue
#
# Ensure usr/local/etc/issue is updated otherwise we get the NAND error message
#
cp etc/issue usr/local/etc/issue
