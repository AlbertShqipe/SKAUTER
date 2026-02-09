import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-search"
export default class extends Controller {
  go(event) {
    event.preventDefault()

    const target = document.getElementById("hero-search")
    if (!target) return

    // Smooth scroll
    target.scrollIntoView({
      behavior: "smooth",
      block: "center"
    })

    // Wait for scroll to finish, then open first dropdown
    setTimeout(() => {
      const activityField = target.querySelector(
        '[data-action*="toggleActivity"]'
      )

      console.log("Activity field:", activityField)

      if (activityField) {
        activityField.click()
      }
    }, 600)
  }
}
