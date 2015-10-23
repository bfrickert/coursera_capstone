library(RPostgreSQL)
library(tm)
library(dplyr)
setwd('/home/ubuntu/coursera_capstone/')

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
cats <- dbGetQuery(con,"select distinct categories from brian.business b where categories != ''")
avg.stars <-dbGetQuery(con,"select b.categories, avg(r.stars) avg_stars
from  brian.business b
join  brian.reviews r on r.business_id = r.business_id
group by b.categories;")
cats$seq <- 100001:(100000+nrow(cats))
sapply(100000:(100000+nrow(cats)), function(i) {write.table(cats[i-100000,], paste('tsvs/',i,'.tsv',sep=''),sep='\t')})
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
df.dtm$categories <- as.character(df.dtm$categories)
df.stars <- inner_join(avg.stars,df.dtm,by='categories')
rm(df.dtm);rm(avg.stars);rm(m);rm(cats)

fit <- lm(avg_stars ~ .,df.stars[,c(2,4:ncol(df.stars))])

coefs <- data.frame(summary(fit)$coef)
coefs$name <- row.names(coefs)
names(coefs) <- c('estimate','se','t.val','p.val', 'name')
prime.coefs <- arrange(filter(coefs, p.val<.05),p.val)

fit2 <- lm(avg_stars ~ ., df.stars[,colnames(df.stars)%in%c('avg_stars', prime.coefs$names)])

dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
findAssocs(tdm,term="spas", corlimit=0.1)



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

