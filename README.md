# Phototouch
Phototouch is a touch based photobooth. It will enable you to take two picture of two people and to mix it so that you obtain a new picture : a meeting picture.


### Required materials
* 1 Arduino uno
* 1 Ultrasonic sensor 
* 3 Jumper cables

* 1 Makey makey
* 2 Alligator Clips

* 2 screens

### Required Software
* Arduino
* Processing


### Capture an image by touching each other
Software used : Processing
(This code works for capturing one picture when two people touch each other)

First, you have to install a library called IPCapture. To do so, go in sketch/import a library/add a library, serach for IPCapture and click on "install".
![](https://github.com/SandraParriaud/Phototouch/blob/master/images/import_library.png)

Then, here is the code
```javascript
import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0, width, height);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);                                                                  
}                          
                  
void keyPressed() {
  saveFrame("capture.png");
}          
```



### Warmer the color of the screen as you come closer from the ultrasonic sensor
Software used : Arduino + Processing

Arduino connectings 

In Arduino
```javascript
// this constant won't change. It's the pin number of the sensor's output:
const int pingPin = 7;

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
}

void loop() {
  // establish variables for duration of the ping, and the distance result
  // in centimeters:
  long duration, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH pulse
  // whose duration is the time (in microseconds) from the sending of the ping
  // to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  cm = microsecondsToCentimeters(duration);

  Serial.print(cm);
  Serial.print('\n');

  delay(10);
}

long microsecondsToCentimeters(long microseconds) {
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the object we
  // take half of the distance travelled.
  return microseconds / 29 / 2;
}
```
In Processing
```javascript
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
```


### Mix two pictures together
Software required : Processing

```javascript
PImage img0;
PImage img1;
int nbCrops = 10;
int r[][] = new int[nbCrops][5];
PImage imgCrops[] = new PImage[nbCrops];

void setup () {
  size(640, 480);
  //frameRate(5);
  img0 = loadImage("Zoe2.jpg");
  img1 = loadImage("Elodie2.jpg");
  
  colorMode(HSB, 100);

  for (int i = 0; i < nbCrops; i++) {
    r[i][0] = int(random(0, width));
    r[i][1] = int(random(0, height));
    r[i][2] = int(random(0, 300));
    r[i][3] = int(random(0, 200));
    r[i][4] = int(random(0, 360));
  }
}

void draw () {
  image(img0, 0, 0);
  
  for (int i = 0; i < nbCrops; i++) {
    imgCrops[i] = get(r[i][0], r[i][1], r[i][2], r[i][3]);
  }
  
  image(img1, 0, 0);
 // tint(0, 64,  120);
  fill(6, 97, 96, 50);
  rect(0,0,width,height);
  noFill();
  
  noStroke();
  
  for (int i = 0; i < nbCrops; i++) {
    image(imgCrops[i], r[i][0], r[i][1]);
    fill(2, 93, 94, 60);
    rect(r[i][0], r[i][1], r[i][2], r[i][3]);
    noFill();
  }

}
```

