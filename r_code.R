#=========================SCRAPE=============================#
#Prepare for scraping each pub page in London (Central and Greater London) from the Pubs Galore website
pages <- c("barnet/greater-london/","barking/greater-london/","beckenham/greater-london/","belvedere/greater-london/","bexley/greater-london/", "bexleyheath/greater-london/","brentford/greater-london/","bromley/greater-london/","carshalton/greater-london/","chessington/greater-london/","chislehurst/greater-london/","croydon/greater-london/","dagenham/greater-london/","e10/greater-london/","e11/greater-london/","e12/greater-london/","e13/greater-london/","e15/greater-london/","e16/greater-london/","e17/greater-london/","e18/greater-london/","e20/greater-london/","e4/greater-london/","e6/greater-london/","e7/greater-london/","edgware/greater-london/","enfield/greater-london/","erith/greater-london/","feltham/greater-london/","greenford/greater-london/","hampton/greater-london/","harrow/greater-london/","hayes/greater-london/","hornchurch/greater-london/","hounslow/greater-london/","ilford/greater-london/","isleworth/greater-london/","kenley/greater-london/","keston/greater-london/","kingston-upon-thames/greater-london/","mitcham/greater-london/","morden/greater-london/",
           "n10/greater-london/","n11/greater-london/","n12/greater-london/","n13/greater-london/","n14/greater-london/","n15/greater-london/","n17/greater-london/","n18/greater-london/","n2/greater-london/","N20/greater-london/","n21/greater-london/","n22/greater-london/","n3/greater-london/","n4/greater-london/","n6/greater-london/","n8/greater-london/","n9/greater-london/","new-malden/greater-london/","northolt/greater-london/","northwood/greater-london/","NW10/greater-london/","nw11/greater-london/","nw2/greater-london/","nw4/greater-london/","nw6/greater-london/","nw7/greater-london/","nw9/greater-london/","orpington/greater-london/","pinner/greater-london/","purley/greater-london/","rainham/greater-london/","richmond/greater-london/","romford/greater-london/","ruislip/greater-london/","se11/greater-london/","se12/greater-london/","se13/greater-london/","se14/greater-london/","se15/greater-london/","se17/greater-london/","se18/greater-london/","se19/greater-london/","se2/greater-london/","se20/greater-london/","se21/greater-london/","se22/greater-london/",
           "se23/greater-london/","se24/greater-london/","se25/greater-london/","se26/greater-london/","SE27/greater-london/","se28/greater-london/","se3/greater-london/","se4/greater-london/","se5/greater-london/","se6/greater-london/","se7/greater-london/","se8/greater-london/","se9/greater-london/","sidcup/greater-london/","south-croydon/greater-london/","southall/greater-london/","stanmore/greater-london/","surbiton/greater-london/","sutton/greater-london/","sw11/greater-london/","sw12/greater-london/","sw13/greater-london/","sw14/greater-london/","sw15/greater-london/","sw16/greater-london/","sw17/greater-london/","sw18/greater-london/","SW19/greater-london/","sw2/greater-london/","SW20/greater-london/","sw4/greater-london/","sw6/greater-london/","sw8/greater-london/","sw9/greater-london/","teddington/greater-london/","thornton-heath/greater-london/","twickenham/greater-london/","upminster/greater-london/","uxbridge/greater-london/","w10/greater-london/","w12/greater-london/","w13/greater-london/","w14/greater-london/","w3/greater-london/","w4/greater-london/",
           "w5/greater-london/","w6/greater-london/","w7/greater-london/","wallington/greater-london/","welling/greater-london/","wembley/greater-london/","west-drayton/greater-london/","west-wickham/greater-london/","woodford-green/greater-london/","worcester-park/greater-london/","e1/central-london/","e14/central-london/","e2/central-london/","e3/central-london/","e5/central-london/","e8/central-london/","e9/central-london/","ec1/central-london/","ec2/central-london/","ec3/central-london/","ec4/central-london/","n1/central-london/","n16/central-london/","n19/central-london/","n5/central-london/","n7/central-london/","nw1/central-london/","nw3/central-london/","nw5/central-london/","nw8/central-london/","se1/central-london/","se10/central-london/","se16/central-london/","SW1/central-london/","sw10/central-london/","sw3/central-london/","sw5/central-london/","sw7/central-london/","w1/central-london/","w11/central-london/","w2/central-london/","w8/central-london/","w9/central-london/","wc1/central-london/","wc2/central-london/")
url <- list()
for (i in 1:length(pages)){
  urls <- paste0("https://www.pubsgalore.co.uk/towns/",pages[i])
  url[[i]] <- urls
}

#1)Scrape pub data from each page, selecting only pubs that are listed as 'open';
#2)Clean data; and 
#3)Add it to a data frame
allpubs <- lapply(url, function(i){
  webpages <- read_html(i)
  
  name <- webpages %>% html_nodes(".pubopen") %>% html_nodes("a") %>% html_text()
  name <- sub("(.*), The$", "The \\1", name)
  
  postcode <- webpages %>% html_nodes(".pubopen") %>% html_nodes(".pubpostcode") %>% html_text() %>%
    str_replace_all(pattern = ",", replacement = "")
  
  area <- webpages %>% html_nodes(".pubopen") %>% html_nodes(".pubareas") %>% html_text()
  area <- str_replace_all(area, "Coverage: ", "")
  
  address <- webpages %>% html_nodes(".pubopen") %>% html_nodes(".pubaddress") %>% html_text() %>%
    str_replace_all(pattern = "\\(", replacement = "") %>%
    str_replace_all(pattern = "\\)", replacement = area) %>%
    str_replace_all(pattern = postcode, replacement = " ")
  
  pubs <- data.frame(name, address, postcode, stringsAsFactors = FALSE)
  
})
pubs <- do.call(rbind, allpubs)

#Find and remove duplicates
pubs <- pubs %>% distinct(address, postcode, .keep_all = TRUE)
#============================================================#
