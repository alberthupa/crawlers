install.packages("rvest")
install.packages("dplyr")
install.packages("httr")

library(rvest)
library(dplyr)
library(httr)

#trzeba to samo zrobic na https://forum.infor.pl/forum/5-ksiegowosc/

nazwa_pliku <- "mojafirma.csv"
web_content <- read_html("https://forum.infor.pl/forum/6-moja-firma/")

nody <- web_content %>% html_nodes("h4") %>% html_nodes("a") %>% html_attr("href")

for (i in 1:(length(nody)-1)) {
  dzial<-(nody[i])
  print(dzial)
  tresc<-read_html(dzial)

  watek_url <- tresc %>% html_nodes("h4") %>% html_nodes("a") %>% html_attr("href")
  #print(length(watek_url))
  for (k in 1:30) {
    tryCatch({
      watek_strona <- read_html(watek_url[k])
      tytul <- watek_strona %>% html_nodes(".ipsType_pagetitle") %>% html_text()
      tytul <- gsub(";","",tytul)
      posty <- watek_strona %>% html_nodes(".post_body") %>% html_text()
      posty <- gsub("\\\t", "", posty)
      posty <- gsub("\\\n", "", posty)
      posty <- gsub(";", "", posty) 
      for (p in 1:length(posty)) {
        zapis <- paste(dzial,tytul,posty[p],sep=";")
        #print(zapis)
        write.table(zapis,nazwa_pliku,append = TRUE,col.names = FALSE, row.names = FALSE, quote=FALSE)
      }
    },error=function(e){})
  }
  
  
  #SSIJ PODSTRONY
  liczba_stron <- tresc %>% html_nodes(".pagination") %>% html_text
  pattern<-"Strona 1 z (\\d+)"
  m <- regexpr(pattern, liczba_stron[1]) 
  m <- regmatches(liczba_stron[1], m)
  liczba_stron <- gsub("Strona 1 z ", "", m)
  liczba_stron<-as.integer(liczba_stron)
  if (liczba_stron>10) {
    liczba_stron<-10
  }
  for (j in 2:liczba_stron) {
    adres_slider<-paste(nody[i], "page-",j,sep="")
    print(adres_slider)
    tresc_in <- read_html(adres_slider)
    watek_url_in <- tresc_in %>% html_nodes("h4") %>% html_nodes("a") %>% html_attr("href")
    print("tuuuu")
    #print(watek_url_in)
    
    for (z in 1:30) {
      tryCatch({
        watek_strona <- read_html(watek_url_in[z])
        tytul <- watek_strona %>% html_nodes(".ipsType_pagetitle") %>% html_text()
        tytul <- gsub(";","",tytul)
        posty <- watek_strona %>% html_nodes(".post_body") %>% html_text()
        posty <- gsub("\\\t", "", posty)
        posty <- gsub("\\\n", "", posty)
        posty <- gsub(";", "", posty) 
        for (p in 1:length(posty)) {
          zapis <- paste(dzial,tytul,posty[p],sep=";")
          #print(zapis)
          write.table(zapis,nazwa_pliku,append = TRUE,col.names = FALSE, row.names = FALSE, quote=FALSE)
        }
      },error=function(e){})
    }    
    
  }
}
