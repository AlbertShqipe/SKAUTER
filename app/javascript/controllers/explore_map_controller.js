import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  hover(event) {
    const card = event.currentTarget
    const lat = parseFloat(card.dataset.lat)
    const lng = parseFloat(card.dataset.lng)
    const id = card.dataset.locationId

    const mapController = this.application
      .controllers
      .find(c => c.identifier === "map")

    mapController?.flyTo(id, lat, lng)
  }
}
