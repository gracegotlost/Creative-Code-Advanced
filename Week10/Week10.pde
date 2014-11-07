import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput in;
AudioOutput out;
FFT fft;

Note myNote;
float volume = 0.5;

float[] buffer;
float gain = 100;
int size = 10;

void setup() {
  size(640, 480);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 1024);
  out = minim.getLineOut(Minim.STEREO);
  buffer = new float[in.bufferSize()];
  fft = new FFT(in.bufferSize(), in.sampleRate());

  noStroke();
}

void draw() {
  background(200, 0, 200);

  fft.forward(in.mix);

  float maxFFT = 0;
  int count = 0;
  for (int i = 0; i < fft.specSize (); i++) {
    float fftAvg = 0;
    for (int j = i * (fft.specSize ()/size); j < (i + 1) * (fft.specSize()/size); j++) {
      fftAvg += fft.getBand(j);
    }
    fftAvg = (fftAvg/(fft.specSize()/size)) * 10;
    if (fftAvg > maxFFT) {
      maxFFT = fftAvg;
      count = i;
    }
    //rect(i * (width/size), (height - fftAvg), width/size, height);
  }

  // DRAW KEYS
  // WHITE KEY
  for (int i = 0; i < fft.specSize (); i++) {
    fill(255);
    rect(i * (width/size) + i * 3, height - 50, width/size, 50);
  }

  // BLACK KEY
  for (int i = 0; i < fft.specSize (); i++) {
    fill(0);
    rect((i + 0.7) * (width/size) + i * 3, height - 60, 40, 30);
  }
}

void keyPressed() {
  switch(key) {
  case 'a': 
    myNote = new Note(440, volume);
    break;
  case 's': 
    myNote = new Note(300, volume);
    break;
  case 'd': 
    myNote = new Note(140, volume);
    break;
  case 'f': 
    myNote = new Note(100, volume);
    break;
  case 'g': 
    myNote = new Note(350, volume);
    break;
  case 'h': 
    myNote = new Note(400, volume);
    break;
  case 'j': 
    myNote = new Note(500, volume);
    break;
  case 'k': 
    myNote = new Note(700, volume);
    break;
  case 'l': 
    myNote = new Note(800, volume);
    break;
  }
}

class Note implements AudioSignal {
  private float freq;
  private float level;
  private SineWave sine;

  Note(float pitch, float amplitude) {
    freq = pitch;
    level = amplitude;
    sine = new SineWave(freq, level, out.sampleRate());
    out.clearSignals();
    out.addSignal(sine);
  }

  // must implement the inherited abstract method AudioSignal.generate(float[], float[]);
  void generate(float [] samp) {
    sine.generate(samp);
  }

  void generate(float [] sampL, float [] sampR) {
    sine.generate(sampL, sampR);
  }
}

