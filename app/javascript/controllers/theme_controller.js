import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  setGolden() {
    this.transition()
    document.documentElement.classList.add("golden-hour")
  }

  setDaylight() {
    this.transition()
    document.documentElement.classList.remove("golden-hour")
  }

  transition() {
    document.body.classList.add("mode-transitioning")
    setTimeout(() => {
      document.body.classList.remove("mode-transitioning")
    }, 1200)
  }
}
