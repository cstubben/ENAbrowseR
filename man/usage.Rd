\name{usage}
\alias{usage}
\docType{data}
\title{ ENA advanced search fields }
\description{
 Description of advanced search results, filter columns and returnable fields listed on the data warehouse usage page.
}
\usage{data("usage")}
\format{  A list of 3 tables  }
 \details{ Downloaded on Feb 22, 2016.  Domains are not included in tables since programmatic access is only available when a result is declared}
\source{ \url{http://www.ebi.ac.uk/ena/data/warehouse/usage} }
%\references{ }
\examples{
data(usage)
names(usage)
# datasets at ENA 
usage$results
# column descriptions in sample results
subset(usage$columns, grepl("sample", Result), 1:3)
# vector of sample columns (used by ena_search)
usage$fields$sample
}
\keyword{datasets}
