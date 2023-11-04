import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["save"]

  init(event) {
    const indicator = event.target.parentElement.querySelector('.progress')

    indicator.classList.remove("hidden")
    this.disableSave()
  }

  progress(event) {
    const { id, progress } = event.detail
    const indicator = event.target.parentElement.querySelector('.progress')

    indicator.innerHTML = `Uploading: ${Number.parseFloat(progress).toFixed(0)}%`
  }

  disableSave() {
    this.saveTarget.classList.add("bg-gray-300", "hover:bg-gray-300", "cursor-not-allowed")
  }
}
