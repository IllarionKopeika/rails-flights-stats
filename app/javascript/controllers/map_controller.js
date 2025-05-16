import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    flights: Array,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v12',
      projection: 'mercator'
    })

    this.#settings()
    this.#setLanguage()

    this.map.on('load', () => {
      this.#addMarkers()
      this.#addLines()
      this.#fitMapToMarkers()
    })
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
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.popup_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #addLines() {
    this.flightsValue.forEach((flight, index) => {
      const from = [flight.from_coordinates[1], flight.from_coordinates[0]]
      const to = [flight.to_coordinates[1], flight.to_coordinates[0]]
      const curved = this.#createBezierCurve(from, to)

      const sourceId = `flight-curve-${index}`
      const shadowLayerId = `flight-curve-shadow-${index}`
      const lineLayerId = `flight-curve-line-${index}`

      this.map.addSource(sourceId, {
        type: 'geojson',
        data: {
          type: 'Feature',
          geometry: {
            type: 'LineString',
            coordinates: curved
          }
        }
      })

      this.map.addLayer({
        id: shadowLayerId,
        type: 'line',
        source: sourceId,
        layout: {
          'line-join': 'round',
          'line-cap': 'round'
        },
        paint: {
          'line-color': '#441752',
          'line-width': 4,
        }
      })

      this.map.addLayer({
        id: lineLayerId,
        type: 'line',
        source: sourceId,
        layout: {
          'line-join': 'round',
          'line-cap': 'round'
        },
        paint: {
          'line-color': '#A888B5',
          'line-width': 2,
        }
      })
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
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 30, duration: 1500 })
  }
}
