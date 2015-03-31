---
title: "Do women take the scenic route or do men cycle faster?"
date: 2014-11-16
modified: 2015-03-31
excerpt: "Using the google routing API via ggmap"
layout: post
published: true
status: publish
comments: true
tags: [Citibike, gender, dplyr, ggmap]
---
 

 

 
In my previous post I started looking at the NY CitiBike data, and the differences between the way men and women use the service. It's clear men use the service more, and that women's journeys are generally longer; however it's not clear if this is because they simply travel slower, or because they aren't always taking teh most direct route.
 
This is a difficult question to answer. Whilst it is easier to know whether the journey time from A to B is longer for men or women, it is not easy to know if the journey was direct. We could simply average it, and hope for the best; given 11 million records, this would probably be good enough, but there is another way making use of the google maps api.
 
The google maps api (accessed using the excellemt [ggmap](http://cran.r-project.org/web/packages/ggmap/index.html)) can be queried for distance and cycling journey time between two points. By using this method for a subsample of journeys, we can filter those journeys which take less time than google suggests it should take, hence we can be more sure (although not absolutely so) that these journeys were direct. We can then have a look at the differences between journey times for men and women.
 
### Step One
 
Aggregate all observation by the journey made, and the hour when it was made:
 

{% highlight r %}
bikes_agg <- bikes %>%
  dplyr::mutate(
    journey = paste(
      start_hash,
      end_hash,
      sep = ""
      ),
    time = round_date(
      starttime,
      "hour"
      )
    ) %>%
  dplyr::filter(
    start_hash != end_hash
    ) %>%
  dplyr::group_by(
    gender,
    start_hash,
    end_hash,
    journey,
    time
    ) %>%
  dplyr::summarise(
    num = n(),
    dur = mean(tripduration)
    ) %>%
  dplyr::arrange(
    desc(num)
    )
 
# This takes quite a while, so let's save it out as an RData file so we don't have to do it again
 
save(
  bikes_agg, 
  file = "bikes_agg.RData"
  )
{% endhighlight %}
 
### Step Two:
 
* Create a dataframe of all unique journeys
 
Load the stations data.
 

{% highlight r %}
stns <- "stns.csv" %>% 
  read.table(
    ., 
    sep = ",", 
    header = F
    ) %>% 
  tbl_df 
 
names(stns) <- c("hash","id","name","lat","lon")
{% endhighlight %}
 
* Create a table of all the unique journeys
 

{% highlight r %}
journeys <- bikes_agg %>% 
  dplyr::group_by() %>%
  dplyr::filter(start_hash != end_hash) %>%
  dplyr::mutate(
    start_hash = as.character(start_hash),
    end_hash = as.character(end_hash)
    ) %>%
  dplyr::group_by(
    start_hash,
    end_hash,
    journey
    ) %>%
  dplyr::summarise(
    nobs = n()
)
{% endhighlight %}
 
This gives 105606 journeys out of a possible 1.16281 &times; 10<sup>5</sup>; plus it is possible for a journey to start and end at the same station, but we are not interested in those, as there is no way to know where someone has been.
 
* merge `journeys` and `stns` dataframes to give a table with the complete station and journey data. 
 

{% highlight r %}
journeys1 <- merge(
  journeys,
  stns,
  by.x = "start_hash",
  by.y = "hash"
  ) %>% 
  merge(
    .,
    stns,
    by.x = "end_hash",
    by.y = "hash"
    ) %>% 
  dplyr::select(
    journey,
    start_hash,
    start_id = id.x,
    start_name = name.x,
    start_lat = lat.x,
    start_lon = lon.x,
    end_id = id.y,
    end_name = name.y,
    end_lat = lat.y,
    end_lon = lon.y
    ) %>%
  tbl_df
{% endhighlight %}
 
* Query the google api and get journey times and distance for a subset of journeys.
 
The google api limits you to 2500 queries a day, so 2500 seems like a good subset of queries to make. Note that since we can just query the journey dataframe we created in the previous step, not the individual journeys themselves, so we will actually be looking at many more journeys. 
 

{% highlight r %}
# First pick a random subset of the dataset. Best to test this with just a few examples, so you know it is working, then query a larger amount when you are confident that you are not going to use all of your free queries in one go!!
 
journeys_subset <- journeys1 %>%
  sample_n(
    10
    )
 
# First organise start and end coordinates into a format that the api will like:
 
fromx <- paste(
  journeys_subset$start_lat, 
  journeys_subset$start_lon, 
  sep =  " "
  )
 
toy <- paste(
  journeys_subset$end_lat, 
  journeys_subset$end_lon, 
  sep = " "
  )
 
journey_times <- mapdist(
  from = fromx,
  to = toy,
  mode = "bicycling"
  )
 
journey_times
 
# Ok so then bind this to the journeys1 dataframe
 
journeys_merge <- tbl_df(
  cbind(
    journeys_subset,
    journey_times
    )
  )  %>%  
  dplyr::select(
    -from,-to,-km,-miles,-minutes,-hours
    )
 
journeys_merge
{% endhighlight %}
 
It's also possible to query to google routing api to get a route for each of these journeys. We can plot this to ensure that we have a good coverage across Manhatten Island, but it can also look really cool!
 

{% highlight r %}
# Write a wrapper function to deal with requests to the google routing api
 
get_route <- function(x) {
  
  fromx <- unique(
    paste(
      x$start_lat, 
      x$start_lon, 
      sep =  " "
      )
    )
  
  toy <- unique(
    paste(
      x$end_lat, 
      x$end_lon, 
      sep = " "
      )
    )
  
  journey_route <- data.frame() %>% tbl_df
  
  max_journeys <- c(fromx %>% length,toy %>% length) %>% max
  
  for (i in 1:max_journeys) {
    
    try(
      journey_route1 <- route(
        from = fromx,
        to = toy,
        mode = "bicycling"
        )
      )
    
    try(
      journey_route1 <- cbind(
        i,
        journey_route1
        )
      )
    
    try(
      journey_route <- rbind(
        journey_route,
        journey_route1
        )
      )
    rm(journey_route1)  
    }
  
  journey_route
  
  }
{% endhighlight %}
 
Now apply it
 

{% highlight r %}
# Again i've just used 10 unique journeys here.
 
journey_route <- data.frame() %>% tbl_df
 
for (i in 1:length(fromx)) {
  
  try(
    journey_route1 <- route(
      from = fromx,
      to = toy,
      mode = "bicycling"
      )
    )
  
  try(
    journey_route1 <- cbind(
      i,
      journey_route1
      )
    )
  
  try(
    journey_route <- rbind(
      journey_route,
      journey_route1
      )
    )
  rm(journey_route1)  
  }
{% endhighlight %}
 

 
Now plot it out using a standard `ggplot`.
 

{% highlight r %}
ggplot(
  journey_route %>%
    dplyr::mutate(
      no_legs = ave(
        leg,
        i,
        FUN = length
        ),
      final = ifelse(
        leg == no_legs,
        TRUE,
        FALSE
        )
      ),
  aes(
    x = startLon,
    y = startLat,
    group = i
    )
  )+
  geom_point(
    data = journey_route %>%
      dplyr::filter(leg == 1),
    aes(
      x = startLon,
      y = startLat
      ),
    col = "darkblue"
    )+
  geom_path(
    data = journey_route,
    aes(
      x = startLon,
      y = startLat,
      group = i
      ),
    lwd = 1.5,
    alpha = 0.2,
    col = "red"
    )
{% endhighlight %}

![plot of chunk journey_route_ggplot](/figures/journey_route_ggplot-1.png) 
 
But it's much interesting to see this superimposed over a map of NYC using `ggmap`
 

{% highlight r %}
# Set the centre of the plot
 
centre <- c(
  lon = mean(stns$lon),
  lat = mean(stns$lat)
  )
 
# Use the aesthetically pleasing stamen maps
 
nymap_stamen_to <- get_map(
  location = centre, 
  source = "stamen", 
  maptype = "toner", 
  zoom = 13
  )
 
# Apply ggplot layers onto ggmap
 
ggmap(
  nymap_stamen_to, 
  extent = 'device',
  legend="bottomright"
  )+
  geom_point(
    data = journey_route %>%
      dplyr::filter(
        leg == 1
        ),
    aes(
      x = startLon,
      y = startLat
      ),
    col = "blue",
    size = 2
    )+
  geom_path(
    data = journey_route,
    aes(
      x = startLon,
      y = startLat,
      group = i
      ),
    lwd = 1.5,
    alpha = 0.3,
    col = "red"
    )
{% endhighlight %}

![plot of chunk journey_plot_ggmap](/figures/journey_plot_ggmap-1.png) 
 
Much better.
 
So it looks like we have a reasonable coverage of Manhatten island. You could always query the api on multiple days and combine the output if you wanted to include more than 2500 of the 110,000 possible journeys.
 
* Join `journeys_merge` data with actual journey data from `bikes_agg`.
 
 

{% highlight r %}
bikes_journey_join <- bikes_agg %>%
  inner_join(
    journeys1,
    by =  "journey"
    ) %>%
  group_by() %>%
  mutate(
    hour = hour(time),
    we = ifelse(
      (wday(time) %in% c(1,7)),
      "Weekend",
      "Weekday"
      )
    ) %>%
  filter(
    !is.na(gender)
    ) %>% 
  tbl_df %>%
    # Calculate actual speed and predicted speed
  dplyr::mutate(
    speed = (m/dur)*3.6,
    e_speed = (m/seconds)*3.6
    )
 
bikes_journey_join
{% endhighlight %}
 
 
Now that we have that data combined, we can produce some plots
 
First, how does all this data look when separated by gender? In  the following plot the solid line is a 1:1 lined between the journey time predicetd by teh google api, and the actual journey time in seconds. The dashed line is an actual regression line from the data.
 

{% highlight r %}
ggplot(
  data = bikes_journey_join %>%
    filter(
      !is.na(gender)
      ),
  aes(
    x = seconds,
    y = dur,
    color = gender
    )
  )+
  geom_point(
    alpha = 0.05
    )+
  geom_smooth(
    method = "lm",
    se = FALSE,
    col = "darkblue",
    lty = 2
    )+
  geom_abline(
    aes(
      a = 1,
      b = 1
      )
    )+
  facet_grid(
    we~gender
    )+
  coord_cartesian(
    ylim = c(0,3000)
    )+
  scale_color_discrete(
    guide = "none"
    )+
  xlab("Predicted journey duration (s)")+
  ylab("Actual journey duration (s)")
{% endhighlight %}

![plot of chunk nybikes_pred_vs_actual](/figures/nybikes_pred_vs_actual-1.png) 
 
 
The first thing we can take away from this plot is that the google api is quite optimistic about its predictions of cycling journey time sin New York City: most journeys take longer than it predicts; although of course, it is not clear whether this is simply because people are not taking the most direct route.
 
The second thing that comes out is that for men, it appears that for journeys of longer than 2000 seconds during the week, actual journey times are shorter than the google prediction. Note that this is just a guide, this model would not satisfy the usual assumptions of a linear model.
 
The regression lines tend to suggest that mens' journey time on the same journeys are simply shorter than womens'. We can see this more clearly in a boxplot:
 

{% highlight r %}
ggplot(
  data = bikes_journey_join %>%
    filter(
      !is.na(gender)#,
      #dur < 3000
      ) %>%
    mutate(
      hour = hour(time),
      we = ifelse(
        (wday(time) %in% c(1,7)),
        "Weekend",
        "Weekday"
        )
      ),
  aes(
    x = gender,
    y = dur,
    color = gender,
    fill = gender,
    group = gender
    )
  )+
  geom_boxplot(
    alpha = 0.3,
    outlier.size = 0
    )+
  facet_wrap(
    ~we
    )+
  coord_cartesian(
    ylim = c(0,2200)
    )
{% endhighlight %}

![plot of chunk nybikes_boxplot](/figures/nybikes_boxplot-1.png) 
 
However, it would better if we could look at the average of each journey time for each journey against each other for men and women, as the plots above are not from a uniform number of journeys for each sex.
 

{% highlight r %}
bikes_journey_mean <- bikes_journey_join %>%
  dplyr::filter(
    dur < seconds,
    !is.na(gender)
    ) %>%
  dplyr::group_by(
    seconds,
    start_hash.x,
    end_hash,
    gender,
    journey
    ) %>%
  dplyr::summarise(
    m = median(m),
    speed = median(speed),
    dur = median(dur),
    n = n()
    ) %>%
  dplyr::filter(
    n > 10
    ) %>%
  dplyr::arrange(
    journey,
    gender
    ) %>%
  dplyr::group_by() %>%
  dplyr::mutate(
    gender1 = lag(as.numeric(gender),1),
    gender2 = abs(as.numeric(gender) - gender1)
    ) %>%
  dplyr::filter(
    gender2 == 1
    ) %>%
  dplyr::group_by(
    journey
    ) %>%
  dplyr::mutate(
    n = n(),
    diff = abs(seconds - dur)
    ) %>%
  dplyr::filter(
    n == 2
    ) %>% 
  dplyr::select(
    -gender1,
    -gender2,
    -n
    )
{% endhighlight %}
 

{% highlight r %}
# This thrwos up a warning...and there may be a better way of doing this...
 
ggplot(
  bikes_journey_mean %>%
    group_by() %>%
    mutate(
      journey = factor(
        journey, 
        levels = bikes_journey_mean$journey[order(bikes_journey_mean$dur)]
        )
      ),
  aes(
    x = dur,
    y = journey,
    colour = gender,
    #group = journey,
    order = dur
    )
  )+
  geom_point()+
  xlab("Journey time (s)")+
  ylab("Unique journey")
{% endhighlight %}

![plot of chunk nybikes_time_by_journey](/figures/nybikes_time_by_journey-1.png) 
 

{% highlight r %}
ggplot(
  bikes_journey_mean %>%
    group_by() %>%
    mutate(
      journey = factor(
        journey, 
        levels = bikes_journey_mean$journey[order(bikes_journey_mean$speed)]
        )
      ),
  aes(
    x = speed,
    y = journey,
    colour = gender,
    #group = journey,
    order = dur
    )
  )+
  geom_point()+
  xlab(expression(km~h^-1))+
  ylab("Unique journey")
{% endhighlight %}

![plot of chunk nybikes_speed_by_journey](/figures/nybikes_speed_by_journey-1.png) 
 
So that's quite interesting... what's goin on at the top two journeys. Why is it that they appear to be taking place at speends of greater than 50 or 100 km/h? Let's look more closely at those two stations.
 

{% highlight r %}
bla <- bikes_journey_join %>%
  dplyr::filter(
    journey %in% c("3014023d582f","301402dac06a")
    )
 
bla %>%
  dplyr::group_by(
    #start_name,
    #end_name,
    journey,
    gender
    ) %>%
  dplyr::summarise(
    n = n(),
    m = median(m),
    speed = median(speed),
    dur = median(dur)
    )
{% endhighlight %}



{% highlight text %}
## Source: local data frame [4 x 6]
## Groups: journey
## 
##        journey gender   n    m     speed   dur
## 1 3014023d582f      M 121 8449 105.24706 289.0
## 2 3014023d582f      F  66 8449  92.03168 330.5
## 3 301402dac06a      M 102 8039  64.09842 451.5
## 4 301402dac06a      F  18 8039  54.12143 535.0
{% endhighlight %}
 
So that is a bit bizarre...according to google, two journeys of over 8km are being completed in between 200 and 600 seconds, that's less than 10 minutes to do 8km!
 

{% highlight r %}
centre <- c(
  lon = mean(c(bla$start_lon,bla$end_lon)),
  lat = mean(c(bla$start_lat,bla$end_lat))
  )
 
 
bla_route <- get_route(bla)
 
nymap_stamen_to <- get_map(
  location = centre, 
  source = "stamen", 
  maptype = "toner", 
  zoom = 13
  )
 
ggmap(
  nymap_stamen_to, 
  extent = 'device',
  legend="bottomright"
  )+
  geom_point(
    data = bla_route %>%
      dplyr::filter(
        leg == 1
        ),
    aes(
      x = startLon,
      y = startLat
      ),
    col = "blue",
    size = 4
    )+
  geom_point(
    data = stns %>%
      filter(
        hash %in% c("301402","3d582f","dac06a")
        ),
    aes(
      x = lon,
      y = lat
      ),
    col = "green",
    size = 2
    )+
  geom_path(
    data = bla_route,
    aes(
      x = startLon,
      y = startLat,
      group = i
      ),
    lwd = 1.5,
    alpha = 0.3,
    col = "red"
    )
{% endhighlight %}

![plot of chunk journey_plot_ggmap1](/figures/journey_plot_ggmap1-1.png) 
 
It's not immediately clear what's going on here. This is probably an issue with the way I hashed the data, as it appears to affect journeys from one particular station. I'll investigate another day.
