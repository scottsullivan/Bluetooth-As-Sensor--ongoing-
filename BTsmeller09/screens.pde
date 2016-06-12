void screenOne() { // current devices
  background(0);
  fill(255);
  textFont(smallBlack);
  text("times checked: "+ " (" + timeCount + ")", 20, 50);
  textFont(bigBlack);
  text("Current Devices:" + " (" + names.size() + ")", 20, infoYpos);
  textFont(smallBlack);
  text(info, 40, infoYpos + 10);
  rightButton.C = int(dbCount);
}

void screenTwo() { // devices in DB
  background(0);
  fill(255);
  textFont(smallBlack);
  text("times checked: "+ " (" + timeCount + ")", 20, 50);
  textFont(bigBlack);
  text("Devices in database: " + dbCount, 20, infoYpos);
  textFont(smallBlack);
  text(foundDevices, 40, infoYpos + 10);
  rightButton.C = int(dbCount);
}

class Button {
  int X;
  int Y;
  int W;
  int H;
  int C;
  String N;
  boolean over;

  Button(int tempX, int tempY, int tempW, int tempH, String tempN, int tempC, boolean tempOver) {
    X = tempX;
    Y = tempY;
    W = tempW;
    H = tempH;
    N = tempN;
    C = tempC;
    over = tempOver;
  }

  void display() {
    textFont(bigBlack);
    textAlign(CENTER, CENTER);

    if (over == true) {
      fill(#5A5A5A); // grey
      rect(X, Y, W, H);
      fill(255);
      text(N + " (" + C + ")", X+(W/2), Y+(H/2));
    } else {
      fill(#262627); // dark grey
      rect(X, Y, W, H);
      fill(255);
      text(N + " (" + C + ")", X+(W/2), Y+(H/2));
    }

    textAlign(LEFT);
    textFont(smallBlack);
  }
}

void mousePressed() {
  if ((mouseX > leftButton.X) && (mouseX < leftButton.X+leftButton.W) && (mouseY > leftButton.Y) && (mouseY < leftButton.Y+leftButton.H)) {
    leftLast = true;
    leftButton.over= true;
    rightButton.over = false;
  }
  if ((mouseX > rightButton.X) && (mouseX < rightButton.X+rightButton.W) && (mouseY > rightButton.Y) && (mouseY < rightButton.Y+rightButton.H)) {
    leftLast = false;
    rightButton.over = true;
    leftButton.over = false;
  }
}

void screenSwitch() {
  if (leftLast) {
    screenOne();
  } else {
    screenTwo();
  }
}