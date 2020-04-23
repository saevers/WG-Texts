library(pdftools)
library(tm)

#Read in PDF
read <- readPDF(control = list(text = "-layout")) 
n1 <- Corpus(URISource("kalnar4.pdf"), readerControl = list(reader=read))
doc <- content(n1[[1]])

trim <- function (x) gsub("^\\s+|\\s+$", "", x)
doc1 <- trim(doc)
doc1 <- strsplit(doc, "\r\n")
doc1 <- unlist(doc1)

#Check doc1 to see if there are any blank or otherwise anamalous rows and remove them
doc1 <- doc1[-x] #where X is the element number that needs to be removed, if necessary

#Every third row after 1 is an utterance. Every third row after 2 is a gloss. Every third row after 3 is a translation.
#This code starts at a specified point (element 1, 2, or 3 of a text) and creates a vector from a sequence that is counted by threes. 
#This will only work if the data is properly cleaned.

utts <- doc1[seq(1, length(doc1), 3)]
gloss <- doc1[seq(2, length(doc1), 3)]
trans <- doc1[seq(3, length(doc1), 3)]

#Create a trim function to eliminate beginning and ending white space

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

#Clean utterances

utts1 <- gsub("\\s+", " ", utts) #Remove additional spaces
utts1 <- gsub("\\(.*\\)", "", utts1) #Remove parentheses and anything within them
utts1 <- gsub("\\.|\\,", "", utts1) #Remove periods and commas
utts1 <- gsub(" if| fb| ff| mf| ib", "", utts1) #Remove pragmatic code
utts1 <- gsub(" \\-", "\\-", utts1) #Remove spaces around hyphens
utts1 <- gsub("\\- ", "\\-", utts1) #Remove spaces around hyphens
utts1 <- trim(utts1) #Trim whitespace


#Clean Translations
trans1 <- gsub("fb", "", trans) #Remove pragmatic code
trans1 <- trim(trans1)



#Clean Glosses
gloss1 <- trim(gloss)
gloss1 <- gsub("\\s+", " ", gloss1)
gloss1 <- gsub(" \\-", "\\-", gloss1)
gloss1 <- gsub("\\- ", "\\-", gloss1)
gloss1 <- gsub(" if| fb| ff| mf| ib", "", gloss1)

#Split translations and glosses
utts2 <- strsplit(utts1, " ") #Create a new list of the utterances
gloss2 <- strsplit(gloss1, " ")

#These for loops create a list of sentences and translations that will match up to the utterances

sentences <- c()
n <- 0

for (i in utts1) {
  n = n +1
  v = utts1[n]
  e = length(utts2[[n]])
  f <- rep(v, times = e)
  sentences <- append(sentences, f)
  
}

translations <- c()
n <- 0

for (i in utts1) {
  n = n +1
  v = trans1[n]
  e = length(utts2[[n]])
  f <- rep(v, times = e)
  translations <- append(translations, f)
  
}


#Turn utterances and glosses back into vectors
utts2 <- unlist(utts2)
gloss2 <- unlist(gloss2)


#Create a new list of all four elements

doclist <- list()

doclist[["Word"]] <- utts2
doclist[["Gloss"]] <- gloss2
doclist[["Sentence"]] <- sentences
doclist[["Translation"]] <- translations


data <- as.data.frame(doclist)
data$Translation <- gsub("\\s+", " ", data$Translation)

write.csv(file="kalnar2.csv", data)

