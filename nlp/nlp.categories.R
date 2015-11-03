library(RPostgreSQL)
library(tm)
library(dplyr)
library(caret)
setwd('/home/ubuntu/coursera_capstone/')



drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
cats <- dbGetQuery(con,"select distinct categories from brian.business b where categories != ''")
avg.stars <-dbGetQuery(con,"select b.categories, avg(r.stars*1.00000000000) avg_stars, u.feedback_quadrant
from  brian.business b
join  brian.reviews r on r.business_id = b.business_id
join  (select user_id, case when feedback between 0 and 2 then 1
                     when feedback between 2 and  10 then 2 
                     when feedback between 10 and 42 then 3
                     else 4 end feedback_quadrant from (
select user_id, useful_votes	+ funny_votes	+ cool_votes + fan_count	+ 
        friend_count	+ hot_compliments	+ writer_compliments	+ photos_compliments	+ 
        cool_compliments	+ funny_compliments	+ cute_compliments	+ plain_compliments feedback
from brian.user)) u on u.user_id = r.user_id
where b.categories != ''
group by b.categories, u.feedback_quadrant;")
hots <- dbGetQuery(con, 'select useful_votes	+ funny_votes	+ cool_votes + fan_count	+
                            friend_count	+ hot_compliments	+ writer_compliments	+ photos_compliments	+ 
                            cool_compliments	+ funny_compliments	+ cute_compliments	+ plain_compliments
                            from brian.user;')
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

trainIndex <- createDataPartition(df.stars$avg_stars, p = .8, list=F)
train <- df.stars[trainIndex,]
test <- df.stars[-trainIndex,]

fit <- lm(avg_stars ~ .,train[,c(2,3,5:ncol(train))])

coefs <- data.frame(summary(fit)$coef)
coefs$name <- row.names(coefs)
names(coefs) <- c('estimate','se','t.val','p.val', 'name')
prime.coefs <- arrange(filter(coefs, p.val<.05),p.val)

train <- train[,colnames(train)%in%c('categories', 'avg_stars', prime.coefs$name)]
test <- test[,colnames(test)%in%c('categories', 'avg_stars', prime.coefs$name)]

fit2 <- lm(avg_stars ~ ., train[,2:ncol(train)])

coefs <- data.frame(summary(fit2)$coef)
coefs$name <- row.names(coefs)
names(coefs) <- c('estimate','se','t.val','p.val', 'name')
prime.coefs <- arrange(filter(coefs, p.val<.05),p.val)

train <- train[,colnames(train)%in%c('categories', 'avg_stars', prime.coefs$name)]
test <- test[,colnames(test)%in%c('categories', 'avg_stars', prime.coefs$name)]

fit3 <- lm(avg_stars ~ ., train[,2:ncol(train)])

coefs <- data.frame(summary(fit3)$coef)
coefs$name <- row.names(coefs)
names(coefs) <- c('estimate','se','t.val','p.val', 'name')
prime.coefs <- arrange(filter(coefs, p.val<.05),p.val)

train <- train[,colnames(train)%in%c('categories', 'avg_stars', prime.coefs$name)]
test <- test[,colnames(test)%in%c('categories', 'avg_stars', prime.coefs$name)]

fit4 <- lm(avg_stars ~ ., train[,2:ncol(train)])


plot(df.stars$servic, df.stars$avg_stars, type = "n", frame = FALSE)
fit.servic <- lm(avg_stars~servic,df.stars)
abline(fit.servic, lwd = 2, col='pink')
abline(h = mean(df.stars[df.stars$servic!=0,]$avg_stars), lwd = 3)
abline(h = mean(df.stars[df.stars$servic==0,]$avg_stars), lwd = 3, col='yellow')
fit.servic.feedback_quadrant <- lm(avg_stars~ servic * feedback_quadrant, df.stars)
abline(coef(fit.servic.feedback_quadrant)[1], coef(fit.servic.feedback_quadrant)[2], lwd = 3, col='red')
abline(coef(fit.servic.feedback_quadrant)[1] + coef(fit.servic.feedback_quadrant)[3], coef(fit.servic.feedback_quadrant)[2] + coef(fit.servic.feedback_quadrant)[4], lwd = 3, col='purple')
points(df.stars[df.stars$servic!=0,]$servic, df.stars[df.stars$servic!=0,]$avg_stars, pch = 21, col = "black", bg = "lightblue", cex = 2)
points(df.stars[df.stars$servic==0,]$servic, jitter(df.stars[df.stars$servic==0,]$avg_stars, 14), pch = 21, col = "black", bg = "salmon", cex = 2)
summary(fit.servic.feedback_quadrant)$coefficients




###########################
## PREDICTION
###########################

tc <- trainControl(method="cv", number=5)
modFit <- train(train[3:ncol(train)], train$avg_stars, method="rf", trControl=tc)
pred <- predict(modFit, test[,3:ncol(test)])

rf.resids <- test$avg_stars - pred

resids <- test$avg_stars - predict(fit4, test[,3:ncol(test)])

par(mfrow=c(2,1))
hist(resids, breaks=40)
hist(rf.resids, breaks=40)
par(mfrow=c(1,1))

plot(predict(fit4),resid(fit4),pch=8) # residual plot - find pattern in the residuals.
inf.meas <- influence.measures(fit4)

mean(abs(pred - test$avg_stars) <= .5)
mean(abs(test$avg_stars - predict(fit4, test[,3:ncol(test)])) <= .5)

###########################
## MORE NLP
###########################

dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
findAssocs(tdm,term="wholesal", corlimit=0.1)

# Hair Care | Hair Removal | Hair Salon | Hair Blowout

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

