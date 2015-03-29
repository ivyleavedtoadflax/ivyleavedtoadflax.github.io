---
layout: post
title: "Machine learning Exercise One"
date: "29/03/2015"
output: html_document
status: publish
published: true
---
 

 
# 2 Linear regression with one variable
 
## 2.1 Plotting the data
 
 

{% highlight r %}
ex1data1 <- "_data/ex1data1.txt" %>%
  read.csv %>% 
  set_colnames(c("profit","population")) 
 
plot(
  x = ex1data1$profit,
  y = ex1data1$population,
  ylab = "Profit ($10,000s)",
  xlab = "Population of City (10,000s)",
  col = "red"
  )
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/figures/unnamed-chunk-2-1.png) 
 
## 2.2 Gradient descent
 
### 2.2.1 Simple implementation on single parameter function
 
Let's start with a simpel implementation of gradient descent for a function which takes just on parameter. In this instance I have adapted code from Matt Bogard's execellent blog [Econometric Sense](http://econometricsense.blogspot.co.uk/2011/11/gradient-descent-in-r.html), and will use the same same function: $h_{\theta}=1.2(x-2)^2 + 3.2$. So we can state our objective to minimise $\theta_1$ with respect of $J(\theta_1)$ with a real number, or put mathetically $\min\limits_{\theta_1}J(\theta_1)$ $\theta_1\in\mathbb{R}$. We define the cost function $J(\theta_1)$ using calculus as $J(\theta)=2.4(x-2)$ (see [Matt's blog](http://econometricsense.blogspot.co.uk/2011/11/gradient-descent-in-r.html)).
 
Gradient descent is defined by Andrew Ng as:
 
repeat until convergence {
 
$$
\theta_1:=\theta_1 - \alpha\frac{d}{d\theta_1}J(\theta_1)
$$
 
}
 
where $\alpha$ is the learning rate governing the size of the step take with each iteration.
 
 
 
 

{% highlight r %}
par(mfrow=c(1,3))
 
xs <- seq(0,4,len=100) # create some values
 
# define the function we want to optimize
 
f <-  function(x) {
  1.2 * (x-2)^2 + 3.2
  }
 
# plot the function 
 
create_plot <- function(title) {
  plot(
    ylim = c(3,8),
    x = xs,
    y = f(xs), 
    type = "l", 
    xlab = "x",
    ylab = expression(1.2(x-2)^2 +3.2),
    main = title
    )
  
  abline(
    h = 3.2,
    v = 2, 
    col = "red", 
    type = 2
    )
  
}
 
cost <- function(x){
  1.2*2*(x-2)
}
 
 # df/dx = 2.4(x-2), if x = 2 then 2.4(2-2) = 0
# The actual solution we will approximate with gradeint descent
# is  x = 2 as depicted in the plot below
 
 
# gradient descent implementation
 
grad <- function(x=0.1,alpha=0.6,j=1000) {
  
  xtrace <- x
  ftrace <- f(x)
  
  for (i in 1:j) {
    
    x <- x - alpha * cost(x)
    
    xtrace <- c(xtrace,x)
    ftrace <- c(ftrace,f(x))
    
    }
  
  data.frame(
    "x" = xtrace,
    "f_x" = ftrace
    )
  }
  
create_plot(expression(Low~alpha))
 
with(
  alpha_too_low <- grad(
    x = 0.1, # initialisation of x
    alpha = 0.1, # learning rate
    j = 100 # iterations
    ),
  points(
    x, 
    f_x, 
    type = "b", 
    col = "green"
    )
  )
 
create_plot(expression(alpha~just~right))
 
with(
  alpha_just_right <- grad(
    x = 0.1, # initialisation of x
    alpha = 0.6, # learning rate
    j = 100 # iterations
    ),
  points(
    x, 
    f_x, 
    type = "b", 
    col = "blue"
    )
  )
 
 
create_plot(expression(High~alpha))
 
with(
  alpha_too_high <- grad(
    x = 0.1, # initialisation of x
    alpha = 0.8, # learning rate
    j = 100 # iterations
    ),
  points(
    x, 
    f_x, 
    type = "b", 
    col = "red"
    )
  )
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/figures/unnamed-chunk-3-1.png) 

{% highlight r %}
plot(alpha_too_low$x,type="l",col="green")
abline(v=(round(alpha_too_low$x,4)!=2) %>% which %>% length)
plot(alpha_just_right$x,type="l",col="blue")
abline(v=(round(alpha_just_right$x,4)!=2) %>% which %>% length)
plot(alpha_too_high$x,type="l",col="red")
abline(v=(round(alpha_too_high$x,4)!=2) %>% which %>% length)
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/figures/unnamed-chunk-3-2.png) 
 
