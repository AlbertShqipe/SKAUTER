import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["start", "end", "submit"]
  static values = { url: String }

  connect() {
    this.update()
  }

  update() {
    const startsAt = this.startTarget.value
    const endsAt = this.endTarget.value

    // if missing required fields → disable submit
    if (!startsAt || !endsAt) {
      this.setState(false, "Submit")
      return
    }

    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("starts_at", startsAt)
    url.searchParams.set("ends_at", endsAt)

    fetch(url.toString(), { headers: { "Accept": "application/json" } })
      .then(r => r.json())
      .then(({ available }) => {
        if (available) {
          this.setState(true, "Request Booking")
        } else {
          this.setState(false, "Not Available at this time")
        }
      })
      .catch(() => this.setState(true, "Request Booking")) // fail open, server still validates
  }

  setState(enabled, label) {
    this.submitTarget.disabled = !enabled
    this.submitTarget.value = label
  }
}
