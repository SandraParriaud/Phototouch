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