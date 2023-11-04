import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["template"];

  add(event) {
    event.preventDefault();
    event.currentTarget.insertAdjacentHTML(
      "beforebegin",
      this.templateTarget.innerHTML.replace(
        /__CHILD_INDEX__/g,
        new Date().getTime().toString()
      )
    );
  }
}
