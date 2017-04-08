
parsiraj.sve <- function(pu){
    # cleanup
    # if(exists("popis_svih"))
    #     rm("popis_svih")
    # if(exists("kolekcija_izvjestaja"))
    #     rm("kolekcija_izvjestaja")
    
    for(i in 1:nrow(pu)){
        
        pol_up <- pu[i,] # iduca policijska uprava
        
        trenutni_popis <- procitaj.arhivske.izvjestaje(pol_up$base, pol_up$extension, pol_up$ID)
        
        # dodaj u globalnu kolekciju
        if(exists("popis_svih")){
            popis_svih <- rbind(popis_svih, trenutni_popis)
        } else {
            popis_svih <- trenutni_popis
        }
        
        for(u in trenutni_popis$url){
            
            url <- paste(pol_up$base, u, sep = "//")
            
            izvjestaj <- scrape.izvjestaj(url, pol_up$ID)
            
            # dodaj u globalnu kolekciju
            if(exists("kolekcija_izvjestaja")){
                kolekcija_izvjestaja <- rbind(kolekcija_izvjestaja, izvjestaj)
            } else {
                kolekcija_izvjestaja <- izvjestaj
            }
        }
        print(pol_up$ID)
    }
    # return
    list(popis_svih, kolekcija_izvjestaja)
}

dohvati.popis <- function(pu_list){
    # cleanup
    # if(exists("popis_svih"))
    #     rm("popis_svih")
    # if(exists("kolekcija_izvjestaja"))
    #     rm("kolekcija_izvjestaja")
    
    for(i in 1:nrow(pu_list)){
        
        pol_up <- pu_list[i,] # iduca policijska uprava
        
        trenutni_popis =  
            tryCatch({
                procitaj.arhivske.izvjestaje(pol_up$base, pol_up$extension, pol_up$ID)
            }, warning = function(cond) {
                # warning-handler-code
            }, error = function(cond) {
                # message(paste("URL does not seem to exist:", url))
                message("Here's the original error message:")
                message(cond)
                # Choose a return value in case of error
                return(NA)
            })
        
        # dodaj u globalnu kolekciju
        if(!is.na(trenutni_popis)){
            if(exists("popis_svih")){
                popis_svih <- rbind(popis_svih, trenutni_popis)
            } else {
                popis_svih <- trenutni_popis
            }
        }
        
        print(pol_up$ID)
    }
    # return
    popis_svih
}

skupi.izvjestaje <- function(popis){
    
    for(i in 1:nrow(popis)){
        
        report <- popis[i,]
        
        if(report$parsed == FALSE){
            url <- paste(report$base, report$url, sep = "//")
            
            izvjestaj = tryCatch({
                a <- scrape.izvjestaj(url, report$pu_id)
                
                if(!is.null(a) && !is.na(a) && nrow(a) > 0){
                    popis[i,"parsed"] <- TRUE
                    
                    # ako sadrzava u sebi bicikl, dodaj ga medu biciklisticke
                    if(length(grep(pattern = "bicik*", a$opis, ignore.case = TRUE)) > 0){
                        # dodaj u globalnu kolekciju
                        if(exists("biciklisti")){
                            biciklisti <- rbind(biciklisti, a)
                        } else {
                            biciklisti <- a
                        }
                    }
                    
                }
                a
            }, warning = function(cond) {
                # warning-handler-code
            }, error = function(cond) {
                message(paste("URL does not seem to exist:", url))
                message("Here's the original error message:")
                message(cond)
                # Choose a return value in case of error
                return(NA)
            })
        }
        print(i)
        Sys.sleep(0.1)
    }
    list(popis, biciklisti)
}

