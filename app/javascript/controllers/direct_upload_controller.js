import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["progress", "submit"]

  start() {
    this.progressTarget.classList.remove("invisible")
    this.submitTarget.setAttribute("disabled", true)
  }

  end() {
    this.progressTarget.value = 100
    this.progressTarget.classList.add("invisible")
  }

  progress(event) {
    const { progress } = event.detail
    this.progressTarget.value = progress
  }

  error(event) {
    const { error } = event.detail
    console.error("Upload failed:", error)

    this.progressTarget.classList.add("invisible")
  }
}
