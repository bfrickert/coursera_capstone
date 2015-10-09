library(RPostgreSQL)
library(tm)
library(qdap)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
stars <- dbGetQuery(con,"select stars,name,business_id from brian.business order by 1 desc")
rm(con);rm(drv)
