##################################################################
# Web Scraping de críticas dos espectadores no adorocinema.com.br
##################################################################
# v.1
# por Guilherme Guilhermino Neto
# Última atualização: 17/11/2023

############################
# I. Pacotes
############################
library(dplyr)   # para manipulação de dados
library(rvest)   # para web scraping
library(stringr) # para manipulação de texto

####################
# II. Web scraping
####################

# Troque "link" pela URL da página
link   <- "https://www.adorocinema.com/filmes/filme-267218/criticas/espectadores/" 
pagina <- read_html(link)

# Coleta as críticas da primeira página:

criticas <- pagina %>% html_nodes(".review-card-content") %>% html_text

# Atenção: o argumento em html_nodes pode ser encontrado no código-fonte da página utilizando
# a extensão SelectorGadget do Google Chrome.

# Coleta as críticas das demais páginas

numero_paginas <- 10 # Verificar quantas páginas de comentários existem.

# Procedimento de coleta
# Aqui nós precisamos verificar no endereço (URL) qual o padrão do link. Nesse caso, muda somente o final, que é o número da página.

for(i in 2:numero_paginas) {
  
  link       <- paste("https://www.adorocinema.com/filmes/filme-267218/criticas/espectadores/?page=", as.character(i), sep='')
  pagina     <- read_html(link)
  
  criticas <- c(criticas, page %>% html_nodes(".review-card-content") %>% html_text)
  
}

# Mostra o vetor "criticas"

print(criticas)

############################
# III. Tratamento do texto
############################
# O vetor "criticas" tem alguns códigos, como o \n (que serve para saltar linha no parágrafo). Não precisamos disso, então vamos remover.

criticas_limpo <- str_replace_all(criticas, "[\r\n]" , "") # limpa

print(criticas_limpo) # mostra

dados <- data.frame(critica = criticas_limpo) # guarda em data frame

write.csv(dados, "criticas.csv", row.names = FALSE) # grava o data frame em um arquivo no computador
