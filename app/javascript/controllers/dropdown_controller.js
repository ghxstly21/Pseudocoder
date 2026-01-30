import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    const display = this.menuTarget.style.display
    this.menuTarget.style.display = display === "none" ? "block" : "none"
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.style.display = "none"
    }
  }
}
