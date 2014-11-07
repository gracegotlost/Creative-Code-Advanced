class Note implements AudioSignal {
  private SineWave sine;
  private int[] pitches = {
    262, 277, 294, 311, 
    330, 349, 370, 392, 
    415, 440, 466, 494, 
    523, 554, 587, 624,
    679, 702, 758, 796
  };
  private float volume;
  private int pitch;

  Note(int _pitch) {
    pitch = _pitch;
    volume = 0.5;
    sine = new SineWave(pitches[pitch], volume, out.sampleRate());
  }

  void play() {
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

