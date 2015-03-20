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
    volHistory.assign(800, 0.5); // Initial volHistory.size()
    
    bufferCounter	= 0;
    smoothedVol     = 0.0;
    scaledVol		= 0.0;
    pScaleVol       = scaledVol;
    
    soundStream.setup(this, 0, 2, 44100, bufferSize, 4);
    soundStream.stop();
    
    isRecording = false;
    
    // FONT
    
    font.loadFont("Arial", 100, true, true, true);
    text = "Chopin was a Polish composer and virtuoso pianist.";
    
    // SPEECH TO TEXT
    
    ofAddListener(recognizer.speechRecognizedEvent, this, &ofApp::speechRecognized);
    recognizer.initRecognizer();
    recognizer.loadDictionaryFromFile("dictionary.txt");
    recognizer.stopListening();
    
    // MESHES
    mesh.setMode(OF_PRIMITIVE_LINES);
    mesh.enableColors();
    mesh.enableIndices();
    
    // ADD VERTICES
    vector<ofPath>  letters = font.getStringAsPoints(text);
    for (int i = 0; i < letters.size(); i++) {
        ofMesh current = letters[i].getTessellation();

        vector<ofPoint>& currentvertices = current.getVertices();
        for (int j = 0; j < currentvertices.size(); j += 80) {
            
            // SPLIT MESH
            for (int k = j; k < j + 80; k++) {
            ofVec3f pos(currentvertices[k].x, currentvertices[k].y, currentvertices[k].z);
                mesh.addVertex(pos);
                mesh.addColor(ofColor(245, 58, 135));
            }
        
            // CONNECT LINES
            float connectionDistance = 20;
            int numVerts = mesh.getNumVertices();
            for (int a=0; a<numVerts; ++a) {
                ofVec3f verta = mesh.getVertex(a);
                for (int b=a+1; b<numVerts; ++b) {
                    ofVec3f vertb = mesh.getVertex(b);
                    float distance = verta.distance(vertb);
                    if (distance <= connectionDistance) {
                        mesh.addIndex(a);
                        mesh.addIndex(b);
                    }
                }
            }
            
            meshes.push_back(mesh);
            mesh.clear();
        }
    }
    //cout << meshes.size() << endl;

}

//--------------------------------------------------------------
void ofApp::update(){
    // DISPLAY STATUS
    if (!isRecording) {
        status = "OFF";
    } else {
        status = "ON";
    }
    
    // AUDIO INPUT
    
    //lets scale the vol up to a 0-1 range
    scaledVol = ofMap(smoothedVol, 0.0, 0.17, 0.0, 1.0, true);
    
    //lets record the volume into an array
    
    if (scaledVol > threshhold) {
        volHistory.push_back( scaledVol );
        //cout << scaledVol << endl;
        //cout << "Current Size: " << volHistory.size() << endl;
    }
    
    //if we are bigger the the size we want to record - lets drop the oldest value
    if( volHistory.size() >= 800 ){
        volHistory.erase(volHistory.begin(), volHistory.begin()+1);
    }
    
    pScaleVol = scaledVol;
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    // DISPLAY STATUS
    ofDrawBitmapString("Recording Status: " + status, 0, 20);
    
    // AUDIO INPUT
    
    ofNoFill();
    
    // draw the average volume:
    ofPushStyle();
    ofPushMatrix();
    ofTranslate(100, 400);
    
    ofSetColor(225);
    ofDrawBitmapString("Scaled average vol: " + ofToString(scaledVol * 100.0, 0), 4, 18);
    ofRect(0, 0, 830, 200);
    
    ofSetColor(245, 58, 135);
    ofFill();
    
    //lets draw the volume history as a graph
    if (isRecording) {
        for (unsigned int i = 0; i < meshes.size(); i++){
            float avgHistory = 0.0;
            int size = volHistory.size()/meshes.size();
            for (int j = (meshes.size() - i - 1) * size; j < (meshes.size() - i) * size; j++) {
                avgHistory += volHistory[j];
            }
            avgHistory /= size;
            
            ofPushMatrix();
            ofTranslate(0, 200);
            ofScale((float)(1.0/size) * 1.0, avgHistory * 2.0);
            meshes[i].draw();
            //cout << i << ": " << meshes[i].getNumVertices() << endl;
            ofPopMatrix();
        }
    }
    
    ofPopMatrix();
    ofPopStyle();
    
}

//--------------------------------------------------------------
void ofApp::speechRecognized(string & wordRecognized)
{
    cout << wordRecognized << endl;
    //text += wordRecognized;
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
        //recognizer.startListening();
        
    } else {
        soundStream.stop();
        //recognizer.stopListening();
        
        // INIT
        smoothedVol = 0.0;
        volHistory.assign(800, 0.5);
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
