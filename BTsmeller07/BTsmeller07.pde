// - - - - - - - - - - - - - - - - - - - - - - - 
// BTsmeller03
// Bluetooth As Sensor Concept
// SCOTT SULLIVAN
// - - - - - - - - - - - - - - - - - - - - - - -

// ** Requires Android API, Java, and the Ketai Library **

// FEATURES TO ADD
// On-phone storage

import android.content.Intent;
import android.os.Bundle;
import java.util.Date;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import ketai.sensors.*;
import ketai.data.*;

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

double longitude, latitude, altitude;
float flat, flon;
KetaiLocation location;

long dbCount;

//SQL
KetaiSQLite db;
String CREATE_DB_SQL = "CREATE TABLE data ( foundTime LONG PRIMARY KEY, MAC STRING NOT NULL, Name STRING NOT NULL, flat FLOAT NOT NULL, flon FLOAT NOT NULL);";

//setup 
void setup() {   
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
  
  //SQL setup
  db = new KetaiSQLite(this);
  
  //check if there's a DB
   //lets make our table if it is the first time we're running 
  if ( db.connect() )
  {
    // for initial app launch there are no tables so we make one
    if (db.tableExists("data")){
      addOldData();
    } else {
      db.execute(CREATE_DB_SQL);
    }
  }
}

// draw loop
void draw() {
  pullTime();
  
  // look for location
  if(location == null)
    location = new KetaiLocation(this);
    


  if (isConfiguring)
  {
    ArrayList<String> names;
    background(0);
    names = bt.getDiscoveredDeviceNames();

    info = "\n";
    foundDevices = "\n";
    names = bt.getDiscoveredDeviceNames();



    

    //listen for devices and list them with their MAC addresses
    for (int i=0; i < names.size(); i++) {
      info += i+1 +". "+bt.lookupAddressByName(names.get(i)) +" (" + names.get(i).toString() + ")" + "\n";
      for (int o = 0; o < devices.length; o ++ ) {
        if (bt.lookupAddressByName(names.get(i)).equals(devices[o].MAC) == false) {
          isThere = false;
        } else {
          isThere = true;
          break;
        }
      }
      if (!isThere) {
        Device d = new Device(currentTime, bt.lookupAddressByName(names.get(i)), names.get(i).toString(), flat, flon);
        devices = (Device[]) append(devices, d);
        recordToDB(currentTime, bt.lookupAddressByName(names.get(i)), names.get(i).toString(), flat, flon);
      }
    }

    for (int i=devices.length-1; i > -1; i--) {
      
      foundDevices += devices[i].name + " - " + devices[i].flat + " / " + devices[i].flon + "\n";
    }
    
  //labels
  textFont(bigBlack);
  text("Current Devices:" + " (" + names.size() + ")", 20, infoYpos);
  textFont(smallBlack);
  text(info, 40, infoYpos + 10);
  textFont(smallBlack);
  
  text("times checked: "+ " (" + timeCount + ") / " + "Current Devices:" + " (" + names.size() + ")", 20, 50);
  }
  fill(0);
  rect( 0, 360, width, height-360);
  fill(255);
  textFont(bigBlack);
  text("Devices in database: " + dbCount, 20, foundYpos);
  textFont(smallBlack);
  text(foundDevices, 40, foundYpos + 10);
  
  
  // location stuff
  if (location.getProvider() == "none")
    text("Location data is unavailable. \n" +
      "Please check your location settings.", 20, height-100);
  else
    //text("Latitude: " + flat + "\n" + 
    //  "Longitude: " + flon + "\n", 
    //  20, height-100);  


  if (currentTime > newTime) {
    discoverNew();
    timeCount++;
    newTime = currentTime + 30000;
  }
}