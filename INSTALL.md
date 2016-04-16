INSTALLATION
============

Create Basic Image
------------------

In principle this application should work on any of the standard linux images for the Pi.  The instructions are based around the mimimal Raspbian image distributed by the Pi foundation though.

Download the Raspbian Jessie Lite image (zip) file from https://www.raspberrypi.org/downloads/raspbian/, then follow the instruction at https://www.raspberrypi.org/documentation/installation/installing-images/README.md to install it to an SD card.  Insert the card into your PI and boot from it.

The default user on raspbian is 'pi' with password 'raspberry'.  It's probably a good idea to change this.


Update the image and install git
--------------------------------

Git is in the standard raspbian respository, but you will probably need to update your packages to get it to install.

```
sudo apt-get update

sudo apt-get upgrade (this might take a while)

sudo apt-get install git
```

Install omxplayer
-----------------

This is the application used to play mp3 files

```
sudo apt-get install omxplayer
```

Set your timezone
-----------------

Since some of the sounds you specify might depend on getting the local time correct you need to set your proper timezone rather than using the default of UTC.

```
sudo dpkg-reconfigure tzdata
```


Install the WiringPi library
----------------------------

This is the library used to talk to the raspberry pi's GPIO pins.

```
git clone git://git.drogon.net/wiringPi

cd wiringPi

./build

cd ~

```

Install the 433Utils tools
--------------------------

This provides the program which lets us read the output from the wireless 433MHz doorbell.  It needs to be patched to work with the doorbell I got so I've left those instructions in too.

```
git clone git://github.com/ninjablocks/433Utils.git

cd 433Utils/RPi_utils

wget http://www.securipi.co.uk/433.zip

tar xvf 433.zip

make

cd /usr/local/bin

sudo ln -s ~/433Utils/RPi_utils/RFSniffer .

cd ~
```

You should now be able to run RFSniffer which should hang until you press the button on your doorbell, at which point it should print out the unique code associated with your bell so that other people's nearby wireless bells won't set yours off.  Make a note of this number as you'll need it in a minute.

Install the Perl Date::Calc module
----------------------------------

We need Date::Calc to calculate whether particular date ranges are valid within the application

```
sudo apt-get install libdate-calc-perl
```

Clone the latest RaspbellyPi code
---------------------------------

Download the latest versions of the RaspbellyPi code using:

```
git clone https://github.com/s-andrews/RasbellyPi.git
```

Now move into the directory you just created and edit the file "magic_number.txt".  This will be empty when you first open the program (which means your doorbell will respond to any signal it receives).  Put your magic number from the last step as the only thing in this file and it will then only respond to your bell.

```
cd RasbellyPi

nano magic_number.txt

[Change the number in the file from 0 to your actual magic number]

[Press Control+O]

[Press return]

[Press Control+X]
```

