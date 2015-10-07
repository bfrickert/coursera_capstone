library(rjson)

json_file <- "yelp_academic_dataset_user.json"
con = file(json_file, "r")
input <- readLines(con, -1L)
yelp.user <- lapply(X=input,fromJSON)



easy.user <- lapply(yelp.user, function(x){ return(list(x$user_id,
                                                            if(is.null(x$votes$useful)) NA else x$votes$useful,
                                                            if(is.null(x$votes$funny)) NA else x$votes$funny,
                                                            if(is.null(x$votes$cool)) NA else x$votes$cool,
                                                            x$average_stars, x$fans, length(x$friends),
                                                        if(is.null(x$compliments$hot)) NA else x$compliments$hot,
                                                        if(is.null(x$compliments$writer)) NA else x$compliments$writer,
                                                        if(is.null(x$compliments$photos)) NA else x$compliments$photos,
                                                        if(is.null(x$compliments$cool)) NA else x$compliments$cool,
                                                        if(is.null(x$compliments$funny)) NA else x$compliments$funny,
                                                        if(is.null(x$compliments$cute)) NA else x$compliments$cute,
                                                        if(is.null(x$compliments$plain)) NA else x$compliments$plain, x$name
                                                        
))})


df.user <-data.frame(matrix(unlist(easy.user), ncol=15,byrow=T), stringsAsFactors = F)
names(df.user) <- c('user_id', 'useful_votes', 'funny_votes', 'cool_votes', 'average_stars','fan_count', 'friend_count',
                    'hot_compliments', 'writer_compliments', 'photos_compliments', 'cool_compliments', 'funny_compliments', 
                    'cute_compliments', 'plain_compliments', 'name')
head(df.user,n=10)


compliments<- lapply(yelp.user, function(x){ return(x$compliments)})
compliments_names <- unique(unlist(lapply(compliments, names)))
