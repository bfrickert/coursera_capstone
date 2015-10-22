library(RPostgreSQL)
library(tm)
library(dplyr)
setwd('/home/ubuntu/coursera_capstone/')

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
cats <- dbGetQuery(con,"select categories from brian.business b where categories != ''")
revs <- dbGetQuery(con, "select b.categories, r.stars, u.*
                          from brian.business b
                          join brian.reviews r on r.business_id = b.business_id
                          join brian.user u on u.user_id = r.user_id
                          join brian.random_reviews rr on rr.review_id = r.review_id
                          where b.categories != ''")
sapply(100000:(100000+nrow(cats)), function(i) {write.table(cats[i-100000,1], paste('tsvs/',i,'.tsv',sep=''),sep='\t')})
rm(con);rm(drv)
write.table(cats,'cats.tsv',sep='\t',row.names=F)

dest <- 'tsvs/'

# create corpus
docs <- Corpus(DirSource(dest,pattern="tsv"))
#rm(cats)
rm(dest)
# remove numbers
docs <- tm_map(docs, removeNumbers)

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeWords, stopwords("english"))
library(SnowballC)
docs <- tm_map(docs, stemDocument)
detach('package:SnowballC')
inspect(docs)
docs <- tm_map(docs, stripWhitespace)
inspect(docs)
tdm <- TermDocumentMatrix(docs)
inspect(tdm)
dtm <- DocumentTermMatrix(docs)   
dtm   


freq <- colSums(as.matrix(dtm))   
length(freq)   
ord <- order(freq)   

m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="dtm.csv") 
df.dtm <- read.table("dtm.csv",sep=',',header=T,stringsAsFactors = F)


df.dtm <- cbind(cats$categories, df.dtm[2:nrow(df.dtm),])
names(df.dtm)[1]<-"categories"

df.mg <- merge(d,revs, by='categories')

write.table(df.dtm, 'dtm.tsv',sep='\t',row.names=F)
tail(cats)

dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
findAssocs(dtm,term="ukrainian", corlimit=0.1)

inspect(dtms)  
freq[tail(ord)]  
head(table(freq), 20)   

wf <- data.frame(word=names(freq), freq=freq)   
head(wf)

library(ggplot2)   
p <- ggplot(subset(wf, freq>50), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p   

findFreqTerms(tdm,lowfreq = 10)


df <- data.frame(inspect(tdm))

