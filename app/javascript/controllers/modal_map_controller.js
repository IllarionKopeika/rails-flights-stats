import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="modal-map"
export default class extends Controller {
  static values = {
    apiKey: String,
    departureCoordinates: Array,
    arrivalCoordinates: Array
  }

  connect() {
    const modal = this.element.closest(".modal")
    modal.addEventListener("shown.bs.modal", () => this.#initMap(), { once: true })
  }

  #initMap() {
    mapboxgl.accessToken = this.apiKeyValue
    const mapElement = document.getElementById("map")
    this.map = new mapboxgl.Map({
      container: mapElement,
      style: 'mapbox://styles/mapbox/streets-v12',
      projection: 'mercator'
    })

    this.#settings()
    this.#setLanguage()

    this.map.on('load', () => {
      this.#addMarkers()
      this.#addLine()
      this.#fitMapToMarkers()
    })

    console.log(this.markersValue)
  }

  #settings() {
    this.map.addControl(new mapboxgl.NavigationControl(), 'top-right')
    this.map.setMinZoom(1)
    this.map.setMaxZoom(10)
  }

  #setLanguage() {
    const lang = document.body.dataset.locale

    this.map.on('style.load', () => {
      const layers = this.map.getStyle().layers

      layers.forEach((layer) => {
        if (layer.layout && layer.layout['text-field'] && layer.id.includes('label')) {
          this.map.setLayoutProperty(layer.id, 'text-field', ['get', `name_${lang}`])
        }
      })
    })
  }

  #addMarkers() {
    const createMarker = (coordinates) => {
      const img = new Image()
      img.src = "/assets/logo.png"
      img.alt = "Logo"
      img.width = 20
      img.height = 20

      new mapboxgl.Marker(img)
        .setLngLat(coordinates)
        .addTo(this.map)
    }

    createMarker(this.departureCoordinatesValue)
    createMarker(this.arrivalCoordinatesValue)
  }

  #addLine() {
    const curved = this.#createBezierCurve(this.departureCoordinatesValue, this.arrivalCoordinatesValue)

    this.map.addSource("flightRoute", {
      type: "geojson",
      data: {
        type: 'Feature',
        geometry: {
          type: 'LineString',
          coordinates: curved
        }
      }
    })

    this.map.addLayer({
      id: "flightRouteLine",
      type: "line",
      source: "flightRoute",
      layout: {
        "line-join": "round",
        "line-cap": "round"
      },
      paint: {
        'line-color': '#441752',
        'line-width': 2,
      }
    })
  }

  #createBezierCurve(start, end) {
    const line = []
    const offsetX = end[0] - start[0]
    const offsetY = end[1] - start[1]
    const r = Math.sqrt(Math.pow(offsetX, 2) + Math.pow(offsetY, 2))
    const theta = Math.atan2(offsetY, offsetX)

    const thetaOffset = (3.14 / 10) // радиус изгиба, поэкспериментируй
    const r2 = (r / 2.0) / Math.cos(thetaOffset)
    const theta2 = theta + thetaOffset

    const midpointX = r2 * Math.cos(theta2) + start[0]
    const midpointY = r2 * Math.sin(theta2) + start[1]
    const midpoint = [midpointX, midpointY]

    const steps = 50
    for (let i = 0; i <= steps; i++) {
      const t = i / steps
      const x = (1 - t) * (1 - t) * start[0] + 2 * (1 - t) * t * midpoint[0] + t * t * end[0]
      const y = (1 - t) * (1 - t) * start[1] + 2 * (1 - t) * t * midpoint[1] + t * t * end[1]
      line.push([x, y])
    }

    return line
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend(this.departureCoordinatesValue)
    bounds.extend(this.arrivalCoordinatesValue)
    this.map.fitBounds(bounds, { padding: 30, duration: 1500 })
  }
}
