import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="player"
export default class extends Controller {
  static targets = ["playButton", "pauseButton"]

  play() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");
  }

  pause() {
    this.pauseButtonTarget.classList.add("hidden");
    this.playButtonTarget.classList.remove("hidden");
  }
}
