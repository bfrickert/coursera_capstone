library(rjson)

json_file <- "yelp_academic_dataset_tip.json"
con = file(json_file, "r")
input <- readLines(con, -1L)
yelp.tip <- lapply(X=input,fromJSON)

rm(input);rm(con);rm(json_file)

easy.tip <- lapply(yelp.tip, function(x){ return(list(x$business_id, x$user_id, x$date,
                                                      gsub('\t', ' ',gsub('\n', ' ',x$text)), x$likes,x$type
))})

df.tip <-data.frame(matrix(unlist(easy.tip), ncol=6,byrow=T))
names(df.tip) <- c('business_id','user_id', 'date', 'text','likes','type')

write.table(df.tip,'tips.tsv',sep='\t',row.names=F)

rm(easy.tip);rm(df.tip);rm(yelp.tip)
