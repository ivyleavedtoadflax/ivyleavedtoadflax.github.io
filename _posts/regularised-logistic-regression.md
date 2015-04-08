---
title: "Non-linear classification with logistic regression"
date: 2015-04-07
modified: 2015-04-08
excerpt: "Implementing regularisation and feature mapping."
layout: post
published: true
status: publish
comments: true
tags: [classification, logistic regression, fminunc, feature mapping, regularisation]
---
 
 

 
 
In my last post I compared vectorised logistic regression solved with an optimisation algorithm with a generalised linear model. I tested it out on a very simple dataset which could be classified using a linear boundary. In this post I'm folling the next part of Andrew Ng's Machine Learning course on [coursera](http://www.coursera.org) and implementing regularisation and feature mapping to allow me to map non-linear decision boundaries using logistic regression. And of course, I'm doing it in R, not Matlab or Octave.
 
### Visualising the data
 
First I plot the data...and it's pretty clear that to create an accurate decision boundary will probably require some level of polynomials in order to account for its spherical nature.
 

{% highlight r %}
library(dplyr)
library(magrittr)
library(ggplot2)
library(ucminf)
library(testthat)
 
ex2data2 <- "ex2data2.txt" %>%
  read.csv(header=FALSE) %>%
  set_colnames(c("test_1","test_2","passed"))
 
p <- ex2data2 %>%
  ggplot(
    aes(
      x = test_1,
      y = test_2
      )
    ) +
  geom_point(
    aes(
      shape = factor(passed),
      colour = factor(passed)
      )
    )+
  xlab("Microchip test 1")+
  ylab("Microchip test 2")
 
p
{% endhighlight %}

![plot of chunk 2015-04-07-initial-data-plot](/figures/2015-04-07-initial-data-plot-1.png) 
 
### Feature mapping
 
In this example I'll map the features into all polynomial terms of $x_1$ and $x_2$ up to the sixth power. Hence:
 
$$
mF(x)=\begin{bmatrix}
1 \\
x_1 \\
x_2 \\
x_1^2 \\
x_1 x_2 \\
x_2^2 \\
x_1^3 \\
\vdots \\
x_1x_2^5 \\
x_2^6
\end{bmatrix}
$$
 
These polynomials can be calculated with the following code. The first rather inelegant nested `for` loop could probably be replaced with something more mathematically elegant. In future I will update this to take more than two input features.
 
 

{% highlight r %}
map_feature <- function(X1,X2,degree) {
  
  # There's probably a more mathematically succinct way of doing this...
  
  counter = 0
  for (i in 1:degree){
    for (j in 0:i) {
      counter <- counter + 1
      }
    }
  
  
  out_matrix <- matrix(
    nrow = length(X1),
    ncol = counter
    )
  
  names_vec <- vector(
    length = counter
    )
  
  counter = 0
  for (i in 1:degree) {
    for (j in 0:i) {
      counter <- counter + 1
      out_matrix[,counter] <- ((X1^(i-j))*(X2^j))
      names_vec[counter] <- paste("X1^",i-j,"*X2^",j,sep="")
      }
    }
  
  colnames(out_matrix) <- names_vec
  return(out_matrix)
  
  }
 
poly <- map_feature(
  ex2data2$test_1,
  ex2data2$test_2,
  6
  )
poly %>% colnames
{% endhighlight %}



{% highlight text %}
##  [1] "X1^1*X2^0" "X1^0*X2^1" "X1^2*X2^0" "X1^1*X2^1" "X1^0*X2^2"
##  [6] "X1^3*X2^0" "X1^2*X2^1" "X1^1*X2^2" "X1^0*X2^3" "X1^4*X2^0"
## [11] "X1^3*X2^1" "X1^2*X2^2" "X1^1*X2^3" "X1^0*X2^4" "X1^5*X2^0"
## [16] "X1^4*X2^1" "X1^3*X2^2" "X1^2*X2^3" "X1^1*X2^4" "X1^0*X2^5"
## [21] "X1^6*X2^0" "X1^5*X2^1" "X1^4*X2^2" "X1^3*X2^3" "X1^2*X2^4"
## [26] "X1^1*X2^5" "X1^0*X2^6"
{% endhighlight %}
 
Chances are that using all these features will result in overfitting. Let's see the result of this:
 

{% highlight r %}
theta <- runif(1:27)
y <- ex2data2$passed
 
ucminf_out <- ucminf(
  par = theta,
  fn = function(t) Jv(poly, y, t),
  gr = function(t) gRv(poly, y, t)
  )
 
ucminf_out$convergence
{% endhighlight %}



{% highlight text %}
## [1] 1
{% endhighlight %}



{% highlight r %}
ucminf_out$message
{% endhighlight %}



{% highlight text %}
## [1] "Stopped by small gradient (grtol)."
{% endhighlight %}
 
So...it did converge, and if I was to call `ucminf_out$par`, it will return our 27 parameters.
 
With just two features, we can also quite easily plot the decision boundary. To do so I create a matrix $X$ of $m$ rows which corresponds to a grid of points for which we can then generate a prediction. We use the output $\theta$ derived from the model fit from the `ex2data1` data. We then combine the predictions from th egrid of points in a contour plot.
 
The function to create the boundary thus takes two inputs: a sequence of numbers `xy` delineating the limits of the plot. This works for situations where the ranges of the two features are similar, but would need to be adapted for features with different ranges - although it would probably be fine if feature scaling is used.
 
 

{% highlight r %}
draw_boundary <- function(xy,theta) {
  
  u <- rep(xy, times = length(xy))
  v <- rep(xy, each = length(xy))
  
  cbind(u,v,z = NA) %>% 
    as.data.frame %>%
    tbl_df %>%
    dplyr::mutate(
      z = h(theta, map_feature(u,v,6)) %>% round
      )
  }
{% endhighlight %}
 
Create the grid of points:
 

{% highlight r %}
boundary <- draw_boundary(
  seq(-1.5, 1.5, length = 500),
  ucminf_out$par
  )
{% endhighlight %}
 
Now I add my prediction to the dataframe...
 

{% highlight r %}
ex2data2 %<>% 
  dplyr::mutate(
    pred = h(theta,poly) %>% round
    )
{% endhighlight %}
 
At this point it is probably worth defining some sort of measure of accuracy. A simple percentage error will suffice in this case.
 

{% highlight r %}
perc_error <- function(y,pred) {
  
  # Should really be implementing more unit tests throughout...,meh
  
  test_that(
    "Prediction and actual are the same length",
    expect_equal(length(y),length(pred))
    )
  
  error <- 1/length(y) * sum((y - pred)^2)
  error <- round(error,2)
  return(error)
  
  }
{% endhighlight %}
 
And now for the decision boundary:
 

{% highlight r %}
p + geom_contour(
  data = boundary,
  aes(
    x = u,
    y = v,
    z = z
    ),
  bins = 1
  )+
  coord_cartesian(
    xlim = c(-0.9,1.2),
    ylim = c(-0.9,1.2)
    )
{% endhighlight %}

![plot of chunk 2015-04-07-no-regularisation](/figures/2015-04-07-no-regularisation-1.png) 
 
So this looks pretty good, and correctly classifies 0.53% of the training set. The decision boundary is rather doughnut shaped, and any values within the 'hole' will be misclassified, as will any values to the top left.
 
### Regularisation - cost function and gradient
 
To improve on the boundary above we can implement regularisation; this should reduce some of the overfitting seen in the last plot.
 
Andrew Ng gives us the regularised cost function as:
 
$$
J(\theta)=\frac{1}{m}\sum^m_{i=1}[-y^{(i)}\log(h_\theta(x^{(i)}))-(1-y^{(i)})\log(1-h_\theta(x^{(i)}))]+\frac{\lambda}{2m}\sum^n_{j=1}\theta^2_j
$$
 
Note that the parameter $\theta_0$ is not regularised as this corresponds to the intercept.
 

{% highlight r %}
Jv_reg <- function(X, y, theta, lambda) {
  
  m <- length(y)
  
  # Use identity matrix to remove first value from theta so that it is not regularised.
  
  # Remove first value i.e. theta_0
  
  theta1 <- theta
  theta1[1] <- 0
  
  # Crossproduct is equivaelnt to theta[-1]^2
  
  reg <- (lambda/(2*m)) * crossprod(theta1,theta1)
  
  # Create regularisation term
  
  -(1/m) * crossprod(
    c(y, 1 - y), 
    c(log(h(theta,X)), log(1 - h(theta,X)))
    ) + reg
  }
{% endhighlight %}
 
So let's test this in comparison with the cost function that I defined in the previous post by setting the parameter $\lamda=0$, i.e. no regularisation.
 
 

{% highlight r %}
identical(
  Jv(poly,y,theta),
  Jv_reg(poly,y,theta,0)
  )
{% endhighlight %}



{% highlight text %}
## [1] TRUE
{% endhighlight %}
 
Great, the function passes this basic test.
 
Now for the gradient function. As noted, we don't regularise $\theta_0$, so we need a more complicated gradient function.
 
$$
\left\{
\begin{array}{ll}  
    \displaystyle\frac{\delta J(\theta)}{\delta\theta_0}=\frac{1}{m}\sum_{i=1}^m(h_{\theta}(x^{(i)})-y^{(i)})x^{(i)}_j & \text{for}\ j=0 \\
    & \\
    \displaystyle\frac{\delta J(\theta)}{\delta\theta_j}=\left(\frac{1}{m}\sum_{i=1}^n(h_{\theta}(x^{(i)})-y^{(i)})x^{(i)}_j\right) + \frac{\lambda}{m}\theta_j & \text{for}\ j\geq1
\end{array}\right .
$$
 
 
This can be implemented in vectorised fashion:
 

{% highlight r %}
gRv_reg <- function(X,y,theta,lambda) {
  
  m <- length(y)
  
  reg <- (lambda/m) * theta
  error <- h(theta,X) - y
  delta <- crossprod(X,error) / m
  return(delta + reg)
  
  }
{% endhighlight %}
 
The cost function for all values of $\theta$ initialised to zero should be around $0.693$.
 

{% highlight r %}
theta <- matrix(rep(0,27),ncol=1)
 
Jv_reg(poly,y,theta,1)
{% endhighlight %}



{% highlight text %}
##           [,1]
## [1,] 0.6931472
{% endhighlight %}
 
So far so good. Ok so lets try running regularised logistic regression for the polynomial example, but first I'll wrap this into a function to save having to explicitly declare the parameters each time.
 

{% highlight r %}
reg_lr <- function(X,y,theta,lambda) {
  
  ucminf_out <- ucminf(
    par = theta,
    fn = function(t) Jv_reg(X, y, t, lambda),
    gr = function(t) gRv_reg(X, y, t, lambda)
    )
  
  return(
    as.vector(ucminf_out$par)
    )
  
  }
{% endhighlight %}
 
So we can try this...
 

{% highlight r %}
theta <- reg_lr(
  X = poly,
  y = y,
  theta = theta,
  lambda = 1
  )
 
theta
{% endhighlight %}



{% highlight text %}
##  [1]  0.40040130  1.08581327 -0.58313506 -0.89248267  0.18577839
##  [6]  0.14312054 -0.41436225 -0.22607027 -0.18442126 -1.13785873
## [11] -0.03617746 -0.52503927 -0.21641213 -0.91956820 -0.26316285
## [16] -0.22954929 -0.02964624 -0.31014556 -0.20154274 -0.63159874
## [21] -0.99086697  0.03349645 -0.29406307  0.02907866 -0.34580124
## [26] -0.08087845 -1.04253455
{% endhighlight %}
 
And it seems to be working.
 
Now lets take the outputs from the regularised, vectorised logistic regression, and use them to plot the decision boundary.
 

{% highlight r %}
boundary <- draw_boundary(
  seq(-1.5, 1.5, length = 200),
  theta
  )
 
p + geom_contour(
  data = boundary,
  aes(
    x = u,
    y = v,
    z = z
    ),
  bins = 1
  )+
  coord_cartesian(
    xlim = c(-0.9,1.2),
    ylim = c(-0.9,1.2)
    )
{% endhighlight %}

![plot of chunk 2015-04-07-lambda-equals-1](/figures/2015-04-07-lambda-equals-1-1.png) 
 
Great, so lets try this for a range of $\lambda$.
 

{% highlight r %}
lambda <- c(0,0,0.00001,0.0001,0.001,0.005,0.01,0.05,0.1,0.5)
out_mat <- matrix(nrow = 50, ncol = length(lambda)-2)
colnames(out_mat) <- paste(lambda[-c(1:2)],sep = "")
out_mat <- cbind(boundary[,1:2],out_mat) %>% as.matrix
 
for (i in 3:ncol(out_mat)) {
  
  out <- draw_boundary(
    seq(-1.5, 1.5, length = 200),
    reg_lr(
      X = poly,
      y = y,
      theta = theta,
      lambda = lambda[i]
      )
    ) %$% z %>% as.vector
  
  out_mat[,i] <- out
  
  }
 
 
 
out_mat %>%
  data.frame %>%
  tidyr::gather(
    key,value,3:ncol(out_mat)
    ) %>%
  tbl_df  %>%
  ggplot(
    aes(
      x = u,
      y = v
      )
    ) +
  geom_contour(
    aes(
      z = value
      ),
    bins = 1
    ) + 
  facet_wrap(
    ~key,
    ncol = 2
    ) +
  geom_point(
    data = ex2data2,
    aes(
      x = test_1,
      y = test_2,
      colour = factor(passed),
      shape = factor(passed)
      )
    ) +
  xlab("Microchip test 1") +
  ylab("Microchip test 2") +
  coord_cartesian(
    xlim = c(-0.9,1.2),
    ylim = c(-0.9,1.2)
    )
{% endhighlight %}

![plot of chunk 2015-04-07-various-lambdas](/figures/2015-04-07-various-lambdas-1.png) 
 
 

{% highlight r %}
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.1.3 (2015-03-09)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.2 LTS
## 
## locale:
##  [1] LC_CTYPE=en_GB.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_GB.UTF-8        LC_COLLATE=en_GB.UTF-8    
##  [5] LC_MONETARY=en_GB.UTF-8    LC_MESSAGES=en_GB.UTF-8   
##  [7] LC_PAPER=en_GB.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_GB.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] methods   stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] ucminf_1.1-3   ggplot2_1.0.0  magrittr_1.5   dplyr_0.4.1   
## [5] testthat_0.8.1 knitr_1.9     
## 
## loaded via a namespace (and not attached):
##  [1] assertthat_0.1   colorspace_1.2-5 DBI_0.3.1        digest_0.6.4    
##  [5] evaluate_0.5.5   formatR_1.0      grid_3.1.3       gtable_0.1.2    
##  [9] labeling_0.3     lazyeval_0.1.10  MASS_7.3-39      munsell_0.4.2   
## [13] parallel_3.1.3   plyr_1.8.1       proto_0.3-10     Rcpp_0.11.5     
## [17] reshape2_1.4.1   scales_0.2.4     stringr_0.6.2    tcltk_3.1.3     
## [21] tidyr_0.2.0      tools_3.1.3
{% endhighlight %}
