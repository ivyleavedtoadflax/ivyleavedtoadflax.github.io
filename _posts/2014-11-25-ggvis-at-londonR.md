---
title: "ggvis sessions"
author: "Matthew Upson"
date: '2014-11-25'
output: html_document
layout: post
excerpt: ggvis workshop at LondonR by Aimee Gott
published: true
status: publish
comments: yes
---
 
# LondonR 
 
I went to my first LondonR meeting tonight hosted by [Mango solutions](http://www.mango-solutions.com/wp/). Some really great talks - especially presentatiosn by Matt Sundquist of plotly.
 
Mango solutions also presented a good introduction to `ggvis` and some of the interactive elements. I've included my notes from the event below.
 

{% highlight r %}
library(dplyr)
{% endhighlight %}



{% highlight text %}
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
{% endhighlight %}



{% highlight r %}
library(ggplot2)
 
tubeData <- read.table(
  "../tubeData.csv",
  sep = ",",
  header = T
  )
{% endhighlight %}



{% highlight text %}
## Warning in file(file, "rt"): cannot open file '../tubeData.csv': No such
## file or directory
{% endhighlight %}



{% highlight text %}
## Error in file(file, "rt"): cannot open the connection
{% endhighlight %}



{% highlight r %}
str(tubeData)
{% endhighlight %}



{% highlight text %}
## Error in str(tubeData): object 'tubeData' not found
{% endhighlight %}
 
#### Outline
 
* ggplot2
* ggvis
* %>%
* Aesthetics
* Layers
* Interactivity
 
#### The Data
 
* Tube performance data from TFL website.
* [Available here](http://data.london.gov.uk/dataset/tube-network-performance-data-transport-committee-report)
 
#### ggplot2 recap
 
* `qplot` or `ggplot`
* Add layers with +
* Change aesthetics by variable with `aes`
* Control plot type with `geom`
* Panel using `facet_`
 

{% highlight r %}
head(tubeData)
{% endhighlight %}



{% highlight text %}
## Error in head(tubeData): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
qplot(
  data = tubeData,
  x = Month,
  y = Excess
  )
{% endhighlight %}



{% highlight text %}
## Error in ggplot(data, aesthetics, environment = env): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
qplot(
  data = tubeData,
  x = Month,
  y = Excess,
  col = Line
  )
{% endhighlight %}



{% highlight text %}
## Error in ggplot(data, aesthetics, environment = env): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
qplot(
  data = tubeData,
  x = Month,
  y = Excess,
  col = Line
  ) +
  facet_wrap(
    ~Line
    )
{% endhighlight %}



{% highlight text %}
## Error in ggplot(data, aesthetics, environment = env): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
qplot(
  data = tubeData,
  x = Month,
  y = Excess,
  col = Line
  ) +
  facet_wrap(
    ~Line
    ) +
  geom_smooth(
    col = "red",
    size = 1
    )
{% endhighlight %}



{% highlight text %}
## Error in ggplot(data, aesthetics, environment = env): object 'tubeData' not found
{% endhighlight %}
 
#### The 'geoms'
 

{% highlight r %}
grep(
  "geom", 
  objects("package:ggplot2"), 
  value = TRUE
  )
{% endhighlight %}



{% highlight text %}
##  [1] "geom_abline"          "geom_area"            "geom_bar"            
##  [4] "geom_bin2d"           "geom_blank"           "geom_boxplot"        
##  [7] "geom_contour"         "geom_crossbar"        "geom_density"        
## [10] "geom_density2d"       "geom_dotplot"         "geom_errorbar"       
## [13] "geom_errorbarh"       "geom_freqpoly"        "geom_hex"            
## [16] "geom_histogram"       "geom_hline"           "geom_jitter"         
## [19] "geom_line"            "geom_linerange"       "geom_map"            
## [22] "geom_path"            "geom_point"           "geom_pointrange"     
## [25] "geom_polygon"         "geom_quantile"        "geom_raster"         
## [28] "geom_rect"            "geom_ribbon"          "geom_rug"            
## [31] "geom_segment"         "geom_smooth"          "geom_step"           
## [34] "geom_text"            "geom_tile"            "geom_violin"         
## [37] "geom_vline"           "update_geom_defaults"
{% endhighlight %}
 
#### Facetting
 
* Panels using `facet_wrap` and `facet_grid`.
 
#### Scales and themes
 
* axes and styles
* themes e.g. `theme_bw` etc
 

{% highlight r %}
qplot(
  data = tubeData,
  x = Month,
  y = Excess,
  col = Line
  ) +
  facet_wrap(
    ~Line
    ) +
  geom_smooth(
    col = "red",
    size = 1
    ) +
  theme_bw()
{% endhighlight %}



{% highlight text %}
## Error in ggplot(data, aesthetics, environment = env): object 'tubeData' not found
{% endhighlight %}
 
### Getting started with ggvis
 
* Plot with `ggvis` function
* Only a single function unlike `ggplot1`
* Use `~` when referring to variables in a dataset, e.g. `~Ozone`
* This refers to variables as formulas
* First variable always data.
 

{% highlight r %}
require(ggvis)
{% endhighlight %}



{% highlight text %}
## Loading required package: ggvis
## The ggvis API is currently rapidly evolving. We strongly recommend that you do not rely on this for production, but feel free to explore. If you encounter a clear bug, please file a minimal reproducible example at https://github.com/rstudio/ggvis/issues. For questions and other discussion, please use https://groups.google.com/group/ggvis.
## 
## Attaching package: 'ggvis'
## 
## The following object is masked from 'package:ggplot2':
## 
##     resolution
{% endhighlight %}



{% highlight r %}
myPlot <- ggvis(
  tubeData,
  ~Month,
  ~Excess
  )
{% endhighlight %}



{% highlight text %}
## Error in add_data(vis, data, deparse2(substitute(data))): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
# Creates a ggvis object:
 
class(myPlot)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'myPlot' not found
{% endhighlight %}



{% highlight r %}
# Graphic is produced in the Viewer pane, not the Plots pane. Works via java vega a .d3 package
 
myPlot
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'myPlot' not found
{% endhighlight %}



{% highlight r %}
# Note settings cog in the top right which allows you to change the rendering of teh plot.
 
# Can view in web browser and then be saved as an html file.
# Because it is not written to standard plotting device, you need to render the graphoc before you can save it out - i.e. no png or pdf command
# No equivalent script to save out of ggvis - must be saved from a browser
 
layer_points(myPlot)
{% endhighlight %}



{% highlight text %}
## Error in add_mark(vis, "symbol", props(..., env = parent.frame()), data, : object 'myPlot' not found
{% endhighlight %}



{% highlight r %}
# Can also be used in the pupe
 
myPlot %>% layer_points
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'myPlot' not found
{% endhighlight %}
 
 
#### The %>% operator
 
* `ggvis` uses `%>%` from `magrittr` like `dplyr`
* 
 

{% highlight r %}
mean(airquality$Ozone,na.rm=TRUE)
{% endhighlight %}



{% highlight text %}
## [1] 42.12931
{% endhighlight %}



{% highlight r %}
# Now with the pipe
 
airquality$Ozone %>% mean(na.rm = TRUE)
{% endhighlight %}



{% highlight text %}
## [1] 42.12931
{% endhighlight %}



{% highlight r %}
# dplyr example
 
require(dplyr)
 
tubeData %>%
  dplyr::group_by(Line) %>%
  dplyr::summarise(mean = mean(Excess)) %>%
  qplot(Line, mean, data = ., geom="bar", stat = "identity", fill = Line)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
#### %>% in ggvis
 
* We pass `ggvis` objects mostly.
* All functions accept a ggvis object first, except the command `ggvis`
* Initial `ggvis` object is created with the `ggvis` command.
* e.g.: 
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
#### Changing properties
 
* Properties in `ggvis` are the same as aesthetics in `ggplot2`
* Number of aesthetics that can be set:
- stroke -- refers to lines
- fill
- size
- opacity -- instead of alpha
 
#### Changing based on variables
 
* Mapping and setting as with `aes`
* Map a variable to a property with `=`
* Remember to use `~` with all variable names
* fill = ~Line would set the fill based on the Line variable
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    fill = ~Line
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    fill = ~Line,
    shape = ~Line
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    size = ~Stations
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
# can be set for all layers:
 
tubeData %>%
  ggvis(
    ~Month,
    ~Excess,
    fill = ~Line
    ) %>%
  layer_points
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
#### Setting property values
 
* Instead of `col = I("red")`  in `ggplot2` is not required. This prevents `ggplot2` picking red up as a fcator.
* `fill := "red"` will work in `ggvis`
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess,
    fill = "red",
    opacity := 0.5
    ) %>%
  layer_points
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess,
    fill := "red",
    opacity := 0.5
    ) %>%
  layer_points
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
* Shaping has changed in ggvis as it is dependent on .d3
* At the moment a limited subset only is available
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess,
    fill := "red",
    opacity := 0.5,
    shape := "square"
    ) %>%
  layer_points
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
#### Exercise
 
