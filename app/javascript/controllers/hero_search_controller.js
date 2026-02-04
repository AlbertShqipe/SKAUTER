import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "activityDropdown", "activityLabel", "activityInput", "activityCheck",
    "locationTypeDropdown", "locationTypeLabel", "locationTypeInput", "locationTypeCheck",
    "dateDropdown", "dateLabel", "dateInput", "dateInputField"
  ]

  connect() {

    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  toggleActivity(event) {
    // Prevent document click from firing immediately
    event.stopPropagation()

    // Ignore clicks on dropdown items
    if (event.target.closest(".dropdown-item")) return

    this.activityDropdownTarget.hidden =
      !this.activityDropdownTarget.hidden
  }

  toggleLocationType(event) {
    event.stopPropagation()

    const willOpen = this.locationTypeDropdownTarget.hidden
    this.locationTypeDropdownTarget.hidden = !willOpen

    if (willOpen) {
      this.ignoreOutsideClick = true
      requestAnimationFrame(() => this.ignoreOutsideClick = false)
    }
  }

  toggleDate(event) {
    event.stopPropagation()

    const willOpen = this.dateDropdownTarget.hidden
    this.dateDropdownTarget.hidden = !willOpen

    if (willOpen) {
      this.ignoreOutsideClick = true
      requestAnimationFrame(() => this.ignoreOutsideClick = false)
    }
  }

  selectDate(event) {
    event.stopPropagation()

    const value = event.currentTarget.value || event.currentTarget.dataset.value || ""

    this.dateInputTarget.value = value
    this.dateLabelTarget.textContent = value || "Anytime"

    this.dateDropdownTarget.hidden = true
  }

  selectLocationType(event) {
    event.stopPropagation()

    const value = event.currentTarget.dataset.value
    this.locationTypeInputTarget.value = value
    this.locationTypeLabelTarget.textContent = value

    this.locationTypeCheckTargets.forEach((el) => {
      el.hidden = el.dataset.checkFor !== value
    })

    this.locationTypeDropdownTarget.hidden = true
  }

  selectActivity(event) {
    event.stopPropagation()

    const value = event.currentTarget.dataset.value

    this.activityInputTarget.value = value
    this.activityLabelTarget.textContent = value

    this.activityCheckTargets.forEach((el) => {
      el.hidden = el.dataset.checkFor !== value
    })

    this.activityDropdownTarget.hidden = true
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.activityDropdownTarget.hidden = true
      this.locationTypeDropdownTarget.hidden = true
      this.dateDropdownTarget.hidden = true
    }
  }
}
