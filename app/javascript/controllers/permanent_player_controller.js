import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "title", "progress"];

  currentIndex = 0;

  load(tracks) {
    this.tracks = tracks;
    this.open();
  }

  open() {
    this.show();
    if (this.selectTrack(0)) this.play();
  }

  close() {
    this.pause();
    this.hide();
  }

  ended() {
    if (this.selectNextTrack()) this.play();
  }

  selectNextTrack() {
    return this.selectTrack(this.currentIndex + 1)
  }

  selectPreviousTrack() {
    return this.selectTrack(this.currentIndex - 1)
  }

  play() {
    this.audioTarget.play();
  }

  pause() {
    this.audioTarget.pause();
  }

  progress() {
    let duration = this.audioTarget.duration
    let currentTime = this.audioTarget.currentTime
    let progressFraction = currentTime / duration
    let progressPercent = Math.round(progressFraction * 100)

    if (!Number.isNaN(progressPercent)) {
      this.progressTarget.textContent = `${progressPercent}%`;
    }
  }

  show() {
    this.element.classList.remove("hidden");
  }

  hide() {
    this.element.classList.add("hidden");
  }

  selectTrack(index) {
    const track = this.trackWithIndex(index);
    if (!track) return false;

    this.currentIndex = index;
    this.audioTarget.src = track.url;
    this.titleTarget.textContent = track.title;
    this.progressTarget.textContent = "0%";

    return true;
  }

  trackWithIndex(index) {
    return this.tracks?.[index];
  }
}