## 2.2.2 Implementation of gradient descent for linear regression
 
For the implementation of gradient descent for linear regression I draw from Digithead's blog post [http://digitheadslabnotebook.blogspot.co.uk/2012/07/linear-regression-by-gradient-descent.html](http://digitheadslabnotebook.blogspot.co.uk/2012/07/linear-regression-by-gradient-descent.html).
 
Andrew Ng defines gradient descent for linear regression as:
 
repeat until convergence {
 
$\theta_0:=\theta_0 - \alpha\frac{1}{m}\sum_{i=1}^{m}(h_{\theta}(x^{(i)})-y^{(i)})$
 
$\theta_1:=\theta_1 - \alpha\frac{1}{m}\sum_{i=1}^{m}(h_{\theta}(x^{(i)})-y^{(i)})\cdot x^{i}$
 
}
 
Where $\alpha$ is the training rate, $m$ is the number of training examples, and the term on the right is the familiar squared error term after multiplication with the partial derivative $\frac{\delta}{\delta\theta_0}$ or $\frac{\delta}{\delta\theta_1}$ as appropriate.
 
Digithead's implementation of this is quite slick, and it took me a while to get my head around the vectorised implementation, so I will break it down here, for my own memory if nothing else:
 

{% highlight r %}
# Start by loading the data and splitting into vectors
 
"_data/ex1data1.txt" %>% 
  read.csv(header =  FALSE) %>%
  set_colnames(c("x","y")) -> ex1data1
 
X <- cbind(1,matrix(ex1data1$x))
 
y <- ex1data1$y
{% endhighlight %}
 
To run linear regression as a matrix multiplication it is necessary to add a column of ones, so that $x_0 = 1$. This means that when matrix $X$ is multiplied by the parameter matrx $\theta$, the intercept $\theta_0=\theta_0\times1$. i.e.:
 
$$
\begin{bmatrix}
x^0_0 & x^1_0 \\
x^0_1 & x^1_1 \\
x^0_2 & x^1_2 \\
\vdots & \vdots \\
x^0_3 & x_m 
\end{bmatrix}\times\begin{bmatrix}
\theta_0 \\
\theta_1 
\end{bmatrix}=\begin{bmatrix}
\theta_0 + (x^1_0\times\theta_1) \\
\theta_0 + (x^1_1\times\theta_1) \\
\theta_0+ (x^1_2\times\theta_1) \\
\vdots \\
\theta_0 + (x^1_m\times\theta_1)
\end{bmatrix}\approx a+bx
$$
 
We define the usual squared error cost function: $J(\theta_0,\theta_1)=\frac{1}{2m}\sum_{i=1}^{m}(h_\theta(x)-y)^2$ except that in Digithead's implementation below $h_\theta$ is defined by the matrix multiplication of $X$ and $\theta$ as described above, and rather than multiplying by $\frac{1}{2m}$, he divides by $2m$.
 
 

{% highlight r %}
cost <- function(X, y, theta) {
  sum( (X %*% theta - y)^2 ) / (2*length(y))
}
{% endhighlight %}
 
Alpha is set at a low number initially, and the number of iterations set to 1000.
 

{% highlight r %}
alpha <- 0.01
num_iters <- 1000
{% endhighlight %}
 
A vector and a list are initialised to handle the history of the cost function $J(\theta_0,\theta_1)$ and the parameters $\theta$ at each iteration.
 
 

{% highlight r %}
cost_history <- double(num_iters)
theta_history <- list(num_iters)
{% endhighlight %}
 
The coefficients for regression are initialised to zero
 

{% highlight r %}
theta <- matrix(c(0,0), nrow=2)
{% endhighlight %}
 
Finally, the gradient descent is implemented as a for loop:
 

{% highlight r %}
for (i in 1:num_iters) {  
  error <- (X %*% theta - y)
  delta <- t(X) %*% error / length(y)
  theta <- theta - alpha * delta
  cost_history[i] <- cost(X, y, theta)
  theta_history[[i]] <- theta
}
{% endhighlight %}
 
This makes a reasonably large jump, so I'll break down each line of this loop, for my own understanding.
 
Recall that Andrew Ng defines the final algorithm for gradient descent for linear regression to be:
 
