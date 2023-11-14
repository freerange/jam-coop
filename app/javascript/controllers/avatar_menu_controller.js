import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "clear"]

  escape(event) {
    if (event.key == 'Esc' || event.key == 'Escape') {
      this.close()
    }
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.clearTarget.classList.add("hidden")
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    this.clearTarget.classList.toggle("hidden")
  }
}
