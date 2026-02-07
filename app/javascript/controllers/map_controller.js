
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static targets = ["container", "panel"]
  static values = {
    apiKey: String,
    markers: Array,
    counties: Array,
    open: Boolean,
    selectedCounty: Object
  }

  connect() {
    console.log("✅ Map controller connected")

    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      style: "mapbox://styles/albertnikolli/cml0tspwm006m01qxbqri7rqs",
      center: [19.8187, 41.3275],
      zoom: 6
    })

    this.map.addControl(
      new mapboxgl.NavigationControl({ showCompass: false }),
      "bottom-right"
    )

    this.markerIndex = {}
    this.addMarkers()

    if (this.hasSelectedCountyValue) {
      this.zoomToCounty(this.selectedCountyValue)
    }
  }

  addMarkers() {
    console.log("📍 Adding markers:", this.markersValue.length)

    this.markersValue.forEach(marker => {
      const popup = new mapboxgl.Popup({
        offset: 20,
        closeButton: false
      }).setHTML(`
        <div class="map-popup">
          <h3>${marker.name}</h3>
          <p>${marker.county.name}</p>
          <a href="/locations/${marker.id}" class="map-popup-btn">View →</a>
        </div>
      `)

      const el = document.createElement("div")
      el.className = "map-marker"

      const mapMarker = new mapboxgl.Marker(el)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)

      this.markerIndex[marker.id] = { mapMarker, el }
    })
  }

  addCountyMarkers() {
    this.countiesValue.forEach(county => {
      const el = document.createElement("div")
      el.className = "county-marker"
      el.innerText = county.name

      el.addEventListener("click", () => {
        this.zoomToCounty(county)
      })

      new mapboxgl.Marker(el)
        .setLngLat([county.lng, county.lat])
        .addTo(this.map)
    })
  }

  toggle() {
    console.log("🟢 Toggle clicked")

    this.openValue = !this.openValue
    this.panelTarget.classList.toggle("is-open", this.openValue)

    setTimeout(() => {
      this.map.resize()
    }, 350)
  }

  flyTo(id, lat, lng) {
    this.map.flyTo({
      center: [lng, lat],
      zoom: 12,
      speed: 0.9
    })

    Object.values(this.markerIndex).forEach(m =>
      m.el.classList.remove("active")
    )

    this.markerIndex[id]?.el.classList.add("active")
  }

  zoomToCounty(county) {
    this.map.flyTo({
      center: [county.lng, county.lat],
      zoom: 9,       // ← perfect county-level zoom
      speed: 0.8
    })
  }
}
