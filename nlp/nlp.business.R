library(RPostgreSQL)
library(tm)
library(qdap)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
stars <- dbGetQuery(con,"select stars,name,business_id from brian.business order by 1 desc")
reviews <- dbGetQuery(con,"select r.review 
from brian.reviews r join brian.business b on b.business_id = r.business_id 
where (lower(r.review) like '%lobster%' or lower(r.review) like '%seafood%') 
  and (lower(b.categories) not like '%food%' and lower(b.categories) not like '%restaurant%')")
rm(con);rm(drv)
write.table(stars,'stars.tsv',sep='\t',row.names=F)
write.table(reviews,'reviews.tsv',sep='\t',row.names=F)

dest <- '.'

# create corpus
docs <- Corpus(DirSource(dest,pattern="tsv"));rm(stars);rm(reviews);rm(dest)
# remove numbers
docs <- tm_map(docs, removeNumbers)

# remove stop words
docs <- tm_map(docs, removeWords, stopwords("SMART"))

# make all letters lower case
docs <- tm_map(docs, content_transformer(tolower))
# remove numbers
docs <- tm_map(docs, removeNumbers)

# remove stop words
docs <- tm_map(docs, removeWords, stopwords("SMART"))

# make all letters lower case
docs <- tm_map(docs, content_transformer(tolower))

# convert corpus to data frame
qdocs <- as.data.frame(docs)

# put in author names
#qdocs$docs <- c("Brady","Curcio","France","Gangewere","Horne","Kandrack","Valchev","Vicinie","Whitaker")

# remove misc anomalies and white spaces
qdocs$text <- clean(Trim(qdocs$text))

# replace symbols with words a.k.a. % with 'percent'
qdocs$text <- replace_symbol(qdocs$text)

# replace Ph.D with doctor
qdocs$text <- gsub("ph.d.","Doctor",qdocs$text)


# replace other abbreviations
qdocs$text <- replace_abbreviation(qdocs$text)

# remove all abbreviated middle names
#qdocs$text <- mgsub(paste0(" ",letters,".")," ",qdocs$text)

rm(dest)

sent.docs <- sentSplit(qdocs,"text")

sent.docs$scaled <- unlist(tapply(wc(sent.docs$text), sent.docs$docs, scale))
sent.docs$ID <- factor(unlist(tapply(sent.docs$docs, sent.docs$docs, seq_along)))

library(ggplot2); library(grid)

ggplot(sent.docs, aes(x = ID, y = scaled, fill = docs)) +
  geom_bar(stat ="identity", position ="identity",size = 5) +
  facet_grid(.~docs) + 
  ylab("Standard Deviations") + xlab("Sentences") +
  guides(fill = guide_legend(nrow = 1, byrow = TRUE,title="Author"))+ 
  theme(legend.position="bottom",axis.text = element_blank(), axis.ticks = element_blank()) +
  ggtitle("Standardized Word Counts\nPer Sentence")+coord_flip()

library(SnowballC)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)

docs <- tm_map(docs, stemDocument)

dtm <- DocumentTermMatrix(docs)
freq <- colSums(as.matrix(dtm))


ord <- order(freq)


# most frequent terms
freq[tail(ord,n=25)]

dtms <- removeSparseTerms(dtm, 0.3)
dtms

# find terms with higest frequency
# low freq chosen to produce most frequent
findFreqTerms(dtms, lowfreq=15)

# find words with high correlation to state
findAssocs(dtms,term="family", corlimit=0.01)

# make a plot of freq terms with correlation above .6
plot(dtms,terms =findFreqTerms(dtms, lowfreq=100),corThreshold=0.6)

library(reshape2)

dtm.mat <- as.matrix(dtm)

dtm.melt <- melt(dtm.mat)

dtm.melt <- as.data.frame(dtm.melt)

knitr::kable(head(dtm.melt,n=10))

term.table <- table(nchar(as.character(dtm.melt$Terms)))

# get mode of word counts
term.mode <- as.numeric(names(term.table[which(term.table==max(term.table))]))

# make condition to highlight mode
cond <- nchar(as.character(dtm.melt$Terms))*dtm.melt$value == term.mode

#make a pretty graph
ggplot(dtm.melt) + geom_histogram(data=subset(dtm.melt,cond==FALSE),binwidth=1,aes(x=nchar(as.character(Terms))*value,fill=Docs))+
  facet_grid(Docs~.) + geom_histogram(data=subset(dtm.melt,cond==TRUE),binwidth=1,aes(x=nchar(as.character(Terms))*value),title="Mode",fill="red")+
  labs(x="Number of Letters",y="Number of Words") + xlim(1,20)  +
  guides(fill = guide_legend(nrow = 9, byrow = TRUE ,title="Author"))+ 
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  ggtitle("Length of each word \n by Author")+
  geom_text(data=data.frame(x=6.5, y=30, label="Mode", stat=c("ta")),aes(x,y,label=label),size=3, inherit.aes=TRUE)
