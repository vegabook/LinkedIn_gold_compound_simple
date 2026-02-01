#set page(paper: "us-legal", columns: 1, margin: 1cm)
#import "@preview/lilaq:0.5.0" as lq

#let string-to-date(str) = toml(bytes("v=" + str)).v

#let data = lq.load-txt(
  read("goldidxs.csv"),
  converters: ("date": string-to-date),
  header: true,
)

#let arange = range(0, data.date.len()).rev()
#let rangegold = arange.zip(data.gold)
#let lastgold = rangegold.map(x => if x.at(0) == 0 {x.at(1)} else {none})

#block[
  #lq.diagram(
    width: 10cm,
    height: 8cm,
    title: "gold",
    lq.plot(
      data.date, 
      data.gold,
      mark: none
    ),
    lq.plot(
      data.date,
      data.simple_gold,
      mark: none
    ),
    /* THIS DOES NOT WORK AS lq.plot does not accept "none"
    lq.plot(
      data.date,
      lastgold
    )
    */
  )
]
