import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll() {
    const rect = this.element.getBoundingClientRect()
    const windowHeight = window.innerHeight

    // Calculate how visible the section is
    const progress = 1 - rect.top / windowHeight

    // Clamp between 0 and 1
    const opacity = Math.min(Math.max(progress, 0), 1)

    this.element.style.setProperty("--scroll-opacity", opacity)
  }
}
