import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phone"
export default class extends Controller {
  connect() {
    const input = document.querySelector("#phone");

    if (input && window.intlTelInput) {
      const iti = window.intlTelInput(input, {
        initialCountry: "al",
        preferredCountries: ["en", "fr", "it", "de", "al"],
        separateDialCode: true,
        utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js"
      });

      // Update value before form submit
      const form = input.closest("form");
      if (form) {
        form.addEventListener("submit", function () {
          if (iti.isValidNumber()) {
            input.value = iti.getNumber(); // e.g., "+33612345678"
          }
        });
      }
    }
  }
}
