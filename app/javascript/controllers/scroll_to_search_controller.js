import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (sessionStorage.getItem("scrollToHeroSearch") === "true") {
      sessionStorage.removeItem("scrollToHeroSearch")

      setTimeout(() => {
        this.scrollAndOpen()
      }, 300)
    }
  }

  go(event) {
    event.preventDefault()

    const isScouting = window.location.pathname === "/scouting"

    // If NOT on scouting page → go there and remember intent
    if (!isScouting) {
      sessionStorage.setItem("scrollToHeroSearch", "true")
      window.location.href = "/scouting"
      return
    }

    // We ARE on scouting page → continue normally
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
