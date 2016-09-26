# irvine-01-cfg
Irvine-01 config customizations allows us to replace files in the generated
image with our own files.

This is a way to replace or modify existing configuration files or scripts
in the generated image.  The only files we would need to modify are
/etc/inittab.append to add items to the initial startup/software watchdog

To add new scripts or code, use the irvine-01-sw project.
