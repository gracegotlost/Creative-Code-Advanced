#pragma once

#include "ofMain.h"
#include "ofxSpeech.h"

class ofApp : public ofBaseApp{
    
public:
    void setup();
    void update();
    void draw();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y );
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    // DISPLAY STATUS
    string status;
    
    // AUDIO INPUT
    void audioIn(float * input, int bufferSize, int nChannels);
    
    vector <float> left;
    vector <float> right;
    vector <float> volHistory;
    
    int bufferCounter;
    
    float smoothedVol;
    float scaledVol;
    float pScaleVol;
    
    ofSoundStream soundStream;
    
    bool isRecording;
    bool isPushBacked;
    const float threshhold = 0.2;
    
    // Font
    ofTrueTypeFont font;
    unsigned int countHistory;
    vector<ofMesh> meshesFront;
    string text;
    
    // SPEECH TO TEXT
    void speechRecognized(string & wordRecognized);
    
    ofxSpeechRecognizer         recognizer;
    
    bool hasRecognized;
    string statusWord;
    
    // MESHES
    ofMesh front;
    
    bool hasAdded;
    float addCountAt;
    int tempHistory;
    
};