* Create a plot of `mpg` against `wt` using `mtcars` data
* Use colour for the `cyl` variable, and make it a factor
* Update the plotting symbol to be triangles
 

{% highlight r %}
mtcars %>%
  ggvis(
    ~mpg,
    ~wt
    ) %>%
  layer_points(
    fill = ~factor(cyl),
    # Why doesn't this work!?
    shape := "triangle-up"
    )
{% endhighlight %}

<!--html_preserve--><div id="plot_id210545126-container" class="ggvis-output-container">
<div id="plot_id210545126" class="ggvis-output"></div>
<div class="plot-gear-icon">
<nav class="ggvis-control">
<a class="ggvis-dropdown-toggle" title="Controls" onclick="return false;"></a>
<ul class="ggvis-dropdown">
<li>
Renderer: 
<a id="plot_id210545126_renderer_svg" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id210545126" data-renderer="svg">SVG</a>
 | 
<a id="plot_id210545126_renderer_canvas" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id210545126" data-renderer="canvas">Canvas</a>
</li>
<li>
<a id="plot_id210545126_download" class="ggvis-download" data-plot-id="plot_id210545126">Download</a>
</li>
</ul>
</nav>
</div>
</div>
<script type="text/javascript">
var plot_id210545126_spec = {
    "data": [
        {
            "name": ".0",
            "format": {
                "type": "csv",
                "parse": {
                    "mpg": "number",
                    "wt": "number"
                }
            },
            "values": "\"mpg\",\"wt\",\"factor(cyl)\"\n21,2.62,\"6\"\n21,2.875,\"6\"\n22.8,2.32,\"4\"\n21.4,3.215,\"6\"\n18.7,3.44,\"8\"\n18.1,3.46,\"6\"\n14.3,3.57,\"8\"\n24.4,3.19,\"4\"\n22.8,3.15,\"4\"\n19.2,3.44,\"6\"\n17.8,3.44,\"6\"\n16.4,4.07,\"8\"\n17.3,3.73,\"8\"\n15.2,3.78,\"8\"\n10.4,5.25,\"8\"\n10.4,5.424,\"8\"\n14.7,5.345,\"8\"\n32.4,2.2,\"4\"\n30.4,1.615,\"4\"\n33.9,1.835,\"4\"\n21.5,2.465,\"4\"\n15.5,3.52,\"8\"\n15.2,3.435,\"8\"\n13.3,3.84,\"8\"\n19.2,3.845,\"8\"\n27.3,1.935,\"4\"\n26,2.14,\"4\"\n30.4,1.513,\"4\"\n15.8,3.17,\"8\"\n19.7,2.77,\"6\"\n15,3.57,\"8\"\n21.4,2.78,\"4\""
        },
        {
            "name": "scale/fill",
            "format": {
                "type": "csv",
                "parse": {

                }
            },
            "values": "\"domain\"\n\"4\"\n\"6\"\n\"8\""
        },
        {
            "name": "scale/x",
            "format": {
                "type": "csv",
                "parse": {
                    "domain": "number"
                }
            },
            "values": "\"domain\"\n9.225\n35.075"
        },
        {
            "name": "scale/y",
            "format": {
                "type": "csv",
                "parse": {
                    "domain": "number"
                }
            },
            "values": "\"domain\"\n1.31745\n5.61955"
        }
    ],
    "scales": [
        {
            "name": "fill",
            "type": "ordinal",
            "domain": {
                "data": "scale/fill",
                "field": "data.domain"
            },
            "points": true,
            "sort": false,
            "range": "category10"
        },
        {
            "name": "x",
            "domain": {
                "data": "scale/x",
                "field": "data.domain"
            },
            "zero": false,
            "nice": false,
            "clamp": false,
            "range": "width"
        },
        {
            "name": "y",
            "domain": {
                "data": "scale/y",
                "field": "data.domain"
            },
            "zero": false,
            "nice": false,
            "clamp": false,
            "range": "height"
        }
    ],
    "marks": [
        {
            "type": "symbol",
            "properties": {
                "update": {
                    "size": {
                        "value": 50
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.mpg"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.wt"
                    },
                    "fill": {
                        "scale": "fill",
                        "field": "data.factor(cyl)"
                    },
                    "shape": {
                        "value": "triangle-up"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0"
                    }
                }
            },
            "from": {
                "data": ".0"
            }
        }
    ],
    "width": 504,
    "height": 504,
    "legends": [
        {
            "orient": "right",
            "fill": "fill",
            "title": "factor(cyl)"
        }
    ],
    "axes": [
        {
            "type": "x",
            "scale": "x",
            "orient": "bottom",
            "layer": "back",
            "grid": true,
            "title": "mpg"
        },
        {
            "type": "y",
            "scale": "y",
            "orient": "left",
            "layer": "back",
            "grid": true,
            "title": "wt"
        }
    ],
    "padding": null,
    "ggvis_opts": {
        "keep_aspect": false,
        "resizable": true,
        "padding": {

        },
        "duration": 250,
        "renderer": "svg",
        "hover_duration": 0,
        "width": 504,
        "height": 504
    },
    "handlers": null
}
;
ggvis.getPlot("plot_id210545126").parseSpec(plot_id210545126_spec);
</script><!--/html_preserve-->
 
