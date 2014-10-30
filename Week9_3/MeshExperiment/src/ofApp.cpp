#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetFrameRate(60);
    
    // MODES
    //mesh.setMode(OF_PRIMITIVE_POINTS);
    //mesh.setMode(OF_PRIMITIVE_LINES);
    //mesh.setMode(OF_PRIMITIVE_LINE_STRIP);
    mesh.setMode(OF_PRIMITIVE_LINE_LOOP);
    //mesh.setMode(OF_PRIMITIVE_TRIANGLES);
    mesh.enableColors();
    mesh.enableIndices();

    // VERTEX
    /*
    ofVec3f top(100.0, 50.0, 0.0);
    ofVec3f left(50.0, 150.0, 0.0);
    ofVec3f right(150.0, 150.0, 0.0);
     */
    // ADD VERTEX BEFORE COLOR IT
    /*    
    mesh.addVertex(top);
    mesh.addColor(ofFloatColor(1.0, 0.0, 0.0));
    
    mesh.addVertex(left);
    mesh.addColor(ofFloatColor(0.0, 1.0, 0.0));
    
    mesh.addVertex(right);
    mesh.addColor(ofFloatColor(1.0, 1.0, 0.0));
    */
    
    // IMAGE
    image.loadImage("vortexRainbow.jpg");
    image.resize(200, 200);
    
    // MESH IMAGE
    float intensityThreshold = 100.0;
    int w = image.getWidth();
    int h = image.getHeight();
    for (int x=0; x<w; ++x) {
        for (int y=0; y<h; ++y) {
            ofColor c = image.getColor(x, y);
            float intensity = c.getLightness();
            if (intensity >= intensityThreshold) {
                //ofVec3f pos(x, y, 0.0);
                //ofVec3f pos(4*x, 4*y, 0.0);
                float saturation = c.getSaturation();
                float z = ofMap(saturation, 0, 255, -100, 100);
                ofVec3f pos(4*x, 4*y, z);
                mesh.addVertex(pos);
                mesh.addColor(c);
                
            }
        }
    }
    
    // CONNECT LINES
    float connectionDistance = 30;
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
    
    // VOTEX
    meshCentroid = mesh.getCentroid();
    
    // ORBIT
    for (int i=0; i<numVerts; ++i) {
        ofVec3f vert = mesh.getVertex(i);
        float distance = vert.distance(meshCentroid);
        float angle = atan2(vert.y-meshCentroid.y, vert.x-meshCentroid.x);
        distances.push_back(distance);
        angles.push_back(angle);
    }
    
    // NUMBER OF VERTICES
    cout << mesh.getNumVertices() << endl;

}

//--------------------------------------------------------------
void ofApp::update(){
    
    int numVerts = mesh.getNumVertices();
    
    // ORBIT
    for (int i=0; i<numVerts; ++i) {
        ofVec3f vert = mesh.getVertex(i);
        float distance = distances[i];
        float angle = angles[i];
        float elapsedTime = ofGetElapsedTimef();
        
        // Lets adjust the speed of the orbits such that things that are closer to
        // the center rotate faster than things that are more distant
        float speed = ofMap(distance, 0, 200, 1, 0.25, true);
        
        // To find the angular rotation of our vertex, we use the current time and
        // the starting angular rotation
        float rotatedAngle = elapsedTime * speed + angle;
        
        // Remember that our distances are calculated relative to the centroid of the mesh, so
        // we need to shift everything back to screen coordinates by adding the x and y of the centroid
        vert.x = distance * cos(rotatedAngle) + meshCentroid.x;
        vert.y = distance * sin(rotatedAngle) + meshCentroid.y;
        
        mesh.setVertex(i, vert);
    }

}

//--------------------------------------------------------------
void ofApp::draw(){
    //ofBackground(0);
    
    // BACKGROUND GRADIENT
    ofColor centerColor = ofColor(85, 78, 68);
    ofColor edgeColor(0, 0, 0);
    ofBackgroundGradient(centerColor, edgeColor, OF_GRADIENT_CIRCULAR);
    
    //mesh.draw();
    //image.draw(0,0);
    
    // CAMERA
    easyCam.begin();
    ofPushMatrix();
    ofTranslate(-ofGetWidth()/2, -ofGetHeight()/2);
    mesh.draw();
    ofPopMatrix();
    easyCam.end();

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

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
