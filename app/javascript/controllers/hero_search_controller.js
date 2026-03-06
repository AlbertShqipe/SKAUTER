import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "activityDropdown", "activityLabel", "activityInput", "activityCheck",
    "locationTypeDropdown", "locationTypeLabel", "locationTypeInput", "locationTypeCheck",
    "dateDropdown", "dateLabel",
    "startDateField", "endDateField",
    "startDateInput", "endDateInput"
  ]

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  closeAll() {
    this.activityDropdownTarget.hidden = true
    this.locationTypeDropdownTarget.hidden = true
    this.dateDropdownTarget.hidden = true
  }

  toggleActivity(event) {
    event.stopPropagation()
    if (event.target.closest(".dropdown-item")) return

    const willOpen = this.activityDropdownTarget.hidden
    this.closeAll()
    this.activityDropdownTarget.hidden = !willOpen
  }

  toggleLocationType(event) {
    event.stopPropagation()

    const willOpen = this.locationTypeDropdownTarget.hidden
    this.closeAll()
    this.locationTypeDropdownTarget.hidden = !willOpen

    if (willOpen) {
      this.ignoreOutsideClick = true
      requestAnimationFrame(() => this.ignoreOutsideClick = false)
    }
  }

  toggleDate(event) {
    event.stopPropagation()

    const willOpen = this.dateDropdownTarget.hidden
    this.closeAll()
    this.dateDropdownTarget.hidden = !willOpen

    if (willOpen) {
      this.ignoreOutsideClick = true
      requestAnimationFrame(() => this.ignoreOutsideClick = false)
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  updateDateRange() {
    const start = this.startDateFieldTarget.value
    const end = this.endDateFieldTarget.value

    this.startDateInputTarget.value = start
    this.endDateInputTarget.value = end

    if (start && end) {
      this.dateLabelTarget.textContent = `${start} → ${end}`
    } else if (start) {
      this.dateLabelTarget.textContent = start
    } else {
      this.dateLabelTarget.textContent = "Anytime"
    }
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
      this.closeAll()
    }
  }
}
