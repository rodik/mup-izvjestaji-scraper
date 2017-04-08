pu <- data.frame(
    base = c(
        'http://www.zagrebacka.policija.hr'
        ,'http://www.splitsko-dalmatinska.policija.hr'
        ,'http://www.primorska.policija.hr'
        ,'http://www.osjecko-baranjska.policija.hr'
        ,'http://www.istarska.policija.hr'
        ,'http://www.dubrovacko-neretvanska.policija.hr'
        ,'http://www.karlovacka.policija.hr'
        ,'http://www.sisacko-moslavacka.policija.hr'
        ,'http://www.sibensko-kninska.policija.hr'
        ,'http://www.vukovarsko-srijemska.policija.hr'
        ,'http://www.zadarska.policija.hr'
        ,'http://www.bjelovarsko-bilogorska.policija.hr'
        ,'http://www.brodsko-posavska.policija.hr'
        ,'http://www.koprivnicko-krizevacka.policija.hr'
        ,'http://www.krapinsko-zagorska.policija.hr'
        ,'http://www.licko-senjska.policija.hr'
        ,'http://www.medjimurska.policija.hr'
        ,'http://www.pozesko-slavonska.policija.hr'
        ,'http://www.varazdinska.policija.hr'
        ,'http://www.viroviticko-podravska.policija.hr'
    )
    ,
    extension = c(
         'MainPu.aspx?id=1294&action=arhiva'
        ,'MainPu.aspx?id=1313&action=arhiva'
        ,'MainPu.aspx?id=1324&action=arhiva'
        ,'MainPu.aspx?id=1335&action=arhiva'
        ,'MainPu.aspx?id=1346&action=arhiva'
        ,'MainPu.aspx?id=1357&action=arhiva'
        ,'MainPu.aspx?id=1368&action=arhiva'
        ,'MainPu.aspx?id=1379&action=arhiva'
        ,'MainPu.aspx?id=15981&action=arhiva'
        ,'MainPu.aspx?id=1401&action=arhiva'
        ,'MainPu.aspx?id=1412&action=arhiva'
        ,'MainPu.aspx?id=1423&action=arhiva'
        ,'MainPu.aspx?id=1434&action=arhiva'
        ,'MainPu.aspx?id=14343&action=arhiva'
        ,'MainPu.aspx?id=1456&action=arhiva'
        ,'MainPu.aspx?id=1467&action=arhiva'
        ,'MainPu.aspx?id=15353&action=arhiva'
        ,'MainPu.aspx?id=1489&action=arhiva'
        ,'MainPu.aspx?id=1500&action=arhiva'
        ,'MainPu.aspx?id=1511&action=arhiva'
    )
    ,stringsAsFactors = FALSE
)

pu$name <- substr(pu$base, start = 12, stop = regexpr(".policija",pu$base,perl = T) - 1)
pu$ID<-seq.int(nrow(pu))
