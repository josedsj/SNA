#install.packages("spotifyr")
library(spotifyr)
library(tidyverse)
library(knitr)
library(stringr)
library(openxlsx)
rm(list=ls())
Sys.setenv(SPOTIFY_CLIENT_ID = 'XXXXXXXXXXXXXXXXXXXXXXXXXX') # Use Spotify API
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'XXXXXXXXXXXXXXXXXXXXXXXXXX')# Use Spotify API

#Get reggaeton artists to get their genres
artists<-get_genre_artists('reggaeton',limit = 50)
#get the genres
genres<-artists%>%unnest(genres)%>%select(genres)%>%unique()%>%pull()
#create an empty list
datalist = list()
#fill the list with 50 artists per genre
for (i in genres) {
  # ... make some data
  dat <- get_genre_artists(i,limit = 50)
  #dat$i <- i  # maybe you want to keep track of which iteration produced it?
  datalist[[i]] <- dat # add it to your list
}
#as a dataframe
big_data = do.call(rbind, datalist)
#removing duplicate ids (artists)
big_data =big_data[!duplicated(big_data$id),]
#mini_data_artists=big_data[1:5,5]%>%pull()


rm(dat,i,data_artists)
data_artists = list()
#fill the list with 50 artists per genre
a=0
for (i in big_data[,5]%>%pull()) {
  tryCatch({
    # ... make some data
    print(i)
    dat <- get_artist_audio_features(artist = i)%>%
      select(c(artist_name,track_name,track_url=external_urls.spotify,artists, mode_name,key_name,explicit,album_release_date,danceability,energy))%>%
      unnest(artists) %>% 
      group_by(artist_name) %>%filter(name!=i)%>%
      select(c(artist_name,name,track_name,track_url,id, mode_name,key_name,explicit,album_release_date))
    data_artists[[i]] <- dat
  },error=function(e){})
}


data_artists = do.call(rbind, data_artists)
data_artistsbu = data_artists


data_artists$track_name<-tolower(iconv(data_artists$track_name, from="UTF-8",to="ASCII//TRANSLIT"))
data_artists$track_name<-gsub("[^[:alnum:][:space:]]","",data_artists$track_name)
#removing duplicate ids (artists)
data_artists<-data_artists[!duplicated(data_artists$track_url),]
data_artists<-data_artists [!duplicated(data_artists[c(1,2,3)]),]
data_artists$temp<-tolower(substr(data_artists$track_name,1,4))
data_artists<-data_artists [!duplicated(data_artists[c(1,2,10)]),]
data_artists<-data_artists%>%filter(artist_name!=name)

write.xlsx(data_artists,"allArtistsData.xlsx")

uart<-unique(data_artists$id)
rm(dat,i)
popularity = list()
#fill the list with 50 artists per genre
a=0
for (i in uart) {
  tryCatch({
    # ... make some data
    print(i)
    dat <- cbind(id=i,Popularity=get_artist(i)[["popularity"]])

    popularity[[i]] <- dat # add it to your list
    #print(paste0(a,"-",i))
    #a<-a+1
    
  },error=function(e){})
}

popularity = do.call(rbind, popularity)
popularity=as.data.frame(popularity)
popularity =popularity[!duplicated(popularity$id),]

unique(popularity$id)

(left_join(data_artists,popularity,c("id"="id")))%>%write.xlsx("allArtistsWithPopularity.xlsx")



#This exports edges for the genre network
big_data%>%unnest(genres)%>%select(genres,name)%>%distinct()%>%
  group_by(name)%>%mutate(weight=n())%>%
  rename(source=genres, target=name)%>%
  write.xlsx("edges_genres_network.xlsx")

#This exports nodes for the genre network
rbind(cbind(big_data%>%unnest(genres)%>%select(genres)%>%distinct()%>%pull(), "Genre"),
  cbind(big_data$name, "Artist")
)%>%as.data.frame()%>%rename(Id=V1,Label=V2)%>%
  write.xlsx("nodes_genres_network.xlsx")



  #%>%select(c(artist_name,track_url=external_urls.spotify,artists, mode_name,key_name,explicit,album_release_date))%>%unnest(artists) %>% 
#  group_by(artist_name)%>%select(c(artist_name,name,track_url,id, mode_name,key_name,explicit,album_release_date))



