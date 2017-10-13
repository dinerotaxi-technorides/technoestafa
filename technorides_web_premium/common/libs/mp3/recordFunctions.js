// Recorder
function startUserMedia(stream) {
  audio_context = new AudioContext();
  zeroGain = audio_context.createGain();
  zeroGain.gain.value = 0.0;

  input = audio_context.createMediaStreamSource(stream);
  //input.connect(audio_context.destination);
  input.connect(zeroGain);
  navigator.recorder = new Recorder(input);
  window.navigator.microphoneDisabled = false;
}

window.navigator.microphoneDisabled = true;

window.navigator.askMicAcces = function() {
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  navigator.getUserMedia = navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
  window.URL = window.URL || window.webkitURL;
  navigator.getUserMedia({audio: {mandatory: {googEchoCancellation: false, googAutoGainControl: false, googNoiseSuppression: false, googHighpassFilter: false}, optional: []},}, startUserMedia, function(e) {
    window.navigator.microphoneDisabled = true;
    console.warn("No live audio input");
  });
};
