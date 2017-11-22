import processing.serial.*;
Serial myPort;
float val;

float distance = 500.0;
float targetDistance;

float h;

int framePerRange = 5;
int currentFrameCount = 0;
int distances = 0;
float easing = 0.05;

void setup () {
  size (640, 480);
  println(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}

void draw () {

  float dx = targetDistance - distance;
  println("from "+ distance+ " to "+targetDistance+" by dx: "+dx);
  distance += dx * easing;

  float h = map(min(distance, 100), 0, 200, 0, 130);
  colorMode(HSB, 100);
  
  
  background(h, 80, 100);
  //h = map(mouseX, 0, 640, 70, 0);
  //  println(val);
}  

void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n');
  if (message != null && message != "") {
    currentFrameCount++;

    if (currentFrameCount >= framePerRange) {
      currentFrameCount = 0;
      targetDistance = int(distances/framePerRange);
      distances = 0;
    } else {
      distances = distances + int(trim(message));
    }

    //  distance = int(trim(message));




    if (float(message) > 250) {
      //  println("VOILA");
    }
  }
}