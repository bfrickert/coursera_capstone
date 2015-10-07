library(rjson)

json_file <- "yelp_academic_dataset_review.json"
con = file(json_file, "r")
input <- readLines(con, 500000)
yelp.review <- lapply(X=input,fromJSON)

easy.review <- lapply(yelp.review, function(x){ return(list(x$business_id, x$user_id, x$review_id, x$date,
                                                     if(is.null(x$votes$useful)) NA else x$votes$useful,
                                                     if(is.null(x$votes$funny)) NA else x$votes$funny,
                                                     if(is.null(x$votes$cool)) NA else x$votes$cool,
                                                     x$text, x$stars,x$type
                                                     ))})

df.review <-data.frame(matrix(unlist(easy.review), ncol=10,byrow=T))
names(df.review) <- c('business_id','user_id','review_id', 'date', 'useful_votes', 'funny_votes', 'cool_votes', 'text','stars','type')
head(df.review,n=10)
