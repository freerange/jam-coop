import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]

  connect() {
    setTimeout(() => {
      this.toastTarget.remove()
    }, 1000)
  }

  close() {
    this.toastTarget.remove();
  }
}