#### Adding layers
 
* In `ggvis` we use `layer_` instead of `geom_`
* Major limitation of `ggvis` at present, as not all of the `geoms_` are vailable as `layer_` in `ggvis`.
* Check package manual:
 
<!--
|Function|Description|
|--------|-----------|
|layer_points||
|layer_histograms||
|layer_boxplots||
|layer_lines||
|layer_smooths||
-->
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Line,
    ~Excess
    ) %>%
  layer_boxplots()
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
# Adding some extra layers
 
mtcars %>%
  ggvis(
    ~mpg,
    ~wt
    ) %>%
  layer_points(
    fill = ~factor(cyl),
    # Why doesn't this work!?
    shape := "triangle"
    ) %>% 
  layer_smooths() %>%
  layer_model_predictions(
    model = "lm"
    )
{% endhighlight %}



{% highlight text %}
## Guessing formula = wt ~ mpg
{% endhighlight %}

<!--html_preserve--><div id="plot_id440862119-container" class="ggvis-output-container">
<div id="plot_id440862119" class="ggvis-output"></div>
<div class="plot-gear-icon">
<nav class="ggvis-control">
<a class="ggvis-dropdown-toggle" title="Controls" onclick="return false;"></a>
<ul class="ggvis-dropdown">
<li>
Renderer: 
<a id="plot_id440862119_renderer_svg" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id440862119" data-renderer="svg">SVG</a>
 | 
