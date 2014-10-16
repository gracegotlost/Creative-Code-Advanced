/*Midterm Project - Grace - Hear Me*/
import SimpleOpenNI.*;
import ddf.minim.*;

/*SOUND-------------------------------------------------------------------*/
// create sound object
AudioPlayer player;
AudioPlayer player2;
Minim minim;

/*KINECT-------------------------------------------------------------------*/
// create kinect object
SimpleOpenNI  kinect;
// image storage from kinect
PImage kinectDepth;
// int of each user being  tracked
int[] userID;
// user colors
color[] userColor = new color[] { 
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), 
  color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)
};

// position of head to draw circle
PVector headPosition = new PVector();
// turn headPosition into scalar form
float distanceScalar;
// diameter of head drawn in pixels
float headSize = 200;

// threshold of level of confidence
float confidenceLevel = 0.5;
// the current confidence level that the kinect is tracking
float confidence;
// vector of tracked head for confidence checking
PVector confidenceVector = new PVector();

/*BODY-------------------------------------------------------------------*/
PVector[] bodyPosition = new PVector[9]; 
float pos1;
float pos2;
float zoom1;
float zoom2;
/*
bodyPosition[0]: RIGHT HAND
 bodyPosition[1]: LEFT HAND
 bodyPosition[2]: RIGHT FOOT
 bodyPosition[3]: LEFT FOOT
 bodyPosition[4]: RIGHT ELBOW
 bodyPosition[5]: LEFT ELBOW
 bodyPosition[6]: RIGHT KNEE
 bodyPosition[7]: LEFT KNEE
 bodyPosition[8]: HEAD
 */

/*SETUP-------------------------------------------------------------------*/
void setup() {

  size(800, 600);

  //KINECT
  // start a new kinect object
  kinect = new SimpleOpenNI(this);
  // enable depth sensor 
  kinect.enableDepth();
  // enable skeleton generation for all joints
  kinect.enableUser();

  // BODY
  for (int i = 0; i < 9; i++) {
    bodyPosition[i] = new PVector();
  }

  //SOUND
  minim = new Minim(this);
  player = minim.loadFile("Like A Rolling Stone.mp3", 2048);
  player2 = minim.loadFile("Piano.mp3", 2048);
}

/*DRAW-------------------------------------------------------------------*/
void draw() {

  background(0);
  // update the camera
  kinect.update();
  // get all user IDs of tracked users
  userID = kinect.getUsers();

  // loop through each user to see if tracking
  for (int i = 0; i < userID.length; i++)
  {
    // if Kinect is tracking certain user then get joint vectors
    if (kinect.isTrackingSkeleton(userID[i]))
    {
      // get confidence level that Kinect is tracking head
      confidence = kinect.getJointPositionSkeleton(userID[i], SimpleOpenNI.SKEL_HEAD, confidenceVector);
      // if confidence of tracking is beyond threshold, then track user
      if (confidence > confidenceLevel)
      {
        getPosition(userID[i]);
        //drawSkeleton(userID[i]);
        println(bodyPosition[1]);

        pos1 = map(bodyPosition[8].x;
        pos2 = map(bodyPosition[8].x;
        zoom1 = map(bodyPosition[1].y;
        zoom2 = map(bodyPosition[0].y;
        player.setPan(pos1, 100, 400, 1.0, -1.0));
        player2.setPan(pos2, 200, 500, -1.0, 1.0));
        player.setGain(zoom1, 0, 400, 1.0, -1.0));
        player2.setGain(zoom2, 0, 400, 1.0, -1.0));
        
        if (!player.isPlaying()) {
          player.rewind();
          player.play();
        }
        
        if (!player2.isPlaying()) {
          player2.rewind();
          player2.play();
        }
      }
    }
    else {
      player.close();
      player2.close();
    }
  }
}

void getPosition(int userId) {
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, bodyPosition[0]);
  kinect.convertRealWorldToProjective(bodyPosition[0], bodyPosition[0]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, bodyPosition[1]);
  kinect.convertRealWorldToProjective(bodyPosition[1], bodyPosition[1]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, bodyPosition[2]);
  kinect.convertRealWorldToProjective(bodyPosition[2], bodyPosition[2]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, bodyPosition[3]);
  kinect.convertRealWorldToProjective(bodyPosition[3], bodyPosition[3]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, bodyPosition[4]);
  kinect.convertRealWorldToProjective(bodyPosition[4], bodyPosition[4]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, bodyPosition[5]);
  kinect.convertRealWorldToProjective(bodyPosition[5], bodyPosition[5]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, bodyPosition[6]);
  kinect.convertRealWorldToProjective(bodyPosition[6], bodyPosition[6]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, bodyPosition[7]);
  kinect.convertRealWorldToProjective(bodyPosition[7], bodyPosition[7]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, bodyPosition[8]);
  kinect.convertRealWorldToProjective(bodyPosition[8], bodyPosition[8]);
}