repeat until convergence {
 
$\theta_0:=\theta_0 - \alpha\frac{1}{m}\sum_{i=1}^{m}(h_{\theta}(x^{(i)})-y^{(i)})$
 
$\theta_1:=\theta_1 - \alpha\frac{1}{m}\sum_{i=1}^{m}(h_{\theta}(x^{(i)})-y^{(i)})\cdot x^{(i)}$
 
}
 
The first and second lines of the loop handle the term $(h_{\theta}(x^{(i)})-y^{(i)})\cdot x^{(i)}$. The first line:
 

{% highlight r %}
error <- (X %*% theta - y)
{% endhighlight %}
 
does our linear regression by matrix multiplication, as mentioned above. The second line:
 

{% highlight r %}
delta <- t(X) %*% error / length(y)
{% endhighlight %}
 
does both the sum ($\sum_{i=1}^{m}$) and the element-wise multiplication denoted by the $\cdot x^{(i)}$. In the latter case this takes every single error (predicted - observed) score from the `error` function and multiplies it by the transpose $X$ (`t(X)`), which includes $x_0=1$.
 
To give a snippet of this calculation from the first iteration:
 
$$
\begin{bmatrix}
1.00 & 1.00 & \cdots & 1.00 \\
6.11 & 5.53 & \cdots & 5.44
\end{bmatrix}\begin{bmatrix}
-17.59 \\
-9.13\\
\vdots \\
-0.617  
\end{bmatrix}=\begin{bmatrix}
(1.00\times-17.59)+(1.00\times-9.13)+\cdots+(1.00\times-0.617) \\
(6.11\times-17.59)+(5.53\times-9.13)+\cdots+(5.44\times-0.617)
\end{bmatrix}
$$
 
So this will end with a two dimensional vector (or a $2\times1$ dimensional matrix) `delta`$\in\mathbb{R}^{2}$. The end of this line divides by the length of the vector `y`, or in the notation that I have been using so far: $m$, and this is in place of multiplying by $\frac{1}{m}$.
 
The third line of the loop:
 

{% highlight r %}
theta <- theta - alpha * delta
{% endhighlight %}
 
updates $\theta$ using the learning rate $\alpha$ multiplied by `delta`, whilst the next line:
 

{% highlight r %}
cost_history[i] <- cost(X, y, theta)
{% endhighlight %}
 
applies the sum of squares cost function to the parameters $\theta$ following the update, and saves this out to the double-precision vector `cost_history` initialised earlier.
 
Finally, the last line of the code saves out the parameter vector $\theta$ to the list `theta_history`. The loop then repeats.
 
So let's run it and see what happens...and just out of interest, I have included a call to `system.time` so we can measure how long it takes.
 
 

{% highlight r %}
system.time(
for (i in 1:num_iters) {  
  error <- (X %*% theta - y)
  delta <- t(X) %*% error / length(y)
  theta <- theta - alpha * delta
  cost_history[i] <- cost(X, y, theta)
  theta_history[[i]] <- theta
}
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.000   0.000   0.027
{% endhighlight %}



{% highlight r %}
print(theta)
{% endhighlight %}



{% highlight text %}
##           [,1]
## [1,] -3.241402
## [2,]  1.127294
{% endhighlight %}
 
We can check these values using the built in regression function in R which uses the normal equation, also with a call to `system.time`.
 

{% highlight r %}
system.time(
model <- lm(ex1data1$y~ex1data1$x)
)
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.000   0.000   0.002
{% endhighlight %}



{% highlight r %}
print(model)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = ex1data1$y ~ ex1data1$x)
## 
## Coefficients:
## (Intercept)   ex1data1$x  
##      -3.896        1.193
{% endhighlight %}
 
So interestingly this shows us that the gradient decsent run for 1000 iterations has stopped short of finding the correct answer, and also took 7 times longer. This may mean that $\alpha$ is too small, or that there were not enough iterations. The answer is close, but still not quite the same as the answer derived from the noraml equation:
 

{% highlight r %}
plot(ex1data1)
abline(a=theta[1],b=theta[2])
abline(model,col="red",lty=2)
{% endhighlight %}

![plot of chunk unnamed-chunk-16](/figures/unnamed-chunk-16-1.png) 
 
Plotting $J(\theta_0,\theta_1)$ for each iteration would indicate that we had not yet minimised $J(\theta_0,\theta_1)$, and that it is continuing to fall with each further iteration:
 

{% highlight r %}
par(mfrow=c(1,2))
 
plot(
  cost_history, 
  type = "l", 
  ylab = expression(J(theta[0],theta[1])),
  xlab = "Iteration"
  )
 
plot(
  cost_history, 
  type = "l", 
  ylab = expression(J(theta[0],theta[1])),
  xlab = "Iteration",
  xlim = c(900,1000),
  ylim = c(4.515,4.535)
  )
{% endhighlight %}

