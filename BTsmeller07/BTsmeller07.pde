// - - - - - - - - - - - - - - - - - - - - - - - 
// BTsmeller07
// Bluetooth As Sensor Concept
// SCOTT SULLIVAN
// - - - - - - - - - - - - - - - - - - - - - - -


// - - FEATURES TO ADD - - //
// New Views
//  Buttons etc.
// Logic around behavior
//  First time seen, last time seen
//  Days in a row seen
//  Static location or moving around
// Android stuff
//  Run in background

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
ArrayList<String> names;
Device[] devices = new Device[0];
boolean isThere;
int infoYpos = 100;
int foundYpos = 400;
long dbCount;

double longitude, latitude, altitude;
float flat, flon;
KetaiLocation location;



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


void draw() {
  updateLocation();

  pullTime();
    
  logBtDevices();
  
  screenOne();

  resetTimer();
}