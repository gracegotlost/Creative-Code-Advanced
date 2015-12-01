#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    // DISPLAY STATUS
    status = "";
    
    // AUDIO INPUT
    
    ofSetVerticalSync(true);
    ofSetCircleResolution(80);
    ofBackground(54, 54, 54);
    
    // 0 output channels,
    // 2 input channels
    // 44100 samples per second
    // 256 samples per buffer
    // 4 num buffers (latency)
    
    soundStream.listDevices();
    
    //if you want to set a different device id
    //soundStream.setDeviceID(0); //bear in mind the device id corresponds to all audio devices, including  input-only and output-only devices.
    
    int bufferSize = 256;
    
    
    left.assign(bufferSize, 0.0);
    right.assign(bufferSize, 0.0);
    volHistory.assign(0, 0.0); // Initial volHistory.size()
    
    bufferCounter	= 0;
    smoothedVol     = 0.0;
    scaledVol		= 0.0;
    pScaleVol       = scaledVol;
    
    soundStream.setup(this, 0, 2, 44100, bufferSize, 4);
    soundStream.stop();
    
    isRecording = false;
    isPushBacked = false;
    
    // FONT
    
    font.loadFont("Arial", 100, true, true, true);
    countHistory = 0;
    text = "";
    ofEnableDepthTest();
    
    // SPEECH TO TEXT
    
    ofAddListener(recognizer.speechRecognizedEvent, this, &ofApp::speechRecognized);
    recognizer.initRecognizer();
    recognizer.loadDictionaryFromFile("dictionary.txt");
    recognizer.stopListening();
    
    hasRecognized = false;
    statusWord = "";
    
    // MESHES
    
    front.setMode(OF_PRIMITIVE_LINES);
    front.enableColors();
    front.enableIndices();
    
    hasAdded = false;
    addCountAt = 0.0;
    tempHistory = 0.0;
}

