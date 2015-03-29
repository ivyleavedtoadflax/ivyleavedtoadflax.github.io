---
title: "Linear regression with gradient descent"
date: "30/03/2015"
excerpt: Linear regression the machine learning way
output: pdf_document
layout: post
published: true
status: publish
comments: yes
---
 

 
 
# 3 Linear regression with multiple variables
 

 
Load the data dn produce some summaries:
 

{% highlight r %}
"ex1data2.txt" %>% 
  read.csv(
    header = FALSE, 
    col.names = c("size","n_rooms","price")
    ) %>%
  dplyr::mutate(
    n_rooms = factor(n_rooms)
    ) -> house_prices
{% endhighlight %}



{% highlight text %}
## Error in file(file, "rt"): cannot open the connection
{% endhighlight %}



{% highlight r %}
house_prices %>% head
{% endhighlight %}



{% highlight text %}
##   size n_rooms  price vector_pred     pred
## 1 2104       3 399900    356283.1 356283.1
## 2 1600       3 329900    286120.9 286120.9
## 3 2400       3 369000    397489.5 397489.5
## 4 1416       2 232000    269244.2 269244.2
## 5 3000       4 539900    472277.9 472277.9
## 6 1985       4 299900    330979.0 330979.0
{% endhighlight %}
 
Let's also plot it out of interest:
 

{% highlight r %}
library(ggplot2)
 
house_prices %>%
  ggplot(
    aes(
      x = size,
      y = price,
      colour = n_rooms
      )
    ) +
  geom_point()+
  scale_x_continuous(expression(Size~(ft^2)))+
  scale_y_continuous(
    "Price (1000 $)", 
    breaks = seq(2e+05,7e+05,1e+05), 
    labels = seq(20,70,10)
    )
{% endhighlight %}

![plot of chunk plot_multiple_regression](/figures/plot_multiple_regression-1.png) 
 
## 3.1 Feature normalisation/scaling
 
To copy the exercise document:
 
> Your task here is to complete the code in featureNormalize.m to
>
> * Subtract the mean value of each feature from the dataset.
> * After subtracting the mean, additionally scale (divide) the feature values
> by their respective “standard deviations.”
 
and in the file deatureNormalize.m, we get:
 
> First, for each feature dimension, compute the mean
> of the feature and subtract it from the dataset,
> storing the mean value in mu. Next, compute the 
> standard deviation of each feature and divide
> each feature by it's standard deviation, storing
> the standard deviation in sigma.
> 
> Note that X is a matrix where each column is a 
> feature and each row is an example. You need 
> to perform the normalization separately for 
> each feature. 
 

{% highlight r %}
feature_scale <- function(x) {
  
  # Convert all factors to numeric
  # Note that this will also allow the conversion of string features
  
  for (i in 1:ncol(x)) {
    x[,i] %>% as.numeric -> x[,i]
    }
  
  # Set up matrices to take outputs
  
  mu <- matrix(nrow=1,ncol=ncol(x))
  sigma <- matrix(nrow=1,ncol=ncol(x))
  scaled <- matrix(nrow=nrow(x),ncol=ncol(x))
  
  # Define feature scaling function
  
  scale <- function(feature) {
    (feature - mean(feature))/sd(feature)
    }
  
  # Run this for each of the features
  
  for (i in 1:ncol(x)) {
    
    mu[,i] <- mean(x[,i])    
    sigma[,i] <- sd(x[,i])
    scaled[,i] <- scale(x[,i])
    
    }
  
  # And output them together as a list
  
  list(
    mu = mu,
    sigma = sigma,
    scaled = scaled
    )  
  }
 
scaled_features <- feature_scale(house_prices[,-3])
 
range(scaled_features[[3]][,1])
{% endhighlight %}



{% highlight text %}
## [1] -1.445423  3.117292
{% endhighlight %}



{% highlight r %}
range(scaled_features[[3]][,2])
{% endhighlight %}



{% highlight text %}
## [1] -2.851859  2.404508
{% endhighlight %}
 
 
## 3.2 Gradient descent
 
Implementation note:
 
In the multivariate case, the cost function can also be written in the vectorised form:
 