<a id="plot_id440862119_renderer_canvas" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id440862119" data-renderer="canvas">Canvas</a>
</li>
<li>
<a id="plot_id440862119_download" class="ggvis-download" data-plot-id="plot_id440862119">Download</a>
</li>
</ul>
</nav>
</div>
</div>
<script type="text/javascript">
var plot_id440862119_spec = {
    "data": [
        {
            "name": ".0",
            "format": {
                "type": "csv",
                "parse": {
                    "mpg": "number",
                    "wt": "number"
                }
            },
            "values": "\"mpg\",\"wt\",\"factor(cyl)\"\n21,2.62,\"6\"\n21,2.875,\"6\"\n22.8,2.32,\"4\"\n21.4,3.215,\"6\"\n18.7,3.44,\"8\"\n18.1,3.46,\"6\"\n14.3,3.57,\"8\"\n24.4,3.19,\"4\"\n22.8,3.15,\"4\"\n19.2,3.44,\"6\"\n17.8,3.44,\"6\"\n16.4,4.07,\"8\"\n17.3,3.73,\"8\"\n15.2,3.78,\"8\"\n10.4,5.25,\"8\"\n10.4,5.424,\"8\"\n14.7,5.345,\"8\"\n32.4,2.2,\"4\"\n30.4,1.615,\"4\"\n33.9,1.835,\"4\"\n21.5,2.465,\"4\"\n15.5,3.52,\"8\"\n15.2,3.435,\"8\"\n13.3,3.84,\"8\"\n19.2,3.845,\"8\"\n27.3,1.935,\"4\"\n26,2.14,\"4\"\n30.4,1.513,\"4\"\n15.8,3.17,\"8\"\n19.7,2.77,\"6\"\n15,3.57,\"8\"\n21.4,2.78,\"4\""
        },
        {
            "name": ".0/model_prediction1",
            "format": {
                "type": "csv",
                "parse": {
                    "pred_": "number",
                    "resp_": "number"
                }
            },
            "values": "\"pred_\",\"resp_\"\n10.4,5.26709870786738\n10.6974683544304,5.14704047855112\n10.9949367088608,5.03118876520954\n11.2924050632911,4.91950899506212\n11.5898734177215,4.81196659532837\n11.8873417721519,4.70852699322776\n12.1848101265823,4.6091556159798\n12.4822784810127,4.51381789080397\n12.779746835443,4.42247924491978\n13.0772151898734,4.33510510554671\n13.3746835443038,4.25171377248888\n13.6721518987342,4.17322495920078\n13.9696202531646,4.09937968773676\n14.2670886075949,4.02937682750615\n14.5645569620253,3.96241524791825\n14.8620253164557,3.89901422494375\n15.1594936708861,3.84312733060352\n15.4569620253165,3.79025491272949\n15.7544303797468,3.74131843080013\n16.0518987341772,3.70318820076903\n16.3493670886076,3.67282222701719\n16.646835443038,3.64700052597305\n16.9443037974684,3.62250311406507\n17.2417721518987,3.59611000772168\n17.5392405063291,3.56460122337134\n17.8367088607595,3.5248055796778\n18.1341772151899,3.47838183528461\n18.4316455696203,3.42863815827054\n18.7291139240506,3.37701737152651\n19.026582278481,3.32496229794347\n19.3240506329114,3.2726173323394\n19.6215189873418,3.21156757675365\n19.9189873417722,3.14421038563615\n20.2164556962025,3.07569029842942\n20.5139240506329,3.01115185457599\n20.8113924050633,2.95573959351838\n21.1088607594937,2.91553607179047\n21.4063291139241,2.88630635433215\n21.7037974683544,2.84793204808514\n22.0012658227848,2.80989137002157\n22.2987341772152,2.77165845439756\n22.5962025316456,2.73270743546925\n22.8936708860759,2.69252434983033\n23.1911392405063,2.6509919635426\n23.4886075949367,2.60839825876548\n23.7860759493671,2.5650391649457\n24.0835443037975,2.52121061152996\n24.3810126582278,2.47720852796498\n24.6784810126582,2.43332884369748\n24.9759493670886,2.38986748817416\n25.273417721519,2.34712039084176\n25.5708860759494,2.30538348114698\n25.8683544303797,2.26495268853653\n26.1658227848101,2.22612394245714\n26.4632911392405,2.18919317235551\n26.7607594936709,2.15445630767837\n27.0582278481013,2.12220927787242\n27.3556962025316,2.09271002326136\n27.653164556962,2.06479889572395\n27.9506329113924,2.03789645504918\n28.2481012658228,2.01211937280276\n28.5455696202532,1.98758432055039\n28.8430379746835,1.96440796985775\n29.1405063291139,1.94270699229056\n29.4379746835443,1.9225980594145\n29.7354430379747,1.90419784279527\n30.0329113924051,1.88762301399857\n30.3303797468354,1.87299024459011\n30.6278481012658,1.86028970448271\n30.9253164556962,1.84928668066065\n31.2227848101266,1.8399745891983\n31.520253164557,1.83235763010661\n31.8177215189873,1.82644000339654\n32.1151898734177,1.82222590907903\n32.4126582278481,1.81971954716503\n32.7101265822785,1.81892511766548\n33.0075949367089,1.81984682059132\n33.3050632911392,1.82248885595352\n33.6025316455696,1.826855423763\n33.9,1.83295072403073"
        },
        {
            "name": ".0/model_prediction2",
            "format": {
                "type": "csv",
                "parse": {
                    "pred_": "number",
                    "resp_": "number"
                }
            },
            "values": "\"pred_\",\"resp_\"\n10.4,4.5822905267902\n10.6974683544304,4.54038854841057\n10.9949367088608,4.49848657003095\n11.2924050632911,4.45658459165132\n11.5898734177215,4.4146826132717\n11.8873417721519,4.37278063489207\n12.1848101265823,4.33087865651245\n12.4822784810127,4.28897667813282\n12.779746835443,4.2470746997532\n13.0772151898734,4.20517272137357\n13.3746835443038,4.16327074299394\n13.6721518987342,4.12136876461432\n13.9696202531646,4.07946678623469\n14.2670886075949,4.03756480785507\n14.5645569620253,3.99566282947544\n14.8620253164557,3.95376085109582\n15.1594936708861,3.91185887271619\n15.4569620253165,3.86995689433656\n15.7544303797468,3.82805491595694\n16.0518987341772,3.78615293757731\n16.3493670886076,3.74425095919769\n16.646835443038,3.70234898081806\n16.9443037974684,3.66044700243844\n17.2417721518987,3.61854502405881\n17.5392405063291,3.57664304567918\n17.8367088607595,3.53474106729956\n18.1341772151899,3.49283908891993\n18.4316455696203,3.45093711054031\n18.7291139240506,3.40903513216068\n19.026582278481,3.36713315378106\n19.3240506329114,3.32523117540143\n19.6215189873418,3.2833291970218\n19.9189873417722,3.24142721864218\n20.2164556962025,3.19952524026255\n20.5139240506329,3.15762326188293\n20.8113924050633,3.1157212835033\n21.1088607594937,3.07381930512368\n21.4063291139241,3.03191732674405\n21.7037974683544,2.99001534836442\n22.0012658227848,2.9481133699848\n22.2987341772152,2.90621139160517\n22.5962025316456,2.86430941322555\n22.8936708860759,2.82240743484592\n23.1911392405063,2.7805054564663\n23.4886075949367,2.73860347808667\n23.7860759493671,2.69670149970705\n24.0835443037975,2.65479952132742\n24.3810126582278,2.61289754294779\n24.6784810126582,2.57099556456817\n24.9759493670886,2.52909358618854\n25.273417721519,2.48719160780892\n25.5708860759494,2.44528962942929\n25.8683544303797,2.40338765104967\n26.1658227848101,2.36148567267004\n26.4632911392405,2.31958369429041\n26.7607594936709,2.27768171591079\n27.0582278481013,2.23577973753116\n27.3556962025316,2.19387775915154\n27.653164556962,2.15197578077191\n27.9506329113924,2.11007380239229\n28.2481012658228,2.06817182401266\n28.5455696202532,2.02626984563303\n28.8430379746835,1.98436786725341\n29.1405063291139,1.94246588887378\n29.4379746835443,1.90056391049416\n29.7354430379747,1.85866193211453\n30.0329113924051,1.81675995373491\n30.3303797468354,1.77485797535528\n30.6278481012658,1.73295599697566\n30.9253164556962,1.69105401859603\n31.2227848101266,1.6491520402164\n31.520253164557,1.60725006183678\n31.8177215189873,1.56534808345715\n32.1151898734177,1.52344610507753\n32.4126582278481,1.4815441266979\n32.7101265822785,1.43964214831828\n33.0075949367089,1.39774016993865\n33.3050632911392,1.35583819155902\n33.6025316455696,1.3139362131794\n33.9,1.27203423479977"
        },
        {
            "name": "scale/fill",
            "format": {
                "type": "csv",
                "parse": {

                }
            },
            "values": "\"domain\"\n\"4\"\n\"6\"\n\"8\""
        },
        {
            "name": "scale/x",
            "format": {
                "type": "csv",
                "parse": {
                    "domain": "number"
                }
            },
            "values": "\"domain\"\n9.225\n35.075"
        },
        {
            "name": "scale/y",
            "format": {
                "type": "csv",
                "parse": {
                    "domain": "number"
                }
            },
            "values": "\"domain\"\n1.06443594653976\n5.63159828826001"
        }
    ],
    "scales": [
        {
            "name": "fill",
            "type": "ordinal",
            "domain": {
                "data": "scale/fill",
                "field": "data.domain"
            },
            "points": true,
            "sort": false,
            "range": "category10"
        },
        {
            "name": "x",
            "domain": {
                "data": "scale/x",
                "field": "data.domain"
            },
            "zero": false,
            "nice": false,
            "clamp": false,
            "range": "width"
        },
        {
            "name": "y",
            "domain": {
                "data": "scale/y",
                "field": "data.domain"
            },
            "zero": false,
            "nice": false,
            "clamp": false,
            "range": "height"
        }
    ],
    "marks": [
        {
            "type": "symbol",
            "properties": {
                "update": {
                    "size": {
                        "value": 50
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.mpg"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.wt"
                    },
                    "fill": {
                        "scale": "fill",
                        "field": "data.factor(cyl)"
                    },
                    "shape": {
                        "value": "triangle"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0"
                    }
                }
            },
            "from": {
                "data": ".0"
            }
        },
        {
            "type": "line",
            "properties": {
                "update": {
                    "stroke": {
                        "value": "#000000"
                    },
                    "strokeWidth": {
                        "value": 2
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.pred_"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.resp_"
                    },
                    "fill": {
                        "value": "transparent"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0/model_prediction1"
                    }
                }
            },
            "from": {
                "data": ".0/model_prediction1"
            }
        },
        {
            "type": "line",
            "properties": {
                "update": {
                    "stroke": {
                        "value": "#000000"
                    },
                    "strokeWidth": {
                        "value": 2
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.pred_"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.resp_"
                    },
                    "fill": {
                        "value": "transparent"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0/model_prediction2"
                    }
                }
            },
            "from": {
                "data": ".0/model_prediction2"
            }
        }
    ],
    "width": 504,
    "height": 504,
    "legends": [
        {
            "orient": "right",
            "fill": "fill",
            "title": "factor(cyl)"
        }
    ],
    "axes": [
        {
            "type": "x",
            "scale": "x",
            "orient": "bottom",
            "layer": "back",
            "grid": true,
            "title": "mpg"
        },
        {
            "type": "y",
            "scale": "y",
            "orient": "left",
            "layer": "back",
            "grid": true,
            "title": "wt"
        }
    ],
    "padding": null,
    "ggvis_opts": {
        "keep_aspect": false,
        "resizable": true,
        "padding": {

        },
        "duration": 250,
        "renderer": "svg",
        "hover_duration": 0,
        "width": 504,
        "height": 504
    },
    "handlers": null
}
;
ggvis.getPlot("plot_id440862119").parseSpec(plot_id440862119_spec);
</script><!--/html_preserve-->

