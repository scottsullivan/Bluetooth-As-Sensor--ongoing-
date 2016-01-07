// pull new bluetooth devices
void discoverNew() {
  bt.discoverDevices();
}

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

// enable bluetooth
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

void onLocationEvent(double _latitude, double _longitude, double _altitude)
{
  longitude = _longitude;
  latitude = _latitude;
  altitude = _altitude;
  flat = (float)latitude;
  flon = (float)longitude;
  println("lat/lon/alt: " + latitude + "/" + longitude + "/" + altitude);
}

//add old devices from database

void addOldData()
{
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

//record new devices to SQL database
void recordToDB(long dbTime, String dbMAC, String dbName, float dbLat, float dbLon) {
  if (db.connect())
  {
    if (!db.execute("INSERT into data (`foundTime`,`MAC`,`Name`,`flat`,`flon`) VALUES ('"+dbTime+"', '"+dbMAC+"', '"+dbName+"', '"+dbLat+"', '"+dbLon+"')"))
      println("Failed to record data!" );
  }
  dbCount = db.getDataCount();
}