$$
J(\theta)=\frac{1}{2m}(X\theta-\vec{y})^T(X\theta-\vec{y})
$$
Where:
$$
X=\begin{bmatrix}
(x^{(1)})^T \\
(x^{(2)})^T \\
(x^{(3)})^T \\
\vdots \\
(x^{(m)})^T 
\end{bmatrix}\vec{y}=\begin{bmatrix}
y^{(1)} \\
y^{(2)}\\
y^{(3)} \\
\vdots \\
y^{(m)} 
\end{bmatrix}
$$
 

{% highlight r %}
X <- matrix(ncol=ncol(house_prices)-1,nrow=nrow(house_prices))
X[,1:2] <- cbind(house_prices$size,house_prices$n_rooms)
X <- cbind(1,X)
y <- matrix(house_prices$price,ncol=1) 
theta <- matrix(rep(0,3),ncol=1)
 
 
 
multi_lin_reg <- grad(
  alpha = 0.1,
  j = 1000,
  X = X,
  y = y,
  theta = theta
  ) %>% print
{% endhighlight %}



{% highlight text %}
## Error in X %*% theta: non-conformable arguments
{% endhighlight %}



{% highlight r %}
plot(theta_history[,4],type="l")
{% endhighlight %}



{% highlight text %}
## Error in plot.window(...): need finite 'ylim' values
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/figures/unnamed-chunk-5-1.png) 

{% highlight r %}
X[,2:3] <- feature_scale(X[,2:3])[[3]]
 
multi_lin_reg <- grad(
  alpha = 0.1,
  j = 1000,
  X = X,
  y = y,
  theta = theta
  ) %>% print
{% endhighlight %}



{% highlight text %}
## Error in X %*% theta: non-conformable arguments
{% endhighlight %}



{% highlight r %}
plot(theta_history[,4],type="l")
{% endhighlight %}



{% highlight text %}
## Error in plot.window(...): need finite 'ylim' values
{% endhighlight %}
 
Great, convergence after 389 iterations. Now a multiple linear regression the traditional way:
 

{% highlight r %}
model <- lm(
  price ~ size + n_rooms,
  data = house_prices %>% mutate(n_rooms = as.integer(n_rooms))
  )
{% endhighlight %}



{% highlight text %}
## Error: data_frames can only contain 1d atomic vectors and lists
{% endhighlight %}



{% highlight r %}
coef(model)
{% endhighlight %}



{% highlight text %}
## (Intercept)        size     n_rooms 
##  89597.9095    139.2107  -8738.0191
{% endhighlight %}
 
Ok So the parameters don't match, but this is because we have scaled the features. The output from the two models will be exactly the same:
 

{% highlight r %}
house_prices %<>%
  dplyr::mutate(
    vector_pred = (X %*% multi_lin_reg$theta),
    pred = coef(model)[1] + (coef(model)[2] * size) + (coef(model)[3]*as.integer(n_rooms))
    )
{% endhighlight %}



{% highlight text %}
## Error: data_frames can only contain 1d atomic vectors and lists
{% endhighlight %}



{% highlight r %}
identical(
  c(house_prices$vector_pred),
  c(house_prices$pred)
  )
{% endhighlight %}



{% highlight text %}
## [1] FALSE
{% endhighlight %}
 
Ok not identical, how come?
 

{% highlight r %}
mean(house_prices$pred - house_prices$vector_pred)
{% endhighlight %}



{% highlight text %}
## [1] 3.244767e-10
{% endhighlight %}
 
Ok so they differ by a pretty small amount, try again:
 

{% highlight r %}
all.equal(
  c(house_prices$vector_pred),
  c(house_prices$pred)
  )
{% endhighlight %}



{% highlight text %}
## [1] TRUE
{% endhighlight %}
 
And now let's plot the actual data with predictions from the multiple regression.
 

{% highlight r %}
house_prices %>%
  ggplot(
    aes(
      x = size,
      y = price,
      colour = n_rooms
      )
    )+
  geom_point()+
  geom_point(
    aes(
      x = size,
      y = pred
      ),
    shape = 2,
    )
{% endhighlight %}

![plot of chunk plot_multiple_regression_predictions](/figures/plot_multiple_regression_predictions-1.png) 

{% highlight r %}
theta <- matrix(c(1,2,3),ncol=1)
{% endhighlight %}
 
 