{% highlight r %}
# Note that formula can be specified with formula = ...
 
mtcars %>%
  ggvis(
    ~mpg,
    ~wt
    ) %>%
  layer_points(
    fill = ~factor(cyl),
    # Why doesn't this work!?
    shape := "triangle"
    ) %>% 
  layer_smooths(
    stroke := "blue",
    se = TRUE
    ) %>%
  layer_model_predictions(
    model = "lm",
    stroke := "red",
    se = TRUE
    )
{% endhighlight %}



{% highlight text %}
## Guessing formula = wt ~ mpg
{% endhighlight %}

<!--html_preserve--><div id="plot_id160020543-container" class="ggvis-output-container">
<div id="plot_id160020543" class="ggvis-output"></div>
<div class="plot-gear-icon">
<nav class="ggvis-control">
<a class="ggvis-dropdown-toggle" title="Controls" onclick="return false;"></a>
<ul class="ggvis-dropdown">
<li>
Renderer: 
<a id="plot_id160020543_renderer_svg" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id160020543" data-renderer="svg">SVG</a>
 | 
<a id="plot_id160020543_renderer_canvas" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id160020543" data-renderer="canvas">Canvas</a>
</li>
<li>
<a id="plot_id160020543_download" class="ggvis-download" data-plot-id="plot_id160020543">Download</a>
</li>
</ul>
</nav>
</div>
</div>
<script type="text/javascript">
var plot_id160020543_spec = {
    "data": [
        {
            "name": ".0",
            "format": {
                "type": "csv",
                "parse": {
                    "mpg": "number",
                    "wt": "number"
                }
            },
            "values": "\"mpg\",\"wt\",\"factor(cyl)\"\n21,2.62,\"6\"\n21,2.875,\"6\"\n22.8,2.32,\"4\"\n21.4,3.215,\"6\"\n18.7,3.44,\"8\"\n18.1,3.46,\"6\"\n14.3,3.57,\"8\"\n24.4,3.19,\"4\"\n22.8,3.15,\"4\"\n19.2,3.44,\"6\"\n17.8,3.44,\"6\"\n16.4,4.07,\"8\"\n17.3,3.73,\"8\"\n15.2,3.78,\"8\"\n10.4,5.25,\"8\"\n10.4,5.424,\"8\"\n14.7,5.345,\"8\"\n32.4,2.2,\"4\"\n30.4,1.615,\"4\"\n33.9,1.835,\"4\"\n21.5,2.465,\"4\"\n15.5,3.52,\"8\"\n15.2,3.435,\"8\"\n13.3,3.84,\"8\"\n19.2,3.845,\"8\"\n27.3,1.935,\"4\"\n26,2.14,\"4\"\n30.4,1.513,\"4\"\n15.8,3.17,\"8\"\n19.7,2.77,\"6\"\n15,3.57,\"8\"\n21.4,2.78,\"4\""
        },
        {
            "name": ".0/model_prediction1",
            "format": {
                "type": "csv",
                "parse": {
                    "resp_upr_": "number",
                    "pred_": "number",
                    "resp_lwr_": "number",
                    "resp_": "number"
                }
            },
            "values": "\"resp_upr_\",\"pred_\",\"resp_lwr_\",\"resp_\"\n5.90339788893925,10.4,4.6307995267955,5.26709870786738\n5.72552251014008,10.6974683544304,4.56855844696216,5.14704047855112\n5.55741214433124,10.9949367088608,4.50496538608783,5.03118876520954\n5.39915884937713,11.2924050632911,4.43985914074711,4.91950899506212\n5.25082900223027,11.5898734177215,4.37310418842646,4.81196659532837\n5.11243062091236,11.8873417721519,4.30462336554316,4.70852699322776\n4.98387131476528,12.1848101265823,4.23443991719432,4.6091556159798\n4.86491392699808,12.4822784810127,4.16272185460987,4.51381789080397\n4.75514320121354,12.779746835443,4.08981528862602,4.42247924491978\n4.65395902679661,13.0772151898734,4.01625118429681,4.33510510554671\n4.56063790065184,13.3746835443038,3.94278964432591,4.25171377248888\n4.47487904234217,13.6721518987342,3.87157087605938,4.17322495920078\n4.39564733324672,13.9696202531646,3.80311204222681,4.09937968773676\n4.321739476336,14.2670886075949,3.7370141786763,4.02937682750615\n4.25205947786786,14.5645569620253,3.67277101796864,3.96241524791825\n4.18648303755751,14.8620253164557,3.61154541232999,3.89901422494375\n4.12747457860028,15.1594936708861,3.55878008260675,3.84312733060352\n4.07169314263621,15.4569620253165,3.50881668282276,3.79025491272949\n4.01895215390886,15.7544303797468,3.4636847076914,3.74131843080013\n3.9754206611306,16.0518987341772,3.43095574040746,3.70318820076903\n3.94234825156483,16.3493670886076,3.40329620246954,3.67282222701719\n3.91974140081381,16.646835443038,3.37425965113229,3.64700052597305\n3.90486852598271,16.9443037974684,3.34013770214742,3.62250311406507\n3.89194101079161,17.2417721518987,3.30027900465175,3.59611000772168\n3.87318045416167,17.5392405063291,3.25602199258102,3.56460122337134\n3.84033995894664,17.8367088607595,3.20927120040897,3.5248055796778\n3.79487351677711,18.1341772151899,3.16189015379211,3.47838183528461\n3.74533617943497,18.4316455696203,3.1119401371061,3.42863815827054\n3.69575309911889,18.7291139240506,3.05828164393414,3.37701737152651\n3.64525344741336,19.026582278481,3.00467114847358,3.32496229794347\n3.58821113981624,19.3240506329114,2.95702352486256,3.2726173323394\n3.51594105508508,19.6215189873418,2.90719409842221,3.21156757675365\n3.43829003980528,19.9189873417722,2.85013073146701,3.14421038563615\n3.36625798980098,20.2164556962025,2.78512260705787,3.07569029842942\n3.30566869773082,20.5139240506329,2.71663501142117,3.01115185457599\n3.2568392343061,20.8113924050633,2.65463995273065,2.95573959351838\n3.21874621582195,21.1088607594937,2.61232592775899,2.91553607179047\n3.19104974406169,21.4063291139241,2.58156296460261,2.88630635433215\n3.15663083508937,21.7037974683544,2.53923326108092,2.84793204808514\n3.12526891908674,22.0012658227848,2.4945138209564,2.80989137002157\n3.09596549329118,22.2987341772152,2.44735141550395,2.77165845439756\n3.06542611339761,22.5962025316456,2.39998875754089,2.73270743546925\n3.02955276608094,22.8936708860759,2.35549593357972,2.69252434983033\n2.9904324081281,23.1911392405063,2.31155151895709,2.6509919635426\n2.94987990309618,23.4886075949367,2.26691661443479,2.60839825876548\n2.90849649086902,23.7860759493671,2.22158183902238,2.5650391649457\n2.86688867630692,24.0835443037975,2.17553254675299,2.52121061152996\n2.82561066839748,24.3810126582278,2.12880638753248,2.47720852796498\n2.78512055882726,24.6784810126582,2.08153712856769,2.43332884369748\n2.74575210875106,24.9759493670886,2.03398286759726,2.38986748817416\n2.70770368237705,25.273417721519,1.98653709930647,2.34712039084176\n2.67104398872683,25.5708860759494,1.93972297356712,2.30538348114698\n2.6357320169734,25.8683544303797,1.89417336009966,2.26495268853653\n2.60164713171093,26.1658227848101,1.85060075320334,2.22612394245714\n2.56862541508114,26.4632911392405,1.80976092962988,2.18919317235551\n2.5364999124907,26.7607594936709,1.77241270286604,2.15445630767837\n2.50514493594132,27.0582278481013,1.73927361980353,2.12220927787242\n2.47452533610368,27.3556962025316,1.71089471041905,2.09271002326136\n2.4446664130624,27.653164556962,1.68493137838549,2.06479889572395\n2.41571944961582,27.9506329113924,1.66007346048254,2.03789645504918\n2.38789803284568,28.2481012658228,1.63634071275985,2.01211937280276\n2.36143121319978,28.5455696202532,1.61373742790099,1.98758432055039\n2.33656690170099,28.8430379746835,1.59224903801452,1.96440796985775\n2.31358038115756,29.1405063291139,1.57183360342356,1.94270699229056\n2.29278770423161,29.4379746835443,1.55240841459738,1.9225980594145\n2.27456331307529,29.7354430379747,1.53383237251525,1.90419784279527\n2.25936045333216,30.0329113924051,1.51588557466499,1.88762301399857\n2.24773179824148,30.3303797468354,1.49824869093873,1.87299024459011\n2.24033259169494,30.6278481012658,1.48024681727049,1.86028970448271\n2.23776084546053,30.9253164556962,1.46081251586076,1.84928668066065\n2.2404955560015,31.2227848101266,1.43945362239509,1.8399745891983\n2.24892030516181,31.520253164557,1.41579495505141,1.83235763010661\n2.26330354034734,31.8177215189873,1.38957646644575,1.82644000339654\n2.28379441724779,32.1151898734177,1.36065740091028,1.82222590907903\n2.31043405422822,32.4126582278481,1.32900504010184,1.81971954716503\n2.34317717441943,32.7101265822785,1.29467306091153,1.81892511766548\n2.38191767942761,33.0075949367089,1.25777596175503,1.81984682059132\n2.42651277967678,33.3050632911392,1.21846493223025,1.82248885595352\n2.47680257986085,33.6025316455696,1.17690826766515,1.826855423763\n2.53262417647639,33.9,1.13327727158507,1.83295072403073"
        },
        {
            "name": ".0/model_prediction2",
            "format": {
                "type": "csv",
                "parse": {
                    "resp_upr_": "number",
                    "pred_": "number",
                    "resp_lwr_": "number",
                    "resp_": "number"
                }
            },
            "values": "\"resp_upr_\",\"pred_\",\"resp_lwr_\",\"resp_\"\n4.92423167107584,10.4,4.24034938250457,4.5822905267902\n4.87472704551332,10.6974683544304,4.20605005130783,4.54038854841057\n4.82529079557118,10.9949367088608,4.17168234449072,4.49848657003095\n4.77592776084939,11.2924050632911,4.13724142245326,4.45658459165132\n4.72664319458359,11.5898734177215,4.1027220319598,4.4146826132717\n4.67744280118111,11.8873417721519,4.06811846860303,4.37278063489207\n4.62833277657113,12.1848101265823,4.03342453645376,4.33087865651245\n4.5793198513061,12.4822784810127,3.99863350495955,4.28897667813282\n4.53041133623575,12.779746835443,3.96373806327064,4.2470746997532\n4.48161517041975,13.0772151898734,3.92873027232739,4.20517272137357\n4.43293997073885,13.3746835443038,3.89360151524904,4.16327074299394\n4.3843950823981,13.6721518987342,3.85834244683053,4.12136876461432\n4.33599062917671,13.9696202531646,3.82294294329267,4.07946678623469\n4.28773756185732,14.2670886075949,3.78739205385281,4.03756480785507\n4.23964770275426,14.5645569620253,3.75167795619662,3.99566282947544\n4.19173378365154,14.8620253164557,3.71578791854009,3.95376085109582\n4.14400947376203,15.1594936708861,3.67970827167035,3.91185887271619\n4.09648939354849,15.4569620253165,3.64342439512464,3.86995689433656\n4.04918910944346,15.7544303797468,3.60692072247041,3.82805491595694\n4.00212510373572,16.0518987341772,3.57018077141891,3.78615293757731\n3.95531471325757,16.3493670886076,3.5331872051378,3.74425095919769\n3.90877603015277,16.646835443038,3.49592193148336,3.70234898081806\n3.86252775810976,16.9443037974684,3.45836624676711,3.66044700243844\n3.81658901822384,17.2417721518987,3.42050102989378,3.61854502405881\n3.77097910032027,17.5392405063291,3.38230699103809,3.57664304567918\n3.72571715831247,17.8367088607595,3.34376497628665,3.53474106729956\n3.68082185206635,18.1341772151899,3.30485632577352,3.49283908891993\n3.63631094320887,18.4316455696203,3.26556327787175,3.45093711054031\n3.59220085802877,18.7291139240506,3.2258694062926,3.40903513216068\n3.54850623646924,19.026582278481,3.18576007109287,3.36713315378106\n3.50523949135192,19.3240506329114,3.14522285945094,3.32523117540143\n3.46241040540316,19.6215189873418,3.10424798864045,3.2833291970218\n3.42002579443663,19.9189873417722,3.06282864284773,3.24142721864218\n3.37808926254242,20.2164556962025,3.02096121798269,3.19952524026255\n3.33660106923961,20.5139240506329,2.97864545452624,3.15762326188293\n3.29555811981925,20.8113924050633,2.93588444718735,3.1157212835033\n3.25495407970474,21.1088607594937,2.89268453054261,3.07381930512368\n3.21477960313101,21.4063291139241,2.84905505035709,3.03191732674405\n3.17502265736812,21.7037974683544,2.80500803936073,2.99001534836442\n3.13566891733181,22.0012658227848,2.76055782263779,2.9481133699848\n3.09670220238871,22.2987341772152,2.71572058082164,2.90621139160517\n3.05810492747131,22.5962025316456,2.67051389897978,2.86430941322555\n3.0198585436984,22.8936708860759,2.62495632599344,2.82240743484592\n2.98194394863909,23.1911392405063,2.5790669642935,2.7805054564663\n2.94434185216187,23.4886075949367,2.53286510401147,2.73860347808667\n2.90703308958799,23.7860759493671,2.4863699098261,2.69670149970705\n2.86999887897764,24.0835443037975,2.4396001636772,2.65479952132742\n2.83322102345037,24.3810126582278,2.39257406244522,2.61289754294779\n2.79668206235869,24.6784810126582,2.34530906677765,2.57099556456817\n2.76036537695779,24.9759493670886,2.29782179541929,2.52909358618854\n2.72425525711594,25.273417721519,2.25012795850189,2.48719160780892\n2.6883369358048,25.5708860759494,2.20224232305378,2.44528962942929\n2.65259659781222,25.8683544303797,2.15417870428711,2.40338765104967\n2.61702136851916,26.1658227848101,2.10594997682092,2.36148567267004\n2.58159928782669,26.4632911392405,2.05756810075414,2.31958369429041\n2.54631927351531,26.7607594936709,2.00904415830627,2.27768171591079\n2.51117107753981,27.0582278481013,1.96038839752252,2.23577973753116\n2.47614523805103,27.3556962025316,1.91161028025205,2.19387775915154\n2.4412330293125,27.653164556962,1.86271853223132,2.15197578077191\n2.40642641115211,27.9506329113924,1.81372119363246,2.11007380239229\n2.37171797915338,28.2481012658228,1.76462566887194,2.06817182401266\n2.33710091644025,28.5455696202532,1.71543877482582,2.02626984563303\n2.30256894763197,28.8430379746835,1.66616678687484,1.98436786725341\n2.26811629533061,29.1405063291139,1.61681548241696,1.94246588887378\n2.23373763934051,29.4379746835443,1.56739018164781,1.90056391049416\n2.1994280786986,29.7354430379747,1.51789578553047,1.85866193211453\n2.16518309650617,30.0329113924051,1.46833681096364,1.81675995373491\n2.13099852749157,30.3303797468354,1.41871742321899,1.77485797535528\n2.0968705281911,30.6278481012658,1.36904146576022,1.73295599697566\n2.06279554960925,30.9253164556962,1.31931248758281,1.69105401859603\n2.02877031220397,31.2227848101266,1.26953376822883,1.6491520402164\n1.99479178303604,31.520253164557,1.21970834063751,1.60725006183678\n1.96085715492054,31.8177215189873,1.16983901199376,1.56534808345715\n1.92696382742198,32.1151898734177,1.11992838273308,1.52344610507753\n1.89310938954057,32.4126582278481,1.06997886385523,1.4815441266979\n1.85929160394516,32.7101265822785,1.01999269269139,1.43964214831828\n1.82550839261725,33.0075949367089,0.969971947260044,1.39774016993865\n1.7917578237801,33.3050632911392,0.919918559337943,1.35583819155902\n1.75803809999637,33.6025316455696,0.869834326362428,1.3139362131794\n1.72434754732717,33.9,0.819720922272377,1.27203423479977"
        },
        {
            "name": "scale/fill",
            "format": {
                "type": "csv",
                "parse": {

                }
            },
            "values": "\"domain\"\n\"4\"\n\"6\"\n\"8\""
        },
        {
            "name": "scale/x",
            "format": {
                "type": "csv",
                "parse": {
                    "domain": "number"
                }
            },
            "values": "\"domain\"\n9.225\n35.075"
        },
        {
            "name": "scale/y",
            "format": {
                "type": "csv",
                "parse": {
                    "domain": "number"
                }
            },
            "values": "\"domain\"\n0.565537073939033\n6.1575817372726"
        }
    ],
    "scales": [
        {
            "name": "fill",
            "type": "ordinal",
            "domain": {
                "data": "scale/fill",
                "field": "data.domain"
            },
            "points": true,
            "sort": false,
            "range": "category10"
        },
        {
            "name": "x",
            "domain": {
                "data": "scale/x",
                "field": "data.domain"
            },
            "zero": false,
            "nice": false,
            "clamp": false,
            "range": "width"
        },
        {
            "name": "y",
            "domain": {
                "data": "scale/y",
                "field": "data.domain"
            },
            "zero": false,
            "nice": false,
            "clamp": false,
            "range": "height"
        }
    ],
    "marks": [
        {
            "type": "symbol",
            "properties": {
                "update": {
                    "size": {
                        "value": 50
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.mpg"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.wt"
                    },
                    "fill": {
                        "scale": "fill",
                        "field": "data.factor(cyl)"
                    },
                    "shape": {
                        "value": "triangle"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0"
                    }
                }
            },
            "from": {
                "data": ".0"
            }
        },
        {
            "type": "area",
            "properties": {
                "update": {
                    "fill": {
                        "value": "#333333"
                    },
                    "y2": {
                        "scale": "y",
                        "field": "data.resp_upr_"
                    },
                    "fillOpacity": {
                        "value": 0.2
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.pred_"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.resp_lwr_"
                    },
                    "stroke": {
                        "value": "transparent"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0/model_prediction1"
                    }
                }
            },
            "from": {
                "data": ".0/model_prediction1"
            }
        },
        {
            "type": "line",
            "properties": {
                "update": {
                    "strokeWidth": {
                        "value": 2
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.pred_"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.resp_"
                    },
                    "stroke": {
                        "value": "blue"
                    },
                    "fill": {
                        "value": "transparent"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0/model_prediction1"
                    }
                }
            },
            "from": {
                "data": ".0/model_prediction1"
            }
        },
        {
            "type": "area",
            "properties": {
                "update": {
                    "fill": {
                        "value": "#333333"
                    },
                    "y2": {
                        "scale": "y",
                        "field": "data.resp_upr_"
                    },
                    "fillOpacity": {
                        "value": 0.2
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.pred_"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.resp_lwr_"
                    },
                    "stroke": {
                        "value": "transparent"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0/model_prediction2"
                    }
                }
            },
            "from": {
                "data": ".0/model_prediction2"
            }
        },
        {
            "type": "line",
            "properties": {
                "update": {
                    "strokeWidth": {
                        "value": 2
                    },
                    "x": {
                        "scale": "x",
                        "field": "data.pred_"
                    },
                    "y": {
                        "scale": "y",
                        "field": "data.resp_"
                    },
                    "stroke": {
                        "value": "red"
                    },
                    "fill": {
                        "value": "transparent"
                    }
                },
                "ggvis": {
                    "data": {
                        "value": ".0/model_prediction2"
                    }
                }
            },
            "from": {
                "data": ".0/model_prediction2"
            }
        }
    ],
    "width": 504,
    "height": 504,
    "legends": [
        {
            "orient": "right",
            "fill": "fill",
            "title": "factor(cyl)"
        }
    ],
    "axes": [
        {
            "type": "x",
            "scale": "x",
            "orient": "bottom",
            "layer": "back",
            "grid": true,
            "title": "mpg"
        },
        {
            "type": "y",
            "scale": "y",
            "orient": "left",
            "layer": "back",
            "grid": true,
            "title": "wt"
        }
    ],
    "padding": null,
    "ggvis_opts": {
        "keep_aspect": false,
        "resizable": true,
        "padding": {

        },
        "duration": 250,
        "renderer": "svg",
        "hover_duration": 0,
        "width": 504,
        "height": 504
    },
    "handlers": null
}
;
ggvis.getPlot("plot_id160020543").parseSpec(plot_id160020543_spec);
</script><!--/html_preserve-->
 
