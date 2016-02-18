/**
 * Background Subtraction 
 * by Golan Levin. 
 *
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 https://github.com/toto3/ProjetMolinari.git
 
 todo:
 -filtre passe bas pour stabiliser le changement de couleur des bandes
 -détecteur de stabilité afin de prendre des image de fond quand y a personne devant la cam
 
 */


import processing.video.*;

import java.net.*;

int numPixels;
int[] backgroundPixels;
Capture video;
SimpleThread thread1;

boolean ModeTest=true;
String leTemps;

//pixcel entrale 153920
color pointCentrale;
color pointHaut;

color[] tableau = new color[11];

color[] RougePrec = new color[11];
color[] VertPrec = new color[11];
color[] BleuPrec = new color[11];

int row=640*240;
int largeurBande=60;
PImage img;
boolean prendrePhoto=true;//on pren un image au démarrage du programme


//XXXXXXXXXXXXXXXXXXXX SETUP
void setup() {
  size(640, 480); //640
  //fullScreen();
  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video= new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    video=new Capture(this, width, height, cameras[0], 30);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    video.start();
  }


  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();

  thread1 = new SimpleThread(10000, "a");
  thread1.start();

  RougePrec[0]=0;
  RougePrec[4]=0;
  RougePrec[5]=0;
  RougePrec[6]=0;
  RougePrec[7]=0;
  RougePrec[8]=0;
  RougePrec[9]=0;
}


//XXXXXXXXXXXXXXXXX  DRAW 

