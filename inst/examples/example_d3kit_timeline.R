# devtools::install_github("timelyportfolio/timelineR")
library(timelineR)

# use example from http://kristw.github.io/d3kit-timeline/#
d3kit_timeline(
  data.frame(
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
  ),
  direction = "right",
  timeFn = htmlwidgets::JS(
"
  function(d){
    return new Date(d.time);
  }
"
  ),
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
