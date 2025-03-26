import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    flatpickr.localize(flatpickr.l10ns.ru)
    flatpickr(this.element, {
      disableMobile: false,
      position: 'auto center',
      minDate: '2021-01-01',
      maxDate: new Date().fp_incr(365),
      dateFormat: 'd-M-Y'
    })
  }
}
