INSTALLATION
============

Create Basic Image
------------------

In principle this application should work on any of the standard linux images for the Pi.  The instructions are based around the mimimal Raspberian image distributed by the Pi foundation though.

Download the Raspbian Jessie Lite image (zip) file from https://www.raspberrypi.org/downloads/raspbian/, then follow the instruction at https://www.raspberrypi.org/documentation/installation/installing-images/README.md to install it to an SD card.  Insert the card into your PI and boot from it.

Install the BCM2835 C library
-----------------------------

Follow the instructions at http://www.airspayce.com/mikem/bcm2835/ to install the library needed to talk to the GPIO pins on the PI.

It should be a simple:

wget [latest source package]

tar -xzvf [downloaded file name]

cd [directory which was created]

./configure

make

sudo make install


Install the Device::BCM2835 perl wrapper
----------------------------------------

We use the perl module which talks to the C library installed in the previous step.  To get this you can use the CPAN module:

perl -MCPAN -e 'install Device::BCM2835'






