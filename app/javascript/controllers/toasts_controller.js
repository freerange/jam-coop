import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]

  close() {
    this.toastTarget.classList.add("opacity-0")
  }
}
