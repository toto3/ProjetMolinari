/**
 * Background Subtraction 
 * by Golan Levin. 
 *
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 */


import processing.video.*;

import java.net.*;

int numPixels;
int[] backgroundPixels;
Capture video;
SimpleThread thread1;

boolean ModeTest=false;


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
   thread1 = new SimpleThread(10000, "a");
  thread1.start();
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
     
     
      if (thread1.available()) {
      thread1.setLog(""+minute()+"."+second());
      thread1.setRouge(int(diffR));
      thread1.setVert(int(diffG));
      thread1.setBleu(int(diffB));
      //thread1.setMoment(""+millis());
      //thread1.setTemps(""+year()+"-"+rajouteZero(month())+"-"+rajouteZero(day()));
      //thread1.setJour(""+year()+""+month()+""+day());
      //thread1.setHeure(""+hour());
      //thread1.setLog(""+chiffreA+":"+chiffreB+"...("+year()+"-"+month()+"-"+day()+")"+hour()+":"+minute()+".."+millis()+"."+(millis()-int(duree)));
      //thread1.setLog(""+year()+""+month()+""+day()+""+hour()+""+minute()+"."+millis());
    }


   }
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame's pixels into it.
void keyPressed() {
  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
}



String rajouteZero(int tmp)
{
  String ret=str(tmp);
  if (ret.length()==1)
  {
    ret="0"+ret;
  }
  return ret;
}

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

class SimpleThread extends Thread {
 
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String id;                 // Thread name
  int count;                 // counter
  int rouge;
  int vert;
  int bleu;
  int rougePrevious;
  int chiffA;
  int chiffB;
  int cur;
  int cB;
  int vertPrevious;
  String temps;
  String moment;
  String log;
  String jour;
  String heure;
   boolean available;
 
  // Constructor, create the thread
  // It is not running by default
  SimpleThread (int w, String s) {
    wait = w;
    running = false;
    id = s;
    rouge=0;
    vert=0;
    bleu=0;
    count = 0;
    vertPrevious=0;
    rougePrevious=0;
    chiffA=0;
    chiffB=0;
    cur=0;
    temps="";
    moment="";
    log="";
    jour="";
    heure="";
  }
 
  int getCount() {
       //String[] php = loadStrings("http://www.mpiigotchi.pascalaudet.com/musicpi.php?vala="+count+"&valb=88");
       //println(count);
    return count;
  }
  
 void setRouge(int _rouge)
  {
    rouge=_rouge;
  }
  void setVert(int _vert)
  {
    vert=_vert;
  }
  
  void setBleu(int _bleu)
  {
    bleu=_bleu;
  }
  void setCb(int cb)
  {
    cB=cb;
  }
  
   void setChiffA(int cha)
  {
    chiffA=cha;
  }
  void setChiffB(int chb)
  {
    chiffB=chb;
  }
  
   void setLog(String l)
  {
    log=l;
  }
  
  void setTemps(String t)
  {
    temps=t;
  }
  void setMoment(String m)
  {
    moment=m;
  }
  void setCur(int cu)
  {
    cur=cu;
  }
  void setJour(String j)
  {
    jour=j;
  }
  void setHeure(String h)
  {
    heure=h;
  }
 
  // Overriding "start()"
  void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }
 
   boolean available() {
    return available;
  }
  
  // We must implement run, this gets triggered by start()
//  void run () {
//    
//      String[] php = loadStrings("http://www.mpiigotchi.pascalaudet.com/musicpi.php?vala=" + compteurA  + "&valb="+compteurB );
//    
//    while (running && count < 10) {
//      println(id + ": " + count);
//      count++;
//      // Ok, let's wait for however long we should wait
//      try {
//        sleep((long)(wait));
//      } catch (Exception e) {
//      }
//    }
//    System.out.println(id + " thread is done!");  // The thread is done when we get to the end of run()
//  }
  
  
    void run () {
      println("dans le run");
    while (running) {
      //tweets = loadStrings("http://www.learningprocessing.com/php/twitter/searchtweets.php?query=%23Processing");
    
      if ((rougePrevious==rouge)&&(vertPrevious==cB))
      {
       
      }else{
          
          if (!ModeTest)
         { 
          // String[] php = loadStrings("  &log="+log+"&temps="+temps+"&moment="+moment+"&chiffA="+chiffA+"&chiffB="+chiffB+"&cur="+cur+"&jour="+jour+"&heure="+heure+"");
          //http://localhost:8888/Monilari/monilari.php?rouge=11&vert=22&bleu=33//
          String[] php = loadStrings("http://localhost:8888/Monilari/monilari.php?rouge="+rouge+"&vert="+vert+"&bleu="+bleu+"");
         }
       
         rougePrevious=rouge;
         vertPrevious=vert;
         
      }      
      // New data is available!
      available = true;
      try {
        // Wait five seconds
        sleep((long)(wait));//50
      } 
      catch (Exception e) {
      }
    }
  }
 
 
  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }
  
  
}