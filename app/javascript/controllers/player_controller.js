import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="player"
export default class extends Controller {
  static targets = ["playButton", "pauseButton", "audio", "track", "trackTitle", "progress", "progressContainer"]

  play() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");

    this.audioTarget.play();
    this.showTrackTitle();
  }

  pause() {
    this.pauseButtonTarget.classList.add("hidden");
    this.playButtonTarget.classList.remove("hidden");

    this.audioTarget.pause();
  }

  playNext() {
    if (this.nextTrack()) {
      this.audioTarget.src = this.nextTrack();
      this.play();
    } else {
      this.pause();
      this.audioTarget.src = this.firstTrack();
    }
  }

  playPrev() {
    if (this.prevTrack()) {
      this.audioTarget.src = this.prevTrack();
      this.play();
    } else {
      this.pause();
      this.audioTarget.src = this.firstTrack();
    }
  }

  playTrack(event) {
    this.audioTarget.src = event.currentTarget.dataset.trackUrl;
    this.play();
  }

  ended() {
    this.playNext();
  }

  progress() {
    let duration = this.audioTarget.duration
    let currentTime = this.audioTarget.currentTime
    let progress = currentTime/duration

    this.progressTarget.style.width = `${progress*100}%`
  }

  setProgress(e) {
    let x = e.clientX
    let containerOffsetLeft = this.progressContainerTarget.offsetLeft
    let containerOffsetWidth = this.progressContainerTarget.offsetWidth
    let progress = (x-containerOffsetLeft) / containerOffsetWidth;

    this.progressTarget.style.width = `${progress*100}%`
    this.audioTarget.currentTime = this.audioTarget.duration * progress
  }

  showTrackTitle() {
    if (this.currentIndex() < 0) return;
    const title = this.trackTargets[this.currentIndex()].querySelector("span").innerText;
    this.trackTitleTarget.classList.remove("invisible");
    this.trackTitleTarget.innerText = title;
  }

  hideTrackTitle() {
    this.trackTitleTarget.classList.add("invisible");
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

  currentIndex() {
    return this.trackList().indexOf(this.currentTrack())
  }

  nextTrack() {
    const nextIndex = this.currentIndex() + 1;

    return this.trackList()[nextIndex]
  }

  prevTrack() {
    const prevIndex = this.currentIndex() - 1;

    return this.trackList()[prevIndex]
  }
}
