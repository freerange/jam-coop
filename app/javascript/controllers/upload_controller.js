import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["progress"];

  init(event) {
    this.progressTarget.classList.remove("hidden")
  }

  progress(event) {
    const { id, progress } = event.detail
    this.progressTarget.innerHTML = `Uploading: ${Number.parseFloat(progress).toFixed(0)}%`
  }
}
