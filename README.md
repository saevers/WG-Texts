# WG-Texts
This is a script that processes linguistic data from a PDF file. 
The PDF file must be processed in advance so that it contains utterances in three lines like the following: 

this is an example
DEM.PROX COP INDEF example
'This is an example."

All additional headers and footnotes must be removed for data to be processed correctly. 

Data is saved in a .csv format that is formatted as follows: 

this     DEM.PROX   this is an example   "This is an example."
is       COP        this is an example   "This is an example."
an       INDEF      this is an example   "This is an example."
example  example    this is an example   "This is an example."

It does not matter if there are line breaks between utterances or between an utterance and its gloss or its gloss and its translation. I strongly recommend using Adobe Acrobat to properly format PDFs prior to processing. In my experience, other PDF to .doc converters ruin formatting, creating extra labor in order to get the script to work properly. 
