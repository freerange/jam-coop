import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["progress", "submit", "fileInput"]

  start() {
    this.progressTarget.classList.remove("invisible")
    this.fileInputTarget.classList.add("hidden")
    this.submitTargets.map((target) => target.setAttribute("disabled", true))
  }

  end() {
    this.progressTarget.classList.add("invisible")
  }

  progress(event) {
    const { id, file, progress } = event.detail
    this.updateProgressBar(id, progress)
  }

  fileStart(event) {
    const { file, id } = event.detail
    this.addProgressBar(file, id)
  }

  error(event) {
    const { error } = event.detail
    console.error("Upload failed:", error)

    this.progressTarget.classList.add("invisible")
  }

  addProgressBar(file, id) {
    const bar = document.createElement('progress')
    bar.max = 90
    bar.value = 0
    bar.className = 'w-full h-6 mb-3'
    bar.id = `progress-file-${id}`

    const label = document.createElement('label')
    label.for = `progress-file-${id}`
    label.innerText = file.name

    this.progressTarget.appendChild(label)
    this.progressTarget.appendChild(bar)
  }

  updateProgressBar(id, progress) {
    const bar = document.getElementById(`progress-file-${id}`)
    if (bar) { bar.value = progress }
  }
}