void draw() {
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    int diffR = 0;
    int diffG =0;
    int diffB = 0;

    int ColR = 0;
    int ColG =0;
    int ColB = 0;

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


      //test de pixelization
      //fill(color(diffR, diffG, diffB));
      //noStroke();
      //ellipse(int(width/2)-0, int(height/2)-0, 3, 3);
      ColR=diffR;
      ColG=diffG;
      ColB=diffB;

      switch(i)
      {
        case (640*240)+29: 
        tableau[0]=color(ColR, ColG, ColB);
        break;
        case (640*240)+29*2: 
        tableau[1]=color(ColR, ColG, ColB); 
        break;
        case (640*240)+29*3: 
        tableau[2]=color(ColR, ColG, ColB); 
        break;
        case (640*240)+29*4: 
        tableau[3]=color(ColR, ColG, ColB); 
        break;
        case (640*240)+29*5: 
        if (abs( RougePrec[4]-ColR)>15) 
        {
          tableau[4]=color(ColR, ColG, ColB);
        }
        RougePrec[4]=ColR;
        VertPrec[4]=ColG;
        BleuPrec[4]=ColB;
        break;
        case (640*240)+29*6: 
        println(RougePrec[5]+"::::"+ColR+"  (" +(RougePrec[5]-ColR) );
        if (abs( RougePrec[5]-ColR)>15) 
        {
          tableau[5]=color(ColR, ColG, ColB);
        }
        RougePrec[5]=ColR;
        VertPrec[5]=ColG;
        BleuPrec[5]=ColB;
        break;

        case (640*240)+29*7:
        if (abs( RougePrec[6]-ColR)>15) 
        {
          tableau[6]=color(ColR, ColG, ColB);
        }
        RougePrec[6]=ColR;
        VertPrec[6]=ColG;
        BleuPrec[6]=ColB;
        break;
        case (640*240)+29*8: 
        if (abs( RougePrec[7]-ColR)>15) 
        {
          tableau[7]=color(ColR, ColG, ColB);
        }
        RougePrec[7]=ColR;
        VertPrec[7]=ColG;
        BleuPrec[7]=ColB;
        break;
        case (640*240)+29*9:
        if (abs( RougePrec[8]-ColR)>15) 
        {
          tableau[8]=color(ColR, ColG, ColB);
        }
        RougePrec[8]=ColR;
        VertPrec[8]=ColG;
        BleuPrec[8]=ColB;
        break;
        case (640*240)+29*10: 
        if (abs( RougePrec[9]-ColR)>15) 
        {
          tableau[9]=color(ColR, ColG, ColB);
        }
        RougePrec[9]=ColR;
        VertPrec[9]=ColG;
        BleuPrec[9]=ColB;
        break;
        case (640*240)+29*11: 
        tableau[10]=color(ColR, ColG, ColB); 
        break;
      }//fin switch
      
      if (i==153920)//if(i==int((width/2)*(height/2))*2+(width/2)   )//num de la pixel du milieu de l'écran
      {
        ColR=diffR;
        ColG=diffG;
        ColB=diffB;
        pointCentrale=color(ColR, ColG, ColB);
      }
      if (i==13920)//if(i==int((width/2)*(height/2))*2+(width/2)   )//num de la pixel du milieu de l'écran
      {
        ColR=diffR;
        ColG=diffG;
        ColB=diffB;
        pointHaut=color(ColR, ColG, ColB);
      }


      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      pixels[i] = color(diffR, diffG, diffB);

      if ((i==153920)||(i==13920)) //if(i==int( (width/2)*(height/2))*2+(width/2)   )//num de la pixel du milieu de l'écran
      {
        pixels[i] = color(0, 0, 0);
        //println(i);
        //println(numPixels);
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
      
    }//fin de la loop sur les pixels  :: for (int i = 0; i < numPixels; i++) 
    updatePixels(); // Notify that the pixels[] array has changed
    
    
    fill(pointCentrale);
    // rect(5, 5, 425, 25);
    noStroke();
    //rect(int(width/2)-5, int(height/2)-5, 10, 10);
    ellipse(int(width/2)-0, int(height/2)-0, 20, 20);
    //481


    fill(pointHaut);
    ellipse(481, 25, 20, 20);

    if (prendrePhoto)
    {
      prendrePhoto=false;
      // save("fond.tif");
      saveFrame("fond.tif");
      delay(3000);
      img = loadImage("fond.tif");
    } else image(img, 0, 0);
    //
    for (int k=0; k<11; k++)
    {
      fill(tableau[k]);
      if ((k>3)&&(k<10))
      {
        rect(58*k, 50, 58, height-100);
        //stroke(123);
        ellipse((58*k)+29, 240, 20, 20);
      }
    }




    //println(presenceSum+" diffR:"+diffR+" diffG:"+diffG+"  diffB:"+diffB); // Print out the total amount of movement
    //println(""+hour()+""+year()+"-"+rajouteZero(month())+"-"+rajouteZero(day()));

    if (thread1.available()) {
      thread1.setLog(""+minute()+"."+second());
      thread1.setRouge(int(ColR));
      thread1.setVert(int(ColG));
      thread1.setBleu(int(ColB));
      //thread1.setMoment(""+millis());
      thread1.setJour(""+year()+"-"+rajouteZero(month())+"-"+rajouteZero(day()));
      thread1.setHeure(""+rajouteZero(hour())+":"+rajouteZero(minute()));
      //thread1.setLog(""+chiffreA+":"+chiffreB+"...("+year()+"-"+month()+"-"+day()+")"+hour()+":"+minute()+".."+millis()+"."+(millis()-int(duree)));
      //thread1.setLog(""+year()+""+month()+""+day()+""+hour()+""+minute()+"."+millis());
    }
  }//if videoavalable
  delay(30);
}



// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame's pixels into it.
void keyPressed() {
  //video.loadPixels();
  //arraycopy(video.pixels, backgroundPixels);

  prendrePhoto=true;
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
    //String[] php = loadStrings("musicpi.php?vala="+count+"&valb=88");
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
  //      String[] php = loadStrings("http:/pi.php?vala=" + compteurA  + "&valb="+compteurB );
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
      } else {

        if (!ModeTest)
        { 
          // String[] php = loadStrings("  &log="+log+"&temps="+temps+"&moment="+moment+"&chiffA="+chiffA+"&chiffB="+chiffB+"&cur="+cur+"&jour="+jour+"&heure="+heure+"");
          //http://localhost:8888/Monilari/monilari.php?rouge=11&vert=22&bleu=33//
          String[] php = loadStrings("http://localhost:8888/Monilari/monilari.php?rouge="+rouge+"&vert="+vert+"&bleu="+bleu+"&jour="+jour+"&heure="+heure);
        }
        println("http://localhost:8888/Monilari/monilari.php?rouge="+rouge+"&vert="+vert+"&bleu="+bleu+"&jour="+jour+"&heure="+heure);
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