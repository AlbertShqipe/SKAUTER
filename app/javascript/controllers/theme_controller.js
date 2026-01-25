import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static values = {
    // Status bar colors (SOLID — iOS Safari requirement)
    daylightColor: { type: String, default: "#1e3a8a" }, // blue hero
    goldenColor:   { type: String, default: "#0f0a05" }, // warm black
    scrolledColor: { type: String, default: "#ffffff" }  // white navbar
  }

  connect() {
    this.meta = document.querySelector('meta[name="theme-color"]')

    // Restore theme
    const saved = localStorage.getItem("theme")
    if (saved === "golden") {
      document.documentElement.classList.add("golden-hour")
    }

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

  // 🔑 The ONLY source of truth for iOS Safari
  sync = () => {
    const scrolled = window.scrollY > 20
    document.body.classList.toggle("scrolled", scrolled)

    if (!this.meta) return

    if (scrolled) {
      // Always white when navbar is solid
      this.meta.setAttribute("content", this.scrolledColorValue)
      return
    }

    const golden = document.documentElement.classList.contains("golden-hour")

    // Top-of-hero colors
    this.meta.setAttribute(
      "content",
      golden ? this.goldenColorValue : this.daylightColorValue
    )
  }
}
