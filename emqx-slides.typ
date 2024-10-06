#import "@preview/cetz:0.2.2"
#import "@preview/suiji:0.3.0"

#let default-color = blue.darken(40%)
#let header-color = default-color.lighten(75%)
#let body-color = default-color.lighten(85%)
#let footer-color = gray
#let asparagus-color = rgb(80%, 90%, 80%)
#let decoration-color = asparagus-color

#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)

#let corner-image(width, height) = {
  let nnodes = 10
  let rng = suiji.gen-rng(5)
  let x-dev = ()
  let y-dev = ()
  let r-dev = ()
  (rng, x-dev) = suiji.random(rng, size: nnodes)
  (rng, y-dev) = suiji.random(rng, size: nnodes)
  (rng, r-dev) = suiji.random(rng, size: nnodes)

  let vertices = ()
  for i in range(0, nnodes) {
    let x = (i + 8 * x-dev.at(i)) * (width / nnodes)
    let y = y-dev.at(i) * height
    let radius = 2pt
    vertices.push(
      (
        center: (x, y),
        radius: radius
      )
    )
  }

  let corner-image = cetz.canvas(length: 1cm, {
    import cetz.draw: *

    for i in range(0, nnodes) {
      circle(
        vertices.at(i).center,
        radius: vertices.at(i).radius,
        fill: decoration-color,
        stroke: (
          paint: decoration-color,
          thickness: 0.3pt
        )
      )
    }

    for i in range(0, nnodes, step: 2) {
      for j in range(1, nnodes, step: 2) {
        line(
          vertices.at(i).center,
          vertices.at(j).center,
          stroke: (
            paint: decoration-color,
            thickness: 0.3pt
          )
        )
      }
    }
  })

  box(
    width: width,
    height: height,
    corner-image
  )
}

#let common-background(width, height) = {
  let corner-image = corner-image(width, height)
  place(top + left, move(dx: -width/2, dy: -height/2, corner-image))
  place(top + right, move(dx: width/2, dy: -height/2, corner-image))
  place(bottom + left, move(dx: -width/2, dy: height/2, corner-image))
  place(bottom + right, move(dx: width/2, dy: height/2, corner-image))

  let logo-image = image("emqx_logo.png", width: width/4, height: height/4, fit: "contain")
  place(top + left,
    pad(x: 0.1cm, logo-image)
  )
}

#let title-page(
  width: none,
  height: none,
  space: none,
  title: none,
  title-color: none,
  subtitle: none,
  date: none,
  authors: (),
) =  {
    set page(
      footer: none,
      background: {
        image("title_background.png", width: width, height: height, fit: "contain")
        common-background(width/3, height/4)
      }
    )
    set align(horizon + center)
    v(- space / 2)
    block(
      width: width/2,
      {
        set align(left)
        text(1.5em, weight: "bold", fill: title-color, title)
        v(1.4em, weak: true)
        if subtitle != none {
          text(1.1em, weight: "bold", subtitle)
        }
        v(1em, weak: true)
        authors.join(", ", last: " and ")
        v(1em, weak: true)
        if date != none {
          date
        }

      }
    )
  }

#let emqx-slides(
  content,
  title: none,
  subtitle: none,
  date: none,
  authors: (),
  layout: "medium",
  ratio: 4/3,
  title-color: none,
  font-family: "CMU Sans Serif",
) = {

  if layout not in layouts {
      panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  if title-color == none {
      title-color = default-color
  }
  if font-family == none {
    font-family = "CMU Sans Serif"
  }

  set text(
    font: font-family
  )

  set document(
    title: title,
    author: authors,
  )
  set page(
    width: width,
    height: height,
    margin: (x: space, bottom: 0.4 * space, top: 0.3 * space),
    footer: [
      #set text(0.6em, fill: footer-color)
      #set align(center)
      #place(left, move(dx: -space + 0.2cm, [©#{date} EMQ Technologies Co., Ltd.])),
      #counter(page).display("1/1", both: true)
    ],
    footer-descent: 0.8em,
    background: common-background(width/3, height/4),
  )
  set outline(
    target: heading.where(level: 1),
    title: none,
  )
  set bibliography(
    title: none
  )

  // Rules
  show heading.where(level: 1): x => {
    set page(header: none, footer: none)
    set align(center + horizon)
    set text(1.2em, weight: "bold", fill: title-color)
    v(- space / 2)
    x.body
  }
  show heading.where(level: 2): heading => {
    pagebreak(weak: true)
    set align(center)
    block(
      width: width / 2,
      {
        set align(left)
        heading
      }
    )
    v(space / 2)
  }
  show heading: set text(1.1em, fill: title-color)

  // Title
  if (title == none) {
    title = "Title here"
  }
  if (type(authors) != array) {
    authors = (authors,)
  }

  title-page(
    width: width,
    height: height,
    space: space,
    title: title,
    title-color: title-color,
    subtitle: subtitle,
    date: date,
    authors: authors,
  )

  // Content
  content
}

#let frame(content, counter: none, title: none) = {

  let header = none
  if counter == none and title != none {
    header = [*#title.*]
  }
  else if counter != none and title == none {
    header = [*#counter.*]
  }
  else if counter != none and title != none {
    header = [*#counter:* #title.]
  }

  set block(width: 100%, inset: (x: 0.4em, top: 0.35em, bottom: 0.45em))
  show stack: set block(breakable: false)
  show stack: set block(breakable: false, above: 0.8em, below: 0.5em)

  if header == none {
    stack(
      block(fill: body-color, radius: (top: 0cm, bottom: 0.2em), content)
    )
  }
  else {
    stack(
      block(fill: header-color, radius: (top: 0.2em, bottom: 0cm), header),
      block(fill: body-color, radius: (top: 0cm, bottom: 0.2em), content),
    )
  }
}
