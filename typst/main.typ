#set page(paper: "us-legal", columns: 1, margin: 1cm)

#import "@preview/lilaq:0.5.0" as lq

#let string-to-date(str) = toml(bytes("v=" + str)).v

#let data = lq.load-txt(
  read("goldidxs.csv"),
  converters: ("date": string-to-date),
  header: true,
)

#block[
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    title: "gold",
    lq.plot(
      data.date, 
      data.gold,
      mark: none,
    )
  )
]
