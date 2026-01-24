import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static values = {
    // Top-of-hero colors (status bar)
    daylightColor: { type: String, default: "#1e3a8a" }, // blue
    goldenColor: { type: String, default: "#7a5819" },   // warm gold
    // Scrolled navbar color (status bar)
    scrolledColor: { type: String, default: "#ffffff" }  // white
  }

  connect() {
    this.meta = document.querySelector('meta[name="theme-color"]')

    // Optional: restore theme preference
    const saved = localStorage.getItem("theme")
    if (saved === "golden") document.documentElement.classList.add("golden-hour")

    // Initial sync + scroll listener
    this.sync()
    window.addEventListener("scroll", this.sync, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.sync)
  }

  setGolden() {
    this.transition()
    document.documentElement.classList.add("golden-hour")
    localStorage.setItem("theme", "golden")
    this.sync()
  }

  setDaylight() {
    this.transition()
    document.documentElement.classList.remove("golden-hour")
    localStorage.setItem("theme", "daylight")
    this.sync()
  }

  transition() {
    document.body.classList.add("mode-transitioning")
    setTimeout(() => {
      document.body.classList.remove("mode-transitioning")
    }, 1200)
  }

  // Keep navbar + iOS status bar in sync with scroll + theme
  sync = () => {
    const scrolled = window.scrollY > 20
    document.body.classList.toggle("scrolled", scrolled)

    if (!this.meta) return

    if (scrolled) {
      this.meta.setAttribute("content", this.scrolledColorValue)
      return
    }

    const golden = document.documentElement.classList.contains("golden-hour")
    this.meta.setAttribute(
      "content",
      golden ? this.goldenColorValue : this.daylightColorValue
    )
  }
}
