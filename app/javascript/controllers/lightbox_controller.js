import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "track"]

  connect() {
    console.log("✅ Lightbox controller connected")
    this.index = 0
  }

  open(event) {
    const clickedImage = event.currentTarget

    this.images = JSON.parse(clickedImage.dataset.lightboxImages)
    this.index = parseInt(clickedImage.dataset.lightboxIndex, 10)

    this.overlayTarget.hidden = false
    document.body.style.overflow = "hidden"

    this.render()
  }

  close() {
    this.overlayTarget.hidden = true
    this.trackTarget.innerHTML = ""
    document.body.style.overflow = ""
  }

  render() {
    this.trackTarget.innerHTML = ""

    const img = document.createElement("img")
    img.src = this.images[this.index]
    img.className = "lightbox-image"

    this.trackTarget.appendChild(img)
  }

  next() {
    if (this.index < this.images.length - 1) {
      this.index++
      this.render()
    }
  }

  prev() {
    if (this.index > 0) {
      this.index--
      this.render()
    }
  }

  scrollToIndex() {
    const img = this.trackTarget.children[this.index]
    if (img) {
      img.scrollIntoView({ behavior: "smooth", inline: "center" })
    }
  }
}
