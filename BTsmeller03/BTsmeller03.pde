// - - - - - - - - - - - - - - - - - - - - - - - 
// BTsmeller03
// Bluetooth As Sensor Concept
// SCOTT SULLIVAN
// - - - - - - - - - - - - - - - - - - - - - - -

// ** Requires Android API, Java, and the Ketai Library **

// FEATURES TO ADD
// Location data
// On-phone storage

import android.content.Intent;
import android.os.Bundle;
import java.util.Date;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

// fonts
PFont bigBlack, smallBlack;

// java time setup
String timeString = year() + "|" + month() + "|" + day() + "|" + hour() + "|" + minute() + "|" + second();
Date time;
long currentTime, oldTime, newTime;
int timeCount;

//ketai bluetooth setup
KetaiBluetooth bt;
String info = "";
String foundDevices = "";
boolean isConfiguring = true;

//counters and logic
ArrayList<String> devicesDiscovered = new ArrayList(); 
Device[] devices = new Device[0];
boolean isThere;
int infoYpos = 100;
int foundYpos = 400;

//setup 
void setup()
{   
  orientation(PORTRAIT);
  background(0);
  stroke(0);
  fill(255);

  //start listening for BT connections
  bt.start();

  // get time and update time
  pullTime();
  newTime = currentTime;

  // load fonts
  bigBlack = loadFont("Roboto-Bold-40.vlw");
  smallBlack = loadFont("Roboto-Medium-30.vlw");
}

// draw loop
void draw() {
  pullTime();

  textFont(bigBlack);

  if (isConfiguring)
  {
    ArrayList<String> names;
    background(0);
    names = bt.getDiscoveredDeviceNames();

    info = "\n";
    foundDevices = "\n";
    names = bt.getDiscoveredDeviceNames();

    text("Current Devices:" + " (" + names.size() + ")", 20, infoYpos);
    fill(0);
    rect( 0, 360, width, height-360);
    fill(255);
    text("Archived Devices:" + " (" + devices.length + ")", 20, foundYpos);

    //listen for devices and list them with their MAC addresses
    for (int i=0; i < names.size(); i++) {
      info += "["+i+"] "+bt.lookupAddressByName(names.get(i)) +" (" + names.get(i).toString() + ")" + "\n";
      for (int o = 0; o < devices.length; o ++ ) {
        if (bt.lookupAddressByName(names.get(i)).equals(devices[o].MAC) == false) {
          isThere = false;
        } else {
          isThere = true;
          break;
        }
      }
      if (!isThere) {
        Device d = new Device(bt.lookupAddressByName(names.get(i)), names.get(i).toString(), currentTime);
        devices = (Device[]) append(devices, d);
      }
    }

    for (int i=devices.length-1; i > -1; i--) {
      foundDevices += "["+i+"] " + devices[i].name + "\n";
    }
  }


  //labels
  textFont(smallBlack);
  text("times checked: " + timeCount, 20, 50);
  //text("time " + timeString, 20, 100);

  text(foundDevices, 40, foundYpos + 10);
  text(info, 40, infoYpos + 10);

  if (currentTime > newTime) {
    discoverNew();
    timeCount++;
    newTime = currentTime + 30000;
  }
}