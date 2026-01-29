import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slideshow"
export default class extends Controller {
  static targets = ["panel", "button"]

  toggle() {
    this.panelTarget.classList.toggle("open")
    this.buttonTarget.classList.toggle("open")
  }
}