![plot of chunk unnamed-chunk-17](/figures/unnamed-chunk-17-1.png) 
 
This time I try gradient descent again with having rolled the code into a self-contained function to take arguments and follow the notation that Andrew Ng has stuck to in the machine learning course. In addition, the cost function has been changed to the vectorised form:
 
$$
J(\theta)=\frac{1}{2m}(X\theta-\vec{y})^T(X\theta-\vec{y})
$$
 

{% highlight r %}
grad <- function(alpha,j,X,y,theta) {
  
#   J <- function(X, y, theta) {
#     sum( (X %*% theta - y)^2 ) / (2*length(y))
#     }
  
  # The cost function vectorises to:
  
  J <- function(X, y, theta) {
    (1/2*length(y)) * t((X %*% theta - y)) %*% (X %*% theta - y)
    }
  
  theta_history <<- matrix(nrow=j,ncol=ncol(X)+1)
  
  for (i in 1:j) {  
    error <- (X %*% theta - y)
    delta <- t(X) %*% error / length(y)
    theta <- theta - alpha * delta
    theta_history[i,] <<- c(theta,J(X, y, theta))
    
    if (i > 1) {
      
      if (
        isTRUE(
          all.equal(
            theta_history[i,3],
            theta_history[i-1,3]
            #tolerance = # can set a tolerance here if required.
              )
          )
        ) {
        
        theta_history <<- theta_history[1:i,]
        break
        
        }
      }
    
    }
  
  list(
    theta = theta,
    cost = theta_history[i,3],
    iterations = i
    )
  
  }
 
theta <- matrix(c(0,0), nrow=2)
out <- grad(0.02,3000,X,y,theta) %>% print
{% endhighlight %}



{% highlight text %}
## $theta
##           [,1]
## [1,] -3.885737
## [2,]  1.192025
## 
## $cost
## [1] 42123.91
## 
## $iterations
## [1] 1656
{% endhighlight %}



{% highlight r %}
par(mfrow=c(1,2))
 
plot(ex1data1)
abline(a=out[[1]][1],b=out[[1]][2])
abline(model,col="red",lty=2)
 
plot(
  cost_history,
  xlab="Iteration",
  ylab=expression(J(theta[0],theta[1])),
  type="l"
  )
{% endhighlight %}

![plot of chunk unnamed-chunk-18](/figures/unnamed-chunk-18-1.png) 
 
***
 
# 3 Linear regression with multiple variables
 

 
Load the data dn produce some summaries:
 

{% highlight r %}
"_data/ex1data2.txt" %>% 
  read.csv(
    header = FALSE, 
    col.names = c("size","n_rooms","price")
    ) %>%
  dplyr::mutate(
    n_rooms = factor(n_rooms)
    ) -> house_prices
 
 
house_prices %>% head
{% endhighlight %}



{% highlight text %}
##   size n_rooms  price
## 1 2104       3 399900
## 2 1600       3 329900
## 3 2400       3 369000
## 4 1416       2 232000
## 5 3000       4 539900
## 6 1985       4 299900
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

![plot of chunk unnamed-chunk-21](/figures/unnamed-chunk-21-1.png) 
 
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
## $theta
##      [,1]
## [1,]  NaN
## [2,]  NaN
## [3,]  NaN
## 
## $cost
## [1] NaN
## 
## $iterations
## [1] 57
{% endhighlight %}



{% highlight r %}
plot(theta_history[,4],type="l")
{% endhighlight %}

![plot of chunk unnamed-chunk-23](/figures/unnamed-chunk-23-1.png) 

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
## $theta
##            [,1]
## [1,] 340412.660
## [2,] 110631.048
## [3,]  -6649.472
## 
## $cost
## [1] -6649.472
## 
## $iterations
## [1] 389
{% endhighlight %}



{% highlight r %}
plot(theta_history[,4],type="l")
{% endhighlight %}

![plot of chunk unnamed-chunk-23](/figures/unnamed-chunk-23-2.png) 
 
Great, convergence after 389 iterations. Now a multiple linear regression the traditional way:
 

{% highlight r %}
model <- lm(
  price ~ size + n_rooms,
  data = house_prices %>% mutate(n_rooms = as.integer(n_rooms))
  )
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

![plot of chunk unnamed-chunk-28](/figures/unnamed-chunk-28-1.png) 

{% highlight r %}
theta <- matrix(c(1,2,3),ncol=1)
{% endhighlight %}
 
 
 
