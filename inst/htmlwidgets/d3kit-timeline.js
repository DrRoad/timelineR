HTMLWidgets.widget({

  name: 'd3kit-timeline',

  type: 'output',

  factory: function(el, width, height) {
    
    var chart = {}; 

    return {
      renderValue: function(x) {
        // clean out el container in case of dynamic/Shiny
        el.innerHTML = "";
        
        // get width and height from el container
        var width = el.getBoundingClientRect().width;
        var height = el.getBoundingClientRect().height;
        
        // add width and height to options
        x.options.initialWidth = width;
        x.options.initialHeight = height;
        
        // instantiate d3kit-timeline using options
        chart = new d3Kit.Timeline(el, x.options);
        
        // supply data in array of objects form
        chart.data(HTMLWidgets.dataframeToD3(x.data));
      },

      resize: function(width, height) {
        
      },
      
      timeline: chart
    };
    
  }
});