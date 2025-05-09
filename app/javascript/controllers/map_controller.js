import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = { apiKey: String }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/outdoors-v12',
      projection: 'equalEarth',
      zoom: 1,
      center: [30.0444, 31.2357],
      padding: 20
    })
  }
}
