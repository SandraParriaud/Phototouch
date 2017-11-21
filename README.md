# Phototouch
Phototouch is a touch based photobooth. It will enable you to take two picture of two people and to mix it so that you obtain a new picture : a meeting picture.


### Required materials
1 Arduino uno
1 Ultrasonic sensor 
3 Jumper cables

1 Makey makey
2 Alligator Clips

2 screens

### Required Software
Arduino
Processing


### Capture an image by touching each other
Software used : Processing
(This code works for capturing one picture when two people touch each other)

First, you have to install a library called IPCapture. To do so, go in sketch/import a library/add a library, serach for IPCapture and click on "install".
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


### Mix two pictures together 
