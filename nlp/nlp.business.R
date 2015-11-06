library(RPostgreSQL)
library(tm)
library(qdap)
setwd('/home/ubuntu/coursera_capstone/')

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
joy <- dbGetQuery(con,"select categories from brian.top_categories")
misery <- dbGetQuery(con,"select
        b.categories 
    from
        brian.business b
    join
        brian.reviews r
            on r.business_id = b.business_id     --where lower(b.categories) like '%bail bond%'
             
    group by
        b.categories    
    having
        count(8) > 29    and count(distinct r.business_id) > 5 -- and avg(r.stars * 1.0000000) <3
        order by avg(r.stars * 1.0000000) limit 500
")
rm(con);rm(drv)
dest <- 'categories_nlp_docs'

write.table(joy,paste(dest,'joy.tsv',sep='/'),sep='\t',row.names=F)
write.table(misery,paste(dest,'misery.tsv',sep='/'),sep='\t',row.names=F)

# create corpus
docs <- Corpus(DirSource(dest,pattern="tsv"));rm(joy);rm(misery);rm(dest)
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
qdocs$docs <- c("joy","misery")

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
findAssocs(dtms,term="bar", corlimit=0.8)

# make a plot of freq terms with correlation above .6
plot(dtms,terms =findFreqTerms(dtms, lowfreq=50))

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

dtm.mat
