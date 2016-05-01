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

Install espeak
-----------------

This is the text to speech application used to read the date

```
sudo apt-get install espeak
```

Some of the espeak dependencies are not signed in raspbian so you'll need to accept an extra warning when installing them


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

If you can't get to this repository there's also a github mirror:

```
git clone https://github.com/WiringPi/WiringPi.git

cd WiringPi

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

Add the script to the init system
---------------------------------

We have included an init script so you can start the rasbellypi program when the machine boots.  To install this do the following:

```
cd /etc/init.d/

sudo ln -s /home/pi/RasbellyPi/init/rasbellypi .

sudo update-rc.d rasbellypi defaults

```

[Optional] Install the cron job
-------------------------------

If you want your doorbell to do something interesting on April 1st then you'll need to install the cron script in the cron directory into your users crontab.

```
cd ~/RasbellyPi/cron
crontab < april_fool.cron
```

[Optional] Extend your root partition
-------------------------------------

When you create your image you will only use the amount of space the image occupies on the SD card meaning you will have unused space available to you.  To reclaim this space you need to run:

```
sudo raspi-config
```

..and then select option 1 (expand filesystem).  The filesystem will be expanded on the next boot.


Add your custom ringtones
-------------------------
The system will come with a limited number of standard doorbell type sounds, but the point of this system is to be able to create your own custom sounds.

To do this you need to create a new folder inside the Sounds (not Sound) folder of the RasbellyPi installation.  Into this folder you can save mp3 or wav files for the sounds you want to use.  If you want these to appy to a specific date then copy the time_limit.txt eample file from the Sounds directory into the folder you just created (keep the same name), and edit it to reflect the date range you want to use.  The format is pretty self-explanatory.  At the moment we don't support dates which span the new year, so you'll need to make 2 folders if you want to do this.

The example below would make these sounds play only on 4th July

```
start_day = 14
start_month = 4
end_day = 15
end_month = 4
```
