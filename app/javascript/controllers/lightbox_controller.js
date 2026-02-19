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

  closeOverlay(event) {
    // Close only when clicking the overlay, not its children
    if (event.currentTarget === this.overlayTarget) {
      this.close()
    }
  }

  stop(event) {
    event.stopPropagation()
  }

  render() {
    this.trackTarget.innerHTML = ""

    // Reliable mobile detection
    const isMobile =
      navigator.maxTouchPoints > 0 && window.matchMedia("(pointer: coarse)").matches

    if (isMobile) {
      // MOBILE: render ALL images for horizontal scrolling
      this.images.forEach((url) => {
        const img = document.createElement("img")
        img.src = url
        img.className = "lightbox-image"
        this.trackTarget.appendChild(img)
      })

      // Scroll to active image
      requestAnimationFrame(() => {
        this.trackTarget.children[this.index]?.scrollIntoView({
          behavior: "instant",
          inline: "center"
        })
      })

    } else {
      // DESKTOP: render only current image
      const img = document.createElement("img")
      img.src = this.images[this.index]
      img.className = "lightbox-image"

      this.trackTarget.appendChild(img)
    }
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
