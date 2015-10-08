library(rjson)

json_file <- "yelp_academic_dataset_user.json"
con = file(json_file, "r")
input <- readLines(con, -1L)
yelp.user <- lapply(X=input,fromJSON)

rm(input);rm(con);rm(json_file)

easy.user <- lapply(yelp.user, function(x){ return(list(x$user_id,
                                                            if(is.null(x$votes$useful)) 0 else x$votes$useful,
                                                            if(is.null(x$votes$funny)) 0 else x$votes$funny,
                                                            if(is.null(x$votes$cool)) 0 else x$votes$cool,
                                                            x$average_stars, 
                                                        if(is.null(x$fans)) 0 else x$fans, length(x$friends),
                                                        if(is.null(x$compliments$hot)) 0 else x$compliments$hot,
                                                        if(is.null(x$compliments$writer)) 0 else x$compliments$writer,
                                                        if(is.null(x$compliments$photos)) 0 else x$compliments$photos,
                                                        if(is.null(x$compliments$cool)) 0 else x$compliments$cool,
                                                        if(is.null(x$compliments$funny)) 0 else x$compliments$funny,
                                                        if(is.null(x$compliments$cute)) 0 else x$compliments$cute,
                                                        if(is.null(x$compliments$plain)) 0 else x$compliments$plain, gsub('\t', ' ',gsub('\n', ' ',x$name))
                                                        
))})



df.user <-data.frame(matrix(unlist(easy.user), ncol=15,byrow=T), stringsAsFactors = F)
names(df.user) <- c('user_id', 'useful_votes', 'funny_votes', 'cool_votes', 'average_stars','fan_count', 'friend_count',
                    'hot_compliments', 'writer_compliments', 'photos_compliments', 'cool_compliments', 'funny_compliments', 
                    'cute_compliments', 'plain_compliments', 'name')
rm(easy.user)


#compliments<- lapply(yelp.user, function(x){ return(x$compliments)})
#compliments_names <- unique(unlist(lapply(compliments, names)))

write.table(df.user,'users.tsv',sep='\t',row.names=F)

rm(df.user);rm(yelp.user)
