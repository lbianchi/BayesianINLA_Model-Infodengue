#Importing data from Infodengue API of all cities of a given State in Brazil
#Example: Parana state (399 cities)

load(file = "PR_geocode.rda") #this dataset contais names and geocode of each city
url <- "https://info.dengue.mat.br/api/alertcity/?"
geocode <- dados$geocode #geocode (ID) of each city
disease <- "dengue" #disease
format <- "csv"
ew_start <- 1    #epiweek start
ew_end <- 52     #epiweek end
ey_start <- 2013 #year start
ey_end <- 2019   #year end
urlfinal <- paste0(url,"geocode=",geocode,"&disease=",disease,
                   "&format=",format,"&ew_start=",ew_start,
                   "&ew_end=",ew_end,"&ey_start=",ey_start,"&ey_end=",ey_end)

dados <- data.frame()
for(i in 1:length(urlfinal)){
  temp <- cbind("mun_geocod" = geocode[i],read.csv(urlfinal[i]))
  #Sometimes you may find cities that doesn't have the same number of columns
  if(ncol(temp)!=19){
    temp <- temp %>% group_by(se) %>% 
      summarise(casos = sum(casos)) %>% ungroup() %>% 
      mutate(mun_geocod = geocode[i])
  }else{
    temp <- temp %>% mutate(mun_geocod, se = SE, casos) %>% select(mun_geocod, se = SE, casos)
  }
  dados <- rbind(dados,temp)
}
dados <- dados %>% mutate(mun_geocod = substr(mun_geocod, start = 1, stop = 6))
write.csv2(dados,file = "DENGV_PR2013_2019.csv")