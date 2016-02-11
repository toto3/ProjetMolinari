/**
 * Background Subtraction 
 * by Golan Levin. 
 *
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 */


import processing.video.*;

int numPixels;
int[] backgroundPixels;
Capture video;


void setup() {
  size(640, 480); 
  
  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video= new Capture(this, 640, 480);
   
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
  
   // video = new Capture(this, cameras[0]);
    video=new Capture(this, width, height, cameras[0], 30);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    video.start();
   
  }
  
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  //video = new Capture(this, 160, 120);
  //video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  //video.start();  
  
  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
}

void draw() {
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int presenceSum = 0;
      int diffR = 0;
      int diffG =0;
      int diffB = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      diffR = abs(currR - bkgdR);
      diffG = abs(currG - bkgdG);
      diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      pixels[i] = color(diffR, diffG, diffB);
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    updatePixels(); // Notify that the pixels[] array has changed
    fill(color(diffR, diffG, diffB));
    rect(5,5,425,25);
    println(presenceSum+" diffR:"+diffR+" diffG:"+diffG+"  diffB:"+diffB); // Print out the total amount of movement
  }
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame's pixels into it.
void keyPressed() {
  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
}