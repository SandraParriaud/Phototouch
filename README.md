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
Software used : Processing <br/>
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
```
To save the capture you've juste made in a file
```javascript
void keyPressed() {
  saveFrame("capture.png");
}          
```



### Warmer the color of the screen as you come closer from the ultrasonic sensor
Software used : Arduino + Processing

Arduino connectings 

#### In Arduino <br/>
First enter the pin number of the sensor's ouput
```javascript
const int pingPin = 7;
```
Then, initialize serial communication
```javascript
void setup() {
  Serial.begin(9600);
}
```
Establish variables for duration of the ping, and the distance result in centimeters
```javascript
void loop() {
  long duration, cm;
```
The PING))) is triggered by a HIGH pulse of 2 or more microseconds. Give a short LOW pulse beforehand to ensure a clean HIGH pulse
```javascript
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);
```
The same pin is used to read the signal from the PING : a HIGH pulse whose duration is the time (in microseconds) from the sending of the ping to the reception of its echo off of an object.
```javascript
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);
```
Convert the time into a distance and print it
```javascript
  cm = microsecondsToCentimeters(duration);

  Serial.print(cm);
  Serial.print('\n');

  delay(10);
}
```
 The speed of sound is 340 m/s or 29 microseconds per centimeter. The ping travels out and back, so to find the distance of the object we take half of the distance travelled.
```javascript
long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
}
```

#### In Processing
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

Now we are going to mix two pictures together. The result looks like that

First, you create two image variables
```javascript
PImage img0;
PImage img1;
```
Then, you create a variables that will correpond to the number of crops you want to make. <br/>
You create another variable which will be a bi-dimensional table. You will store the number of crops (nbCrops) in lines and create 4 column in order to sotre 4 values per line. Each line of the table will correspond to one crop. <br/>
Finally, you create another table (one dimensional this time) in which you will store all the crops you make.
```javascript
int nbCrops = 10;
int r[][] = new int[nbCrops][4];
PImage imgCrops[] = new PImage[nbCrops];
```

In the set up function, you define the size of the sketch (which should be the side of your camera capture), and call the two images you want to mix.
```javascript
void setup () {
  size(640, 480);
  img0 = loadImage("Zoe.jpg");
  img1 = loadImage("Elodie.jpg");
```
You should switch to HSB color mode in order to tint your picture more easyly.
```javascript
  colorMode(HSB, 100);
```
Then, we are going to define all the crops we want to make in Elodie.jpg picture. To make a crop, you have to define where it begins in x and y, and its width and height. That's why we have 4 column in our table. <br/>
We are going to create a loop which will execute itself as long as the number of crops we defined in the set up (nbCrops) is not reach. <br/>
This loop stores each value of the crop in a line of the table. <br/>
The fisrt column r[i][0] correspond to the beginning of the crop on the x axe. <br/>
The second column r[i][1] correspond to the beginning of the crop on the y axe. <br/>
The third column r[i][2] correspond to the width of the crop. <br/>
The fourth column r[i][3] correspond to the height of the crop. 
```javascript
  for (int i = 0; i < nbCrops; i++) {
    r[i][0] = int(random(0, width));
    r[i][1] = int(random(0, height));
    r[i][2] = int(random(0, 300));
    r[i][3] = int(random(0, 200));
  }
```
We've just finished the set up function. Now let's start the draw function ! <br/>
We first call Zoe picture (img0) and place it on (0;0) coordinates.
```javascript
void draw () {
  image(img0, 0, 0);
```

Then, we are going to make all the crops we've just defined before. To do that, we used a function called "get". This function allows us to get a section of the display window by specifying x, y, width and height parameters. <br/>
To make the crops, we create a loop which will execute itself as long as the number of crops we defined in the set up (nbCrops) is not reach. This loop get the x, y, width and height value of the crop we defined in the set up and stores this crop in the table called "imgCrops".
```javascript
  for (int i = 0; i < nbCrops; i++) {
    imgCrops[i] = get(r[i][0], r[i][1], r[i][2], r[i][3]);
  }
  image(img1, 0, 0);

```
We are going to tint the picture of Zoe so that the picture color corresponds to the color of the phototouch screen when Elodie and Zoe touch each other. Therefore, we draw a rectangle whiwh match the size of the display window and fill it with an orange color which is 50% transparent. This rectangle hasn't any stroke.
```javascript
  fill(6, 97, 96, 50);
  rect(0,0,width,height);
  noFill();
  noStroke();
```
To finish, we create a final loop which will show all the crops we made. <br/>
This loop will execute itself as long as the number of crops we defined in the set up (nbCrops) is not reach. <br/>
It calls the crops stored in the imgCrops table and display them on r[i][0] in x and on r[i][1]) in y so that the crop made on Elodie picture appears at the same place on Zoe picture. <br/>
Then we draw color rectangles which corresponds to the crops so that the picture color corresponds to the color of the phototouch screen when Elodie and Zoe touch each other.
```javascript
  for (int i = 0; i < nbCrops; i++) {
    image(imgCrops[i], r[i][0], r[i][1]);
    fill(2, 93, 94, 60);
    rect(r[i][0], r[i][1], r[i][2], r[i][3]);
    noFill();
  }
```
And that's all ! You see, it's not so difficult ;)