### Making plots interactive
 
#### Basic interactivity
 
* Most basic level is 'hover over' just like in javascript.
* Properties of the properties are changed to achive this.
* `property.hover` argument: `fill.hover := "red"`, or `size.hover`, `opacity.hover`, etc.
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    fill = ~Line,
    fill.hover := "red",
    size.hover := 1500 # sizes are very different to R graphics!
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
# This behaviour is saved into the html or svg file!
{% endhighlight %}
 
#### Tooltips
 
* `add_tooltip` adds other behaviour on hover..
* We can provide a function that provide information as we hover.
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    fill = ~Line,
    fill.hover := "red",
    size.hover := 1500 # sizes are very different to R graphics!
    ) %>%
  add_tooltip(
    function(data) data$Excess
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}



{% highlight r %}
# Locks off R console - cannot be used in markdown
{% endhighlight %}
 

{% highlight r %}
pkData$id <- seq_along(pkData$Subject)
 
all_values <- function(x) {
  
  }
  
pkData %>% ggvis(
  ~Time,
  ~Conc,
  key = ~id # ggvis defined
  ) %>%
  layer_points() %>%
  add_tooltip(
    all_values,
    "hover"
    )
{% endhighlight %}
 
#### Interactive input
 
* We can set outputs to be taken from interactive inputs
 
