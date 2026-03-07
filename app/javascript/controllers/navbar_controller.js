import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  connect() {
    this.onScroll() // Check scroll position on load
  }

  onScroll() {
    if (window.scrollY > 20) {
      this.element.classList.add("scrolled")
    } else {
      this.element.classList.remove("scrolled")
    }
  }
}
