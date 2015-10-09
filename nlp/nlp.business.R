library(RPostgreSQL)
library(tm)
library(qdap)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
stars <- dbGetQuery(con,"select stars,name,business_id from brian.business order by 1 desc")
rm(con);rm(drv)
write.table(stars[,2,3],'stars.tsv',sep='\t',row.names=F)

dest <- '.'

# create corpus
docs <- Corpus(DirSource(dest,pattern="tsv"))
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
dtm <- DocumentTermMatrix(docs)
freq <- colSums(as.matrix(dtm))


ord <- order(freq)


# most frequent terms
freq[tail(ord,n=25)]
