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
   rm -f var/$dir
   mkdir -p var/$dir
done

rm -rf .stamp* dev-tag.sh .git

chmod 755 .
chmod 755 /root

echo Built: `date` >> etc/issue
echo >> etc/issue
cp etc/issue usr/local/etc/issue
