// - - - - DATABASE/LIST FUNCTIONS - - - - //
void logBtDevices() {
  if (isConfiguring) {
    names = bt.getDiscoveredDeviceNames();

    info = "\n";
    foundDevices = "\n";
    names = bt.getDiscoveredDeviceNames();
    leftButton.C = names.size();
    println(namesSizeLabel);

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
  }
}

//add old devices from database to name list
void addOldData() {
  if (db.connect())
  {
    db.query( "SELECT * FROM data");
    int  i = 0;   
    while (db.next ())
    {
      long time = db.getLong("time");
      String MAC = db.getString("MAC");
      String name = db.getString("Name");
      float flat = db.getFloat("flat");
      float flon = db.getFloat("flon");

      Device d = new Device(time, MAC, name, flat, flon);
      devices = (Device[]) append(devices, d);
      i++;
      dbCount = db.getDataCount();
    }
  }
}

// - - - - BLUETOOTH FUNCTIONS - - - - //
// pull new bluetooth devices
void discoverNew() {
  bt.discoverDevices();
}

// enable bluetooth
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

//record new devices to SQL database
void recordToDB(long dbTime, String dbMAC, String dbName, float dbLat, float dbLon) {
  if (db.connect())
  {
    if (!db.execute("INSERT into data (`foundTime`,`MAC`,`Name`,`flat`,`flon`) VALUES ('"+dbTime+"', '"+dbMAC+"', '"+dbName+"', '"+dbLat+"', '"+dbLon+"')"))
      println("Failed to record data!" );
  }
  dbCount = db.getDataCount();
  rightButton.C = int(dbCount);
}

// - - - - LOCATION FUNCTIONS - - - - //
// updates location
void updateLocation() {
  if (location == null)
    location = new KetaiLocation(this);

  if (location.getProvider() == "none")
    text("Location data is unavailable. \n" + "Please check your location settings.", 20, height-100);
}

// gets location data and coverts to floats
void onLocationEvent(double _latitude, double _longitude, double _altitude)
{
  longitude = _longitude;
  latitude = _latitude;
  altitude = _altitude;
  // note on accuracy http://kottke.org/14/09/the-precision-of-latlong-coordinates
  flat = (float)latitude;
  flon = (float)longitude;
  println("lat/lon/alt: " + latitude + "/" + longitude + "/" + altitude);
}

// - - - - TIME FUNCTIONS - - - - //
// update time
void pullTime() {
  timeString = year() + "|" + month() + "|" + day() + "|" + hour() + "|" + minute() + "|" + second();

  java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy|MM|dd|hh|mm|ss");
  try {
    time = sdf.parse(timeString);
  } 
  catch(Exception e) {
    println("error parsing date" + e);
  }

  currentTime = time.getTime();
}

// checks if it's been 30 seconds since the last time it's checked for new devices
void resetTimer() { 
  if (currentTime > newTime) {
    discoverNew();
    timeCount++;
    newTime = currentTime + 30000;
  }
}

// - - - - OBJECTS - - - - //
// device object
class Device {
  String MAC;
  String name;
  long time;
  float flon;
  float flat;

  Device(long tempTime, String tempMAC, String tempName, float tempLat, float tempLon) {
    MAC = tempMAC;
    name = tempName;
    time = tempTime;
    flat = tempLat;
    flon = tempLon;
  }
}