//--------------------------------------------------------------
void ofApp::update(){
    // DISPLAY STATUS
    if (!isRecording) {
        status = "OFF";
    } else {
        status = "ON";
    }
    
    if (!hasRecognized) {
        statusWord = "NO";
    } else {
        statusWord = "YES";
    }
    
    
    // AUDIO INPUT
    if (isRecording) {
        //lets scale the vol up to a 0-1 range
        scaledVol = ofMap(smoothedVol, 0.0, 0.17, 0.0, 1.0, true);
        
        //lets record the volume into an array
        if (scaledVol - pScaleVol < 0.0
            && scaledVol < threshhold && pScaleVol > threshhold
            && !isPushBacked) {
            isPushBacked = true;
            cout << "Can't Input Anymore!" << endl;
        }
        
        if (scaledVol > threshhold && !isPushBacked) {
            volHistory.push_back( scaledVol );
            //cout << "Current Size: " << volHistory.size() << endl;
        }
        
        //if we are bigger the the size we want to record - lets drop the oldest value
        if( volHistory.size() >= 400 ){
            volHistory.erase(volHistory.begin(), volHistory.begin()+1);
        }
        
        pScaleVol = scaledVol;
    }
    
    // FONT
    if (hasRecognized) {
        if (!hasAdded) {
            vector<ofPath>  letters = font.getStringAsPoints(text);
            for (int i = 0; i < letters.size(); i++) {
                ofMesh getfront = letters[i].getTessellation();
                
                // ADD VERTICES
                vector<ofPoint>& frontvertices = getfront.getVertices();
                for (int j = 0; j < frontvertices.size(); j+=50) {
                    
                    // SPLIT MESH
                    for (int k = j; k < j + 50; k+=2) {
                        ofVec3f pos(frontvertices[k].x, frontvertices[k].y, frontvertices[k].z + ofRandom(3));
                        front.addVertex(pos);
                        if (text == "red") {
                            front.addColor(ofColor(ofRandom(100, 255), 0, 0));
                        } else if (text == "green") {
                            front.addColor(ofColor(0, ofRandom(100, 255), 0));
                        } else if (text == "blue") {
                            front.addColor(ofColor(0, 0, ofRandom(100, 255)));
                        } else {
                            front.addColor(ofColor(245, 58, 135));
                        }
                    }
                    meshesFront.push_back(front);
                    front.clear();
                }
                
            }
            
            hasAdded = true;
        }
    }
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    // DISPLAY STATUS
    ofDrawBitmapString("Recording Status: " + status, 0, 20);
    ofDrawBitmapString("Recognition Status: " + statusWord, 0, 40);
    
    // AUDIO INPUT
    
    ofNoFill();
    
    // draw the average volume:
    ofPushStyle();
    ofPushMatrix();
    ofTranslate(300, 150, 0);
    
    ofSetColor(225);
    ofDrawBitmapString("Scaled average vol: " + ofToString(scaledVol * 100.0, 0), 4, 18);
    ofRect(0, 0, 400, 400);
    
    ofSetColor(245, 58, 135);
    ofFill();
    //ofCircle(200, 200, scaledVol * 180.0f);
    
    //lets draw the volume history as a graph
    if (isRecording) {
        ofBeginShape();
        for (unsigned int i = 0; i < volHistory.size(); i++){
            if( i == 0 ) ofVertex(i, 400);
            
            ofVertex(i, 400 - volHistory[i] * 70);
            
            if( i == volHistory.size() -1 ) ofVertex(i, 400);
        }
        ofEndShape(false);
    }
    
    ofPopMatrix();
    ofPopStyle();
    
    // DRAW FONT
    if (!isRecording && volHistory.size() != 0
        && hasRecognized) {
        //cout << "Mesh Size: " << meshesFront.size() << endl;
        
        // WAVE
        if(ofGetElapsedTimef() > addCountAt){
            tempHistory = (tempHistory + 1)%volHistory.size();
            
            addCountAt = ofGetElapsedTimef() + volHistory.size() * 0.001;
        }
        
        for (unsigned int i = 0; i < meshesFront.size(); i++) {
            float scale = meshesFront.size()/400.0;
            
            // DRAW MESH
            ofPushStyle();
            ofPushMatrix();
            
            ofTranslate(300, 350, 0);
            ofScale(1, volHistory[countHistory] * 2.0);
            
            meshesFront[i].draw();
            
            ofPopMatrix();
            ofPopStyle();
            countHistory = (countHistory + 1)%volHistory.size();
        }
        countHistory = tempHistory;
    }
    
}

//--------------------------------------------------------------
void ofApp::speechRecognized(string & wordRecognized)
{
    cout << wordRecognized << endl;
    text = wordRecognized;
    hasRecognized = true;
}

//--------------------------------------------------------------
void ofApp::audioIn(float * input, int bufferSize, int nChannels){
    
    float curVol = 0.0;
    
    // samples are "interleaved"
    int numCounted = 0;
    
    //lets go through each sample and calculate the root mean square which is a rough way to calculate volume
    for (int i = 0; i < bufferSize; i++){
        left[i]		= input[i*2]*0.5;
        right[i]	= input[i*2+1]*0.5;
        
        curVol += left[i] * left[i];
        curVol += right[i] * right[i];
        numCounted+=2;
    }
    
    //this is how we get the mean of rms :)
    curVol /= (float)numCounted;
    
    //this is how we get the root of rms :)
    curVol = sqrt( curVol );
    
    smoothedVol *= 0.93;
    smoothedVol += 0.07 * curVol;
    
    bufferCounter++;
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if (key == OF_KEY_RETURN) {
        isRecording = !isRecording;
    }
    
    if( isRecording ){
        soundStream.start();
        recognizer.startListening();
        
        // INIT
        volHistory.clear();
        hasRecognized = false;
        meshesFront.clear();
        front.clear();
        hasAdded = false;
        
    } else {
        soundStream.stop();
        recognizer.stopListening();
        
        // INIT
        
        smoothedVol = 0.0;
        scaledVol = 0.0;
        pScaleVol = 0.0;
        isPushBacked = false;
        addCountAt = ofGetElapsedTimef();
    }
    
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 
    
}
