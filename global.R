library(jsonlite)
library(geojsonio)
library(dplyr)
library(leaflet)
library(imputeMissings)

# setwd("/Users/Andy_Lee/R/Code/project")
# From http://data.okfn.org/data/datasets/geo-boundaries-world-110m
geojson<- geojsonio::geojson_read("countries.geojson",what = "sp")

Country <-as.character(geojson$admin)

pop_est <-as.numeric(as.character(geojson$pop_est))

#Segregate Country and Popdata from list


Df<-cbind(Country,pop_est)

Df1<-as.data.frame(Df)

Df1$pop_est<-as.numeric(as.character(Df1$pop_est))

Df1$Country<-as.character(Df1$Country)

arrange(Df1,Country)

cat(paste(head(Df1)))


#Read csv file
dataAnalytics<-read.csv("countries-aggregated.csv",na.strings = NA,fill = NA)
dataAnalytics<-impute(dataAnalytics)
colSums(is.na(dataAnalytics))

arrange(Df1,Country)


#filter relevant data


df1<-dataAnalytics %>%filter(Date=="2020-03-27")%>%group_by(Country)
#cat(paste(head(df1$Country)))


CountryData<-left_join(Df1,df1,by="Country")



#cat(paste(head(CountryData)))

# Add the now-styled GeoJSON object to the map
bins<-seq(0,1,by=0.1)
pal <- colorBin(palette = c("green","yellow","red"),domain = c(0,100),bins = bins)


