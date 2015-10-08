library(jsonlite)

df.review <- stream_in(file("yelp_academic_dataset_review.json"))
df.review.votes <- data.frame(matrix(unlist(df.review$votes), ncol=3,byrow=F))
df.review.votes <- cbind(df.review$user_id,df.review.votes)
names(df.review.votes) <- c('user_id', 'funny_votes', 'useful_votes', 'votes_cool')
df.review <- df.review[,-1]
df.comb <- cbind(df.review, df.review.votes)

rm(df.review);rm(df.review.votes)

df.comb$review <- gsub('\t', ' ',gsub('\n', ' ',df.comb$text))
df.comb$text <- NA

write.table(df.comb, 'reviews.tsv',sep='\t',row.names=F)

rm(df.comb)
