#' Simple `d3.js` Timeline Plots
#'
#' Produce `d3.js` timelines along a single axis with very good labelling using
#'   \href{https://github.com/kristw/d3kit-timeline}{d3kit-timeline}
#'   and \href{https://github.com/twitter/labella.js}{labella.js}.  Since
#'   \code{d3kit_timeline} is an \code{htmlwidget}, it should work seamlessly in 
#'   nearly all R contexts, such as console, \code{rmarkdown}, \code{Shiny}, and the
#'   browser.
#' 
#' @param data any table like structure, such as \code{data.frame}, \code{xts}, or \code{matrix}
#' @param margin \code{list} to specify the margin.  The default is
#'              \code{list(left = 40, right = 20, top = 20, bottom = 20)}.
#' @param initialWidth,initialHeight although this is provided to be consistent with the API, please use
#'              \code{height} and \code{width} instead
#' @param direction \code{character} for the location of the labels relative to the axis
#' @param keyFn either a \code{character} of a column name in \code{data},
#'              an R \link[stats]{formula}, such as \code{~key}, or a
#'              \link[htmlwidget]{JS} function specifying the identifier for each data point.
#' @param timeFn either a \code{character} of a column name in \code{data},
#'              an R \link[stats]{formula}, such as \code{~time}, or a
#'              \link[htmlwidget]{JS} function specifying the time of each data point.
#' @param textFn either a \code{character} of a column name in \code{data},
#'              an R \link[stats]{formula}, such as \code{~text}, or a
#'              \link[htmlwidget]{JS} function specifying the text label for each data point.
#' @param labella \code{list} of options for Labella.js.  See \href{https://github.com/twitter/labella.js/blob/master/docs/Force.md\#constructor}{Labella.js docs}.
#' @param layerGap \code{integer} distance from the axis to the first layer of labels
#'              and between each layer of labels (in situations where all labels
#'              cannot fit within one layer)
#' @param dotRadius \code{integer} in \code{px} or a \link[htmlwidget]{JS} function
#'              for the radius of the dots
#' @param dotColor color in hex format or a \link[htmlwidget]{JS} function for the color of the dot
#' @param labelBgColor color in hex format or a \link[htmlwidget]{JS} function for the background of the label
#' @param labelTextColor color in hex format or a \link[htmlwidget]{JS} function for the text of the label
#' @param linkColor color in hex format or a \link[htmlwidget]{JS} function for the color of the link between the dots and label
#' @param labelPadding \code{list} in the format \code{list(left=,right=,top=,bottom=)} for the space
#'              to add around the text within each label
#' @param textYOffset valid \code{CSS} size for the vertical offset for text within each label
#' @param ... any additional arguments provided in \code{...} will be considered as
#'              \code{options} provided to \code{d3kit-timeline}
#' @param width,height any valid \code{CSS} size unit for the height and width
#'              of the \code{div} container
#' @param elementId 
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
  
  # this is not a thing of beauty;  happily taking suggestions
  # Argument Handler for \link{d3kit_timeline}
  #
  # Resolve the various types of arguments for \code{keyFn}, \code{timeFn}, and \code{textFn}
  #  for \code{d3kit_timeline}.
  #  
  # fn either a \code{character} of a column name in \code{data},
  #              an R \link[stats]{formula}, such as \code{~text}, or a
  #              \link[htmlwidget]{JS} function
  # returns htmlwidget::JS
  
  resolve_fn_arg <- function(fn){
    # adapted from https://github.com/jcheng5/d3scatter/blob/master/R/d3scatter.R
    varname <- NULL
    
    if(inherits(fn,"formula")){
      varname <- fn[[2]]
    }
    
    if(inherits(varname,"name")) {
      varname <- deparse(varname)
    }
    
    if(inherits(varname,"call")) {
      data <<- data.frame(
        data,
        eval(varname, data, environment(varname)),
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
      colnames(data)[ncol(data)] <<- deparse(varname)
      varname <- deparse(varname)
    }
    
    if(inherits(fn,"JS_EVAL")) {
      return(fn)
    }
    
    if(inherits(fn,"character")) {
      varname <- fn
    }
    
    if(inherits(varname,"character")) {
      htmlwidgets::JS(sprintf("function(d){return d['%s']}",varname))
    }
  }
  
  Map(
    function(fnarg){
      if(!is.null(get(fnarg))){
        assign(fnarg,resolve_fn_arg(get(fnarg)),inherits=TRUE)
      }
    }, 
    c("keyFn", "timeFn", "textFn")
  )  

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