`opacity := input_slider(0,1, label = "Opacity")`
 
* We use the `":="` for this input
* We can optionally set labels next to the control - unlink `shiny` where it is not optional
* Currently you are limited to changing the properties of the data, not the data itself.
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    fill = ~Line,
    size := input_slider(10,1000, label = "Size of points")
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
#### Interactive input functions
 
<!--
|Function|Description|
|---|---|
|input_slider||
|etc|etc|
-->
 

{% highlight r %}
tubeData %>%
  ggvis(
    ~Month,
    ~Excess
    ) %>%
  layer_points(
    size := input_numeric(30, label = "Size"),
    opacity := input_slider(0,1,value = 0.7, label = "Opacity"),
    fill := input_select(c("red","blue","orange"), label = "Colour")
    )
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'tubeData' not found
{% endhighlight %}
 
### Common plot functions
 
#### Controlling axes and legends
 
* We can control the axes using the add_axis function
* This controls acis labels, tick marks and even grid lines
* Title workaround is to use `add_axis`
 
`add_axis("x", title = "Month")`
 
* `add_axis` controls colour of gridlines, etc
* The `add_legend` and `hide_legend` functions allow use to control if we see a legend and wheere it appears
 
`add_legend("fill")`
`add_legend(c("fill","shape"))`
 
#### Scales
 
* ggvis had fewer scale functions than in `ggplot2` but control much more.
* just seven functions at present
 

{% highlight r %}
grep(
  "^scale",
  objects("package:ggvis"),
  value = TRUE
  )
{% endhighlight %}



{% highlight text %}
## [1] "scale_datetime" "scaled_value"   "scale_logical"  "scale_nominal" 
## [5] "scale_numeric"  "scale_ordinal"  "scale_singular"
{% endhighlight %}
 
#### ggvis vs ggplot2
 
* we can layer graphics in a simlar fashion
* aesthetics can be set baswed on by variables in the data
* We cancontrol the type of plot
 
#### How are they different?
 
* Only one main function
* Layering with `%>%`
* Fewer scale functions
* Much functionality not available... but coming...
 
#### Which should I use
 
* Static graphics: `ggplot2`
* Interactive graphics `ggvis`
 
#### Documentation
 
* [ggvis documentation](http://ggvis.rstudio.com)
 
 
 
 
