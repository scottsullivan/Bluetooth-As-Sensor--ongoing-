void screenOne(){
  textFont(bigBlack);
  text("Current Devices:" + " (" + names.size() + ")", 20, infoYpos);
  textFont(smallBlack);
  text(info, 40, infoYpos + 10);
  textFont(smallBlack);
  
  text("times checked: "+ " (" + timeCount + ") / " + "Current Devices:" + " (" + names.size() + ")", 20, 50);
  fill(0);
  rect( 0, 360, width, height-360);
  fill(255);
  textFont(bigBlack);
  text("Devices in database: " + dbCount, 20, foundYpos);
  textFont(smallBlack);
  text(foundDevices, 40, foundYpos + 10);
}