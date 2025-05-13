import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = { apiKey: String }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/outdoors-v12',
      projection: 'mercator',
      center: [30.0444, 31.2357],
      zoom: 3,
    })

    this.map.addControl(new mapboxgl.NavigationControl(), 'top-right')
    this.map.setMinZoom(1)
    this.map.setMaxZoom(15)

    const lang = document.body.dataset.locale
    // console.log(lang)

    this.map.on('style.load', () => {
      const layers = this.map.getStyle().layers

      layers.forEach((layer) => {
        if (layer.layout && layer.layout['text-field'] && layer.id.includes('label')) {
          this.map.setLayoutProperty(layer.id, 'text-field', ['get', `name_${lang}`])
        }
      })
    })
  }
}
