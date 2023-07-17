#' Creates high order spatial matrix of the distance between locations
#' @export
#' @param data dataframes from distances between locations
#' @return A list the order and spatial weighting matrix of the distance between locations
#' @import maps sf tidyverse units tibble readxl
#'
#' @examples
#' hosm(simulation1)
#' hosm(simulation2)
#' hosm(simulation3)
#' hosm(simulation4)
#' hosm(simulation5)
#'
#' @references
#' Mubarak, F., Aslanargun, A., & Sıklar, I. (2022). GSTARIMA Model with Missing Value for Forecasting Gold Price. Indonesian Journal of Statistics and Its Applications, 6(1), 90–100. https://doi.org/10.29244/ijsa.v6i1p90-100
#'
#' Mubarak, F., Aslanargun, A., & Sıklar, I. (2021). High order spatial weighting matrix using Google Trends. Int J Res Rev, 8(11), 388–396. https://doi.org/10.52403/ijrr.20211150
#'
#' Mubarak, F., Aslanargun, A., & Sıklar, İ. (2022). Higher-order spatial classification using Google trends data during      covid-19. Adv. Appl. Stat., 78, 93–103. https://doi.org/10.17654/0972361722052

hosm <-function(data){
  x<-data[,-1];
  x<-data.matrix(x);
  rownames(x)<-colnames(x);
  rad<-diag(x)<-NA;
  rad<-x[lower.tri(x)]<-NA
  rad<-x[order(x)];
  max.rad<-max(rad,na.rm=TRUE);
  min.rad<-min(rad,na.rm=TRUE);
  y <- 0;
  repeat {if (y*min.rad>max.rad) break
    y=y+1
  };
  max.order<-y;
  for (order in 0:max.order) {};
  order = c();
  for(k in 0:max.order){order=c(order,k)};
  order;
  rad<-min.rad*order;
  m.order<-data[,-1];
  for (i in 1:max.order){m.order[m.order>rad[i] & m.order<=rad[i+1]]<-order[i+1]};
  m.order;
  k<-data[,-1];
  hosm<-(1/k)^m.order;
  diag(hosm)<-0;
  rownames(hosm)<-colnames(hosm);
  rownames(m.order)<-colnames(m.order)
  hosmlist<-list("Order.Matrix"=m.order,"Weight.Matrix"=hosm)
  return(hosmlist);
}
