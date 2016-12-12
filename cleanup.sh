#!/bin/sh

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

for dir in log lock run spool cache; do
   fakeroot rm -rf var/$dir
   fakeroot mkdir -p var/$dir
done

rm -rf .stamp* dev-tag.sh .git

fakeroot chmod 755 .
fakeroot chmod 755 root
fakeroot cat ~/.ssh/id_rsa.pub >root/.ssh/authorized_keys
fakeroot chmod -R 700 root/.ssh
fakeroot chmod 600 etc/shadow
echo Built: `date` >> etc/issue
echo >> etc/issue
#
# Ensure usr/local/etc/issue is updated otherwise we get the NAND error message
#
cp etc/issue usr/local/etc/issue
