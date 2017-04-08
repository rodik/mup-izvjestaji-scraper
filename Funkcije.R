# devtools::install_github("hadley/rvest")
library(rvest)
library(dplyr)
library(stringr)
library(RCurl)

url <- "http://www.viroviticko-podravska.policija.hr//MainPu.aspx?id=115404"

scrape.izvjestaj <- function(url, pu_id) {
    # ucitaj stranicu
    izvjestaj <- read_html(url, encoding = "UTF-8")
    
    # procitaj id -- mozda nepotrebno s obzirom da tu vec imamo URL
    id <- izvjestaj %>%
        html_node("head > base") %>%
        html_attr("href")
    
    # procitaj naslov
    naslov <- izvjestaj %>%
        html_node("div#WrapperContentText > h1") %>%
        html_text()
    
    # procitaj datum -- nekada kasnije konvertirati string u datum
    datum <- izvjestaj %>% 
        html_node("div#ContentText > span") %>%
        html_text() 
    
    # procitaj tekst izvjestaja
    opis <- izvjestaj %>%                   # opis moze biti vie cvorova / zato kasnije collapse
        html_nodes("div#ContentText > p") %>%
        html_text() %>%
        trimws()
    
    # ako nisi uspio procitati opis na taj nacin, procitaj tekst cijelog ContentText bloka
    if(length(opis) == 0) {
        opis <- izvjestaj %>%                   # opis moze biti vie cvorova / zato kasnije collapse
            html_nodes("div#ContentText") %>%
            html_text()
    }
    
    # dodatno pocisti tekst
    opis <- paste(opis, collapse = " ")
    opis <- str_replace_all(opis, "[\t\n]" , " ")
    opis <- str_replace_all(opis, ";","-")
    
    if(is.null(id) || is.null(naslov) || is.null(datum) || is.null(opis)){
        print(url) # ako ne uspijes parsirati neko polje, printaj URL za rucnu provjeru
    } else {
        # u suprotnom vrati podatke  
        data.frame(id, naslov, datum, opis = paste(opis, collapse = " ", pu_id), stringsAsFactors = FALSE)  
    }
}

procitaj.arhivske.izvjestaje <- function(base_url, arhiva_url_extensionm, pu_id){
    #cleanup
    # if(exists("svi_izvjestaji"))
    #     remove("svi_izvjestaji")
    
    # ucitaj stranicu
    arhiva <- read_html(paste(base_url, arhiva_url_extensionm, sep = "//"), encoding = "UTF-8")
    
    # procitaj koje su sve godine dostupne
    godine <- arhiva %>%
        html_nodes("div#WrapperContentText > ul") %>%
        html_children() %>%
        html_children() %>%
        html_attr("href")
    
    # iteriraj po godinama
    for(g in godine){
        # konstruiraj puni url
        url <- paste(base_url, g, sep = "//")
        
        arhiva_godine <- read_html(url, encoding = "UTF-8")
        
        # procitaj koji su mjeseci dostupni za tu godinu
        mjeseci <- arhiva_godine %>%
            html_nodes("div#WrapperContentText > ul") %>%
            html_children() %>%
            html_children() %>%
            html_children() %>%
            html_attr("href")
        
        # iteriraj po mjesecima promatrane godine
        for(m in mjeseci){
            url <- paste(base_url, m, sep = "//")
            
            arhiva_dani <- read_html(url, encoding = "UTF-8")
            
            # procitaj koji su dani dostupni za taj mjesec
            dani <- arhiva_dani %>%
                html_nodes("div#WrapperContentText > ul > li > a") %>%
                html_attr("href")
            
            # iteriraj po danima promatranog mjeseca
            for(d in dani){
                url <- paste(base_url, d, sep = "//")
                
                arhiva_jedan_dan <- read_html(url, encoding = "UTF-8")
                
                # procitaj koji su izvjestaji dostupni za taj dan
                izvjestaji <- arhiva_jedan_dan %>%
                    html_nodes("div#WrapperContentText > ul > li > a") %>%
                    html_attr("href")
                
                # procitaj parametre iz URL-a
                params <- getFormParams(d)
                
                # kreiraj tablicu i popuni kolone podacima iz URL-a
                df <- as.data.frame(izvjestaji)
                colnames(df)[colnames(df) == 'izvjestaji'] <- 'url'
                df$url <- as.character(df$url)
                
                df$godina <- params["year"]
                df$mjesec <- params["month"]
                df$dan <- params["day"]
                
                # dodaj u globalnu kolekciju
                if(exists("svi_izvjestaji")){
                    svi_izvjestaji <- rbind(svi_izvjestaji, df)
                } else {
                    svi_izvjestaji <- df
                }
            }
        }
    }
    # postavi batch identifikator
    svi_izvjestaji$pu_id <- pu_id
    # return
    svi_izvjestaji
}
