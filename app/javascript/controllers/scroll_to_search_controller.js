import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-search"
export default class extends Controller {
  connect() {
    if (sessionStorage.getItem("scrollToHeroSearch") === "true") {
      sessionStorage.removeItem("scrollToHeroSearch")

      // let layout + images settle
      setTimeout(() => {
        this.scrollAndOpen()
      }, 300)
    }
  }

  go(event) {
    event.preventDefault()

    const isHome = window.location.pathname === "/"

    // 1️⃣ If NOT on homepage → go there and remember intent
    if (!isHome) {
      sessionStorage.setItem("scrollToHeroSearch", "true")
      window.location.href = "/"
      return
    }

    // 2️⃣ We ARE on homepage → continue normally
    this.scrollAndOpen()
  }
  scrollAndOpen() {
    const target = document.getElementById("hero-search")
    const slideshow = document.querySelector(".slideshow")
    const button = document.querySelector(".menu-icon")

    if (!target) return

    target.scrollIntoView({
      behavior: "smooth",
      block: "center"
    })

    slideshow?.classList.remove("open")
    button?.classList.remove("open")

    setTimeout(() => {
      const activityField = target.querySelector(
        '[data-action*="toggleActivity"]'
      )

      if (activityField) {
        activityField.click()
      }
    }, 500)
  }
}
