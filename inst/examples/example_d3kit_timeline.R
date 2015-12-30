# devtools::install_github("timelyportfolio/timelineR")
library(timelineR)

# use examples from http://kristw.github.io/d3kit-timeline/#
# define starwars release data used in all the examples
starwars_data <- data.frame(
  time = c(
    "1977-04-25",
    "1980-04-17",
    "1984-04-25",
    "1999-04-19",
    "2002-04-16",
    "2005-04-19",
    "2015-11-18"
  ),
  episode = c(4,5,6,1,2,3,7),
  name = c(
    'A New Hope',
    'The Empire Strikes Back',
    'Return of the Jedi',
    'The Phantom Menace',
    'Attack of the Clones',
    'Revenge of the Sith',
    'The Force Awakens'
  ),
  stringsAsFactors = FALSE
)

d3kit_timeline(
  starwars_data,
  direction = "right",
  textFn = htmlwidgets::JS(
"
function(d){
    return new Date(d.time).getFullYear() + ' - ' + d.name;
}
"
  ),
  width = 400,
  height = 250
)

d3kit_timeline(
  starwars_data,
  direction = "right",
  # not necessary; tries to force convert to JavaScript Date
  timeFn = htmlwidgets::JS(
"
function(d){
  return new Date(d.time);
}
"
  ),
  textFn = "name",
  width = 400,
  height = 250
)

d3kit_timeline(
  starwars_data,
  direction = "right",
  textFn = ~name,
  width = 400,
  height = 250
)

# more advanced formula for textFn
d3kit_timeline(
  starwars_data,
  direction = "right",
  textFn = ~paste0(name,"- Episode ",episode),
  width = 400,
  height = 250
)


add_axis(
  d3kit_timeline(
    starwars_data,
    direction = "left",
    labelBgColor = '#777',
    linkColor = '#777',
    textFn = htmlwidgets::JS(
"
function(d){
  return new Date(d.time).getFullYear() + ' - ' + d.name;
}
"
    ),
    margin = list(left=20, right=20, top=20, bottom=20),
    width = 400,
    height = 250
  ),
  ticks = 0,
  tickSize = 0
)

library(dplyr)
library(scales)

d3kit_timeline(
  starwars_data %>%
    mutate( color = col_factor( palette = "Set1", domain = NULL)(.$name)),
  direction = "down",
  layerGap = 40,
  labella = list(maxPos = 800),
  textFn = htmlwidgets::JS(
"
function(d){
  return d.name;
}
"
  ),
  dotColor = htmlwidgets::JS(
"
function(d){
  return d.color;
}
"
  ),
  labelBgColor = htmlwidgets::JS(
"
function(d){
  return d.color;
}
"
  ),
  linkColor = htmlwidgets::JS(
  "
function(d){
  return d.color;
}
  "
  ),
  margin = list(left=20, right=20, top=30, bottom=20),
  width = 804,
  height = 160
)

colorJS <- htmlwidgets::JS("function(d){ return d.color; }")

d3kit_timeline(
  starwars_data %>%
    mutate( color = col_factor( palette = "Set2", domain = NULL)(ceiling(.$episode/3)) ),
  direction = "up",
  layerGap = 40,
  labella = list(maxPos = 800, algorithm = "simple"),
  textFn = ~name,
  dotColor = colorJS,
  labelBgColor = colorJS,
  linkColor = colorJS,
  margin = list(left=20, right=20, top=20, bottom=30),
  width = 804,
  height = 160
)


\dontrun{
  # demonstrate use with xts
  library(xts)
  library(timelineR)
  
  xts_data <- xts(
    paste0("random pt ",1:12),
    order.by = seq.Date(
      as.Date("2015-01-01"),
      by = "months",
      length.out=12
    ) + floor(runif(12,0,28))
  )
  colnames(xts_data) <- "label"
  
  d3kit_timeline(
    xts_data,
    textFn = ~label,
    margin = list(right = 20, left = 100, bottom = 20, top = 20)
  )
}
