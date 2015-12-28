#' <Add Title>
#'
#' <Add Description>
#' 
#' @example ./inst/examples/example_d3kit_timeline.R
#'
#' @import htmlwidgets
#'
#' @export
d3kit_timeline <- function(
  data = NULL,
  margin = NULL,
  initialWidth = NULL,
  initialHeight = NULL,
  direction = NULL,
  keyFn = NULL,
  timeFn = NULL,
  textFn = NULL,
  labella = NULL,
  layerGap = NULL,
  dotRadius = NULL,
  dotColor = NULL,
  labelBgColor = NULL,
  labelTextColor = NULL,
  linkColor = NULL,
  labelPadding = NULL,
  textYOffset = NULL,
  ...,
  width = NULL, height = NULL,
  elementId = NULL
) {

  # forward options using x
  x = list(
    data = data,
    options = Filter(
      Negate(is.null),
      list(
        margin = margin,
        initialWidth = initialWidth,
        initialHeight = initialHeight,
        direction = direction,
        keyFn = keyFn,
        timeFn = timeFn,
        textFn = textFn,
        labella = labella,
        layerGap = layerGap,
        dotRadius = dotRadius,
        dotColor = dotColor,
        labelBgColor = labelBgColor,
        labelTextColor = labelTextColor,
        linkColor = linkColor,
        labelPadding = labelPadding,
        textYOffset = textYOffset,
        ...
      )
    )
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'd3kit-timeline',
    x,
    width = width,
    height = height,
    package = 'timelineR', 
    elementId = elementId
  )
}
