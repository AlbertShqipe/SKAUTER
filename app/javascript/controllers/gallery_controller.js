import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hero", "thumb", "current"]

  connect() {
    this.index = 0
    this.images = this.thumbTargets.map(t => t.dataset.full)
  }

  goTo(event) {
    this.index = parseInt(event.currentTarget.dataset.galleryIndex)
    this.update()
  }

  prev() {
    this.index = (this.index - 1 + this.images.length) % this.images.length
    this.update()
  }

  next() {
    this.index = (this.index + 1) % this.images.length
    this.update()
  }

  update() {
    this.heroTarget.src = this.images[this.index]
    this.currentTarget.textContent = this.index + 1

    this.thumbTargets.forEach((t, i) => {
      t.classList.toggle("active", i === this.index)
    })

    this.thumbTargets[this.index]
      .scrollIntoView({ behavior: "smooth", block: "nearest", inline: "center" })
  }
}
