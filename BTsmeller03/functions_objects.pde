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
  
  Device(String tempMAC, String tempName, long tempTime) {
    MAC = tempMAC;
    name = tempName;
    time = tempTime;
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