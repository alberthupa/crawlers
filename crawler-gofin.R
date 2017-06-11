nazwa_pliku <- "gofin.csv"


link_outer <- "https://forum.gofin.pl/strona/"

for (o in 1:2500) {
  link_inner <- paste(link_outer,o,sep="")
  print(link_inner)
  web_content <- read_html(link_inner)
  nody <- web_content %>% html_nodes("div") %>%html_attr("onclick")
  pattern<-"document.location.href=\\'.*?\\'"
  watki <- regexpr(pattern, nody) 
  watki <- regmatches(nody, watki)
  watki <- gsub("document.location.href=\\'", "", watki)
  watki <- gsub("\\'", "", watki)
  watki <- as.data.frame(table(watki))[,1]
  watki <- as.character(watki)
  #print(watki)
  for (i in 1:length(watki)) {
    link<-watki[i]
    web_content <- read_html(link)
    tytul <- web_content %>% html_nodes("h1#TematPytania") 
    tytul<-as.character(tytul)
    m<-regexpr(">(.*?)<", tytul)
    tytul <- regmatches(tytul,m)
    #print(tytul)
    DaneUseraPytanie<-web_content %>% html_nodes("div#DaneUseraPytanie") 
    DaneUseraPytanie<-html_text(DaneUseraPytanie)
    DaneUseraPytanie<-as.character(DaneUseraPytanie)
    m<-regexpr("\\|\\s\\d\\d\\d\\d-\\d\\d-\\d\\d", DaneUseraPytanie)
    rok <- regmatches(DaneUseraPytanie,m)
    rok<-gsub("\\|\\s","",rok)
    #print(rok)
    DaneTrescPytanie<-web_content %>% html_nodes("div#TrescPytaniaZ") 
    DaneTrescPytanie<-html_text(DaneTrescPytanie)
    DaneTrescPytanie<-as.character(DaneTrescPytanie)
    DaneTrescPytanie <- gsub("\\\t", "", DaneTrescPytanie)
    DaneTrescPytanie <- gsub("\\\n", "", DaneTrescPytanie)
    DaneTrescPytanie <- gsub("\\\r", "", DaneTrescPytanie)
    DaneTrescPytanie <- gsub("\\\\\"", "", DaneTrescPytanie)
    DaneTrescPytanie <- gsub(";", "", DaneTrescPytanie) 
    #print(DaneTrescPytanie)
    for (d in 1:length(DaneTrescPytanie)) {
      zapis <- paste(tytul,rok,DaneTrescPytanie[d],sep=";")
      #print(zapis)
      write.table(zapis,nazwa_pliku,append = TRUE,col.names = FALSE, row.names = FALSE, quote=FALSE)
    }
  }
}
