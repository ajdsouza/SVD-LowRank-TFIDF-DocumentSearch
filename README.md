Implements a Document Search

For the Documents and Search String we generate a TFIDF representation as a Matrix and Vector Respecitively.

Using SVD we generate a Low Rank Representation of the TFIDF matrix to eliminate noise.  

The search is executed in the new low rank vector space to pick the document that is has the smallest theta with the search vector.
