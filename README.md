kevin-beacon
============

Proof-of-concept fun with iBeacons. A prototype by Josh Lieberman ([@JALsnipe](https://github.com/JALsnipe)) for [Applico, Inc.](http://www.applicoinc.com/)

Following this guide:
http://developer.radiusnetworks.com/2013/10/09/how-to-make-an-ibeacon-out-of-a-raspberry-pi.html

What's in this package?
=======================
My sample app BeaconReceiver.

The source code and binary for [BeaconEmitter](https://github.com/lgaches/BeaconEmitter), a tool that allows you to turn any Bluetooth-enabled Mac into an iBeacon emitter.

Amir's ([@abokhari](https://github.com/abokhari)) valet broadcasting iPad app, ValetHUB.

Installing NOOBS
================
http://www.raspberrypi.org/help/noobs-setup/

Download NOOBS “Offline and network install” from here: http://www.raspberrypi.org/downloads/

Download SD card formatter: https://www.sdcard.org/downloads/formatter_4/

Install and run formatting tool

Select “Overwrite Format”

Click Format

Extract and copy everything from the NOOBS zip to the SD card 

Insert SD card into Pi and connect power supply

Display setup
=============
Pi defaults to HDMI by default.  If you turn on the Pi and don't see any video output, try pressing one of these keys on the keyboard depending on your video output:

1. HDMI mode -­ this is the default display mode.

2. HDMI safe mode - select this mode if you are using the HDMI connector and cannot see anything on screen when the Pi has booted.

3. Composite PAL mode -­ select either this mode or composite NTSC mode if you are using the composite RCA video connector. You will probably never use this setting in the United States.

4. Composite NTSC mode

Installation
============
Connect an HDMI monitor, ethernet cable, keyboard, mouse, and SD card, and power up the device by connecting a USB power cable.

Wait for “Please wait while NOOBS initializes”

Select the Raspbian OS and click Install

When finished, hit ok.  The Pi will reboot to the config tool (rasp-config)

Option selections for the config tool:

1. is already expanded for you, so ignore it

2. Change the password if you wish.  I kept my device on the default password

3. I specified that the device boot to the Console

4. Internationalization

  1. Change locale en_us.stf-8

  2. Timezone - Eastern

  3. I kept as generic 105 key (Intel) PC

    1. English

    2. Default or no AltGr key depending on your keyboard (I selected no AltGr)

    3. No compose key

    4. Control-Alt-Backspace does not terminate the X server

I didn’t touch anything else and just hit Finish and reboot.

Login
=====
username: pi

password: raspberry

Shell
=====
1. Make sure you have an internet connection

```
$ ping www.google.com
PING www.google.com (74.125.228.116): 56 data bytes
64 bytes from 74.125.228.116: icmp_seq=0 ttl=55 time=34.267 ms
64 bytes from 74.125.228.116: icmp_seq=1 ttl=55 time=30.908 ms
```

If you can't ping the server, something is wrong with the internet.  Check to make sure your cable works, is plugged into the wall, router has power, etc.  DHCP should configure automatically.

2. (Optional) SSH into your Pi

  1. ```sudo apt-get install ssh```
  2. start the service: ```sudo /etc/init.d/ssh start```
  3. get the Pi’s IP (look for inet addr under eth0): ```ifconfig```
  4. SSH in from your computer's terminal: ```ssh pi@192.168.1.122```

When prompted, use the password “raspberry”

3. Install build packages

```$ sudo apt-get install libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev```

4. Download and uncompress BlueZ

This is the the official Bluetooth stack for Linux and the 5.x series has introduced Bluetooth LE support.

```
$ sudo wget www.kernel.org/pub/linux/bluetooth/bluez-5.8.tar.xz
$ sudo unxz bluez-5.8.tar.xz
$ sudo tar xvf bluez-5.8.tar
$ cd bluez-5.8
```

5. Configure and Make BlueZ

NOTE: ```make``` will take a little while, get some coffee or something.

```
$ sudo ./configure --disable-systemd
$ sudo make
$ sudo make install
```

6. Configure Bluetooth Dongle

With your Bluetooth dongle plugged in, running the following command will give details about the device:

```$ hciconfig```

The output should look something like this:

```
hci0:   Type: BR/EDR  Bus: USB
         BD Address: 00:01:0A:39:D4:06  ACL MTU: 1021:8  SCO MTU: 64:1
         DOWN
         RX bytes:1000 acl:0 sco:0 events:47 errors:0
         TX bytes:1072 acl:0 sco:0 commands:47 errors:0
```
This indicates the device is in a down state. Run the following command to bring it up:

```$ sudo hciconfig hci0 up```

Now it should look like:

```
$ hciconfig
hci0:   Type: BR/EDR  Bus: USB
         BD Address: 00:02:72:3F:4D:60  ACL MTU: 1021:8  SCO MTU: 64:1
         UP RUNNING
         RX bytes:1000 acl:0 sco:0 events:47 errors:0
         TX bytes:1072 acl:0 sco:0 commands:47 errors:0
```

Next, execute the following example command to configure the advertising data to be sent by the iBeacon:

```
$ sudo hcitool -i hci0 cmd 0x08 0x0008 1e 02 01 1a 1a ff 4c 00 02 15 e2 c5 6d b5 df fb 48 d2 b0 60 d0 f5 a7 10 96 e0 00 00 00 00 c5 00
```

The setting in this example corresponds to an iBeacon broadcasting Profile UUID E2C56DB5-DFFB-48D2-B060-D0F5A71096E0 with a major of 0 and a minor of 0.

7. Enable Advertising

Use the following command to activate advertising on the dongle. This will allow the device to be detected and recognized as an iBeacon:

```
sudo hciconfig hci0 leadv
```

Then immediately run this command to stop the Bluetooth dongle from looking for devices to pair with:
```
$ sudo hciconfig hci0 noscan
```

Grab this app and verify your Pi is broadcasting correctly:

https://itunes.apple.com/us/app/ibeacon-locate/id738709014

You can then disable advertising using the following command, and see the device stop emitting:

```
$ sudo hciconfig hci0 noleadv
```

It may take around 60 seconds after bringing the emitter down for any iDevice to recognize the emitter is down or has "left the region."

Troubleshooting
===============
This guide has a lot of improvments and revisions on the Radius guide:

http://smittytone.wordpress.com/2013/12/02/how-to-build-your-own-apple-ibeacon-with-a-raspberry-pi/

UUID Generator:

http://www.famkruithof.net/uuid/uuidgen
