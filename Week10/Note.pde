class Note implements AudioSignal {
  private SineWave sine;

  Note(int pitch) {
    //sine = new SineWave(freq, level, out.sampleRate());
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

