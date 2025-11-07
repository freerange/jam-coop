import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static targets = [ "select" ]

  connect() {
    new TomSelect(this.selectTarget, {
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
}
