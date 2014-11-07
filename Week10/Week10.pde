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

ArrayList<Note> myNote;
float volume = 0.5;

float[] buffer;
float gain = 100;
int size = 20;
boolean isPlaying = false;
boolean isNow = false;
int count = 0;
int current = -1;

void setup() {
  size(640, 480);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 1024);
  out = minim.getLineOut(Minim.STEREO);
  buffer = new float[in.bufferSize()];
  fft = new FFT(in.bufferSize(), in.sampleRate());

  myNote = new ArrayList<Note>();

  noStroke();
}

void draw() {
  background(200, 0, 200);

  fft.forward(in.mix);

  // RECORDING
  if (!isPlaying) {
    float maxFFT = 0;
    count = 0;
    if (frameCount%10 == 0) {
      for (int i = 0; i < fft.specSize (); i++) {
        float fftAvg = 0;
        for (int j = i * (fft.specSize ()/size); j < (i + 1) * (fft.specSize()/size); j++) {
          fftAvg += fft.getBand(j);
        }
        fftAvg = (fftAvg/(fft.specSize()/size)) * 10;
        if (fftAvg > maxFFT) {
          maxFFT = fftAvg;
          count = i;
          myNote.add(new Note(i));
        }
        //rect(i * (width/size), (height - fftAvg), width/size, height);
      }
    }
    // DRAW KEYS
    // WHITE KEY
    for (int i = 0; i < fft.specSize (); i += 2) {
      fill(255);
      if (i == count) {
        rect(i/2 * (width/size) + i/2 * 2, height - 40 + 10, width/size, 40);
      } else {
        rect(i/2 * (width/size) + i/2 * 2, height - 40, width/size, 40);
      }
    }

    // BLACK KEY
    for (int i = 1; i < fft.specSize (); i += 2) {
      fill(0);
      if (i == count) {
        rect(((i-1)/2 + 0.6) * (width/size) + (i-1)/2 * 2, height - 50 + 10, 500/size, 30);
      } else {
        rect(((i-1)/2 + 0.6) * (width/size) + (i-1)/2 * 2, height - 50, 500/size, 30);
      }
    }
  }

  // PLAYING
  else {
    // PLAYING NOTES

    if ((frameCount%10) == 0) {
      Note n = myNote.get(count);
      n.play();
      current = n.pitch;
      count = (count + 1)%myNote.size();
      isNow = true;
      println(current);
    }

    // DRAW KEYS
    // WHITE KEY
    for (int i = 0; i < fft.specSize (); i += 2) {
      fill(255);
      if (isNow && current == i) {
        isNow = false;
        current = -1;
        rect(i/2 * (width/size) + i/2 * 2, height - 40 + 10, width/size, 40);
      } else {
        rect(i/2 * (width/size) + i/2 * 2, height - 40, width/size, 40);
      }
    }

    // BLACK KEY
    for (int i = 1; i < fft.specSize (); i += 2) {
      fill(0);
      if (isNow && current == i) {
        isNow = false;
        current = -1;
        rect(((i-1)/2 + 0.6) * (width/size) + (i-1)/2 * 2, height - 50 + 10, 500/size, 30);
      } else {
        rect(((i-1)/2 + 0.6) * (width/size) + (i-1)/2 * 2, height - 50, 500/size, 30);
      }
    }
  }
}

void keyPressed() {
  if (isPlaying) {
    myNote.clear();
    out.clearSignals();
  }
  isPlaying = !isPlaying;
}

