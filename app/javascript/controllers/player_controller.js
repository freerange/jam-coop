import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="player"
export default class extends Controller {
  static targets = ["playButton", "pauseButton", "audio", "track"]

  play() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");

    this.audioTarget.play();
  }

  pause() {
    this.pauseButtonTarget.classList.add("hidden");
    this.playButtonTarget.classList.remove("hidden");

    this.audioTarget.pause();
  }

  ended() {
    if (this.nextTrack()) {
      this.audioTarget.src = this.nextTrack();
      this.audioTarget.play();
    } else {
      this.pause();
      this.audioTarget.src = this.firstTrack();
    }
  }

  trackList() {
    return this.trackTargets.map(function(t) { return t.dataset.trackUrl});
  }

  firstTrack() {
    return this.trackList()[0]
  }

  currentTrack() {
    const url = new URL(this.audioTarget.src);

    return url.pathname
  }

  nextTrack() {
    const currentIndex = this.trackList().indexOf(this.currentTrack());
    const nextIndex = currentIndex + 1;

    return this.trackList()[nextIndex]
  }
}