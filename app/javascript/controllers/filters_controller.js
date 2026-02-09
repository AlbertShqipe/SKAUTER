import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filters"
export default class extends Controller {
  static targets = ["panel", "form"]

  toggle() {
    this.panelTarget.toggleAttribute("hidden")
  }

  submit() {
    this.formTarget.requestSubmit()
  }
}
