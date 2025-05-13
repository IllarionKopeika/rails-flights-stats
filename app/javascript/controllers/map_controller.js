import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    flights: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v12',
      projection: 'mercator',
      center: [30.0444, 31.2357],
      zoom: 3,
    })

    this.#settings()
    this.#setLanguage()
    this.#addStringLines()
  }

  #settings() {
    this.map.addControl(new mapboxgl.NavigationControl(), 'top-right')
    this.map.setMinZoom(0)
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

  #addStringLines() {
    this.map.on('load', () => {
      this.flightsValue.forEach((flight, index) => {
        const lineId = `flight-line-${index}`

        this.map.addSource(lineId, {
          type: 'geojson',
          data: {
            type: 'Feature',
            geometry: {
              type: 'LineString',
              coordinates: [
                [flight.from_coordinates[1], flight.from_coordinates[0]],
                [flight.to_coordinates[1], flight.to_coordinates[0]]
              ]
            }
          }
        })

        this.map.addLayer({
          id: lineId,
          type: 'line',
          source: lineId,
          layout: {
            'line-join': 'round',
            'line-cap': 'round'
          },
          paint: {
            'line-color': '#441752',
            'line-width': 2,
          }
        })
      })
    })
  }
}
