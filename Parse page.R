# install.packages("RCurl")


virovitica_base_url <- "http://www.viroviticko-podravska.policija.hr"
virovitica_arhiva_url_extension <- "//MainPu.aspx?id=1511&action=arhiva"


virovitica_popis <- procitaj.arhivske.izvjestaje(base_url, arhiva_url_extension)

for(i in 1:nrow(virovitica_popis)){
    
    row_url <- virovitica_popis[i,"url"]
    
    url <- paste(virovitica_base_url, row_url, sep = "//")
    
    izvjestaj <- scrape.izvjestaj(url)

    # dodaj u globalnu kolekciju
    if(exists("kolekcija_izvjestaja")){
        kolekcija_izvjestaja <- rbind(kolekcija_izvjestaja, izvjestaj)
    } else {
        kolekcija_izvjestaja <- izvjestaj
    }
}


 jedan <- scrape.izvjestaj("http://www.viroviticko-podravska.policija.hr//main.aspx?id=29539")

write.csv(x = kolekcija_izvjestaja, file = "virovitica.csv", quote = T)


kolekcija_izvjestaja$opis <- str_replace_all(kolekcija_izvjestaja$opis, "[\t\n]" , "")