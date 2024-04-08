export default {
  mounted() {
    this.handleEvent("pop", ({ id: tile_id }) => {
      const el = document.getElementById(tile_id)
      el.classList.add("animate-pop")
    })

    this.handleEvent("rotate", ({ id: tile_row_id }) => {
      const els = Array.from(document.getElementById(tile_row_id).children)
      els.forEach((el, col) => {
        el.classList.add("animate-rotate", `animate-delay-${col * 150}`)
      })
    })

    this.handleEvent("unpop", ({ id: tile_id }) => {
      const el = document.getElementById(tile_id)
      el.classList.add("animate-unpop")
    })

    this.handleEvent("wiggle", ({ id: title_row_id }) => {
      const el = document.getElementById(title_row_id)
      el.classList.add("animate-wiggle")
    })
  }
}

