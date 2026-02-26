import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "amount",
    "unit",
    "hourlyBtn",
    "dailyBtn",
    "type",
    "hourlyFields",
    "dailyFields"
  ]

  static values = { hourly: Number, daily: Number }

  connect() {
    this.showHourly() // default state
  }

  showHourly() {
    this.hourlyBtnTarget.classList.add("active")
    this.dailyBtnTarget.classList.remove("active")

    this.amountTarget.textContent = this.hourlyValue.toLocaleString()
    this.unitTarget.textContent = "/ hour"

    this.typeTarget.value = "hourly"

    this.hourlyFieldsTarget.hidden = false
    this.dailyFieldsTarget.hidden = true

    this.toggleFieldState(this.hourlyFieldsTarget, true)
    this.toggleFieldState(this.dailyFieldsTarget, false)
  }

  showDaily() {
    this.dailyBtnTarget.classList.add("active")
    this.hourlyBtnTarget.classList.remove("active")

    this.amountTarget.textContent = this.dailyValue.toLocaleString()
    this.unitTarget.textContent = "/ day"

    this.typeTarget.value = "daily"

    this.hourlyFieldsTarget.hidden = true
    this.dailyFieldsTarget.hidden = false

    this.toggleFieldState(this.hourlyFieldsTarget, false)
    this.toggleFieldState(this.dailyFieldsTarget, true)
  }

  toggleFieldState(container, enable) {
    container.querySelectorAll("input").forEach(input => {
      input.disabled = !enable
    })
  }
}
