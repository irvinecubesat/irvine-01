#!/bin/sh

IRVINE_SW_INSTALL_DIR=~/.irvine-01-sw

if [ ! -d "$IRVINE_SW_INSTALL_DIR" ]; then
    echo "**************************** ERROR ********************************"
    echo "* Make sure you get the latest irvine-01-sw project and build it. *"
    echo "*******************************************************************"
    exit 1
fi
KEYINFO_FILE=~/.irvine-01.keyInfo
keyTool=${KEY_TOOL-${IRVINE_SW_INSTALL_DIR}/scripts/opensslKeyTool.sh}
satcommKey=$IRVINE_SW_INSTALL_DIR/auth/satcomm.enc
satcommKeyCfg=etc/satcommKey.cfg
satcommTemplate=etc/satcomm.cfg.in
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

# set up the .profile which defines the PATH and sh prompt
if [ -e etc/default.profile ]; then
    $FAKEROOT mv etc/default.profile root/.profile
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

(cd usr/local/etc; ln -s ../astrometry/etc/astrometry.cfg .)
#
# Remove unnecessary include files
#
$FAKEROOT rm -rf usr/local/include

log()
{
    echo $*
}

cleanup()
{
    rm $satcommTemplate
    rm $satcommKeyCfg
}

trap cleanup EXIT

satcommSetup()
{
    $keyTool -f $KEYINFO_FILE -d $satcommKey -o $satcommKeyCfg
    if [ $? -ne 0 ]; then
        log "[E] Error decoding $satcommKey.  Ensure you have registered your cert with the admin"
        return 1
    fi

    . $satcommKeyCfg
    
    aes_key=__AES128_KEY__
    aes_iv=__AES128_IV__
    sed -e s/$aes_key/$key/g -e s/$aes_iv/$iv/g $satcommTemplate>etc/satcomm.cfg
    if [ $? -ne 0 ]; then
        log "[E] Error running sed.  satcomm keys may not be set up properly"
    fi
}

satcommSetup


