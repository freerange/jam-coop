import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  connect() {
    this.tomSelect = new TomSelect(this.element, {
      plugins: ['remove_button'],
      create: false,
      onItemAdd: function() {
        this.setTextboxValue('');
        this.refreshOptions();
      },
      maxOptions: null,
      placeholder: 'Select tags...'
    })
  }

  disconnect() {
    this.tomSelect?.destroy();
  }
}
