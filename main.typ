#import "emqx-slides.typ": emqx-slides, frame

#show: emqx-slides.with(
  font-family: none,
  title: "EMQX Super new feature",
  subtitle: "Doing this and that",
  date: "2024",
  authors: ("Ilia Averianov", "EMQX Team"),
  layout: "medium",
  ratio: 4/3,
  title-color: none,
)

== Slide 1 #lorem(10)

XXXX

- Bullet 1
- Bullet 2
- Bullet 3
  - Sub-bullet 1
  - Sub-bullet 2
  - Sub-bullet 3

Content

== Slide 2

#frame(
  title: "Slide 2 frame",
  [Some content]
)

#frame(
  [Some othe content]
)

#lorem(100)

