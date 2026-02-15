import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["amount", "unit", "hourlyBtn", "dailyBtn"]
  static values = {
    hourly: Number,
    daily: Number
  }

  connect() {
    this.currentMode = "hourly"
  }

  format(value) {
    return new Intl.NumberFormat().format(value)
  }

  showHourly() {
    this.currentMode = "hourly"
    this.amountTarget.textContent = this.format(this.hourlyValue)
    this.unitTarget.textContent = "/ hour"

    this.hourlyBtnTarget.classList.add("active")
    this.dailyBtnTarget.classList.remove("active")
  }

  showDaily() {
    this.currentMode = "daily"
    this.amountTarget.textContent = this.format(this.dailyValue)
    this.unitTarget.textContent = "/ day"

    this.dailyBtnTarget.classList.add("active")
    this.hourlyBtnTarget.classList.remove("active")
  }
}
