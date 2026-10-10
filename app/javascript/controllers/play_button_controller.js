import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { tracks: Array };
  static outlets = ["permanent-player"];

  click() {
    this.permanentPlayerOutlet.load(this.tracksValue);
  }
}
