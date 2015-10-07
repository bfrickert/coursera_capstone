library(rjson)

json_file <- "yelp_academic_dataset_business.json"
con = file(json_file, "r")
input <- readLines(con, -1L)
yelp.business <- lapply(X=input,fromJSON)

easy <- lapply(yelp.business, function(x){ return(list(x$business_id, x$name, 
                                                       if(is.null(x$hours$Sunday$open)) NA else x$hours$Sunday$open,
                                                       if(is.null(x$hours$Sunday$close)) NA else x$hours$Sunday$close, 
                                                       if(is.null(x$hours$Monday$open)) NA else x$hours$Monday$open,
                                                       if(is.null(x$hours$Monday$close)) NA else x$hours$Monday$close, 
                                                       if(is.null(x$hours$Tuesday$open)) NA else x$hours$Tuesday$open,
                                                       if(is.null(x$hours$Tuesday$close)) NA else x$hours$Tuesday$close, 
                                                       if(is.null(x$hours$Wednesday$open)) NA else x$hours$Wednesday$open,
                                                       if(is.null(x$hours$Wednesday$close)) NA else x$hours$Wednesday$close, 
                                                       if(is.null(x$hours$Thursday$open)) NA else x$hours$Thursday$open,
                                                       if(is.null(x$hours$Thursday$close)) NA else x$hours$Thursday$close, 
                                                       if(is.null(x$hours$Friday$open)) NA else x$hours$Friday$open,
                                                       if(is.null(x$hours$Friday$close)) NA else x$hours$Friday$close,
                                                       if(is.null(x$hours$Saturday$open)) NA else x$hours$Saturday$open,
                                                       if(is.null(x$hours$Saturday$close)) NA else x$hours$Saturday$close, 
                                                       x$full_address,
                                                       x$city,x$state,x$review_count,
                                                       x$open, 
                                                       x$stars, x$latitude,
                                                       x$longitude,
                                                       x$type, paste(x$categories,collapse=" | "),
                                                       if(is.null(x$attributes$`By Appointment Only`)) NA else x$attributes$`By Appointment Only`,
                                                       if(is.null(x$attributes$`Price Range`)) NA else x$attributes$`Price Range`,
                                                       if(is.null(x$attributes$`Happy Hour`)) NA else x$attributes$`Happy Hour`,
                                                       if(is.null(x$attributes$Smoking)) NA else x$attributes$Smoking,
                                                       if(is.null(x$attributes$BYOB)) NA else x$attributes$BYOB,
                                                       if(is.null(x$attributes$Corkage)) NA else x$attributes$Corkage,
                                                       if(is.null(x$attributes$`BYOB/Corkage`)) NA else x$attributes$`BYOB/Corkage`,
                                                       if(is.null(x$attributes$Alcohol)) NA else x$attributes$Alcohol,
                                                       if(is.null(x$attributes$`Waiter Service`)) NA else x$attributes$`Waiter Service`
                                                       ))})


df <-data.frame(matrix(unlist(easy), ncol=35,byrow=T))
names(df) <- c('business_id','name','open_sun','closed_sun','open_mon','closed_mon'
               ,'open_tues','closed_tues','open_wed','closed_wed','open_thu','closed_thu'
               ,'open_fri','closed_fri','open_sat','closed_sat', 'full_address','city','state',
               'review_count','open','stars','lat','lon','type','categories', 'by_appt','price_range','happy_hour','smoking','byob','corkage','byob_corkage', 'alcohol', 'waiter_service')

attrs <- lapply(yelp.business, function(x){ return(x$attributes)})
attrs_names <- unique(unlist(lapply(attrs, names)))

