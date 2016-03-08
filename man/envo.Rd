\name{envo}
\alias{envo}
\docType{data}
\title{ Environment Ontology IDs}
\description{
 Environmental Ontology (ENVO) IDs and names
}
\usage{data("envo")}
\format{
  A data frame with 2251 observations on the following 2 variables.
  \describe{
    \item{\code{id}}{ ENVO 8 digit id string}
    \item{\code{name}}{ name }
  }
}
\details{ Downloaded March 5, 2016}
\source{
  ENVO id and name lines from  \url{https://raw.githubusercontent.com/EnvironmentOntology/envo/master/envo.obo}

}
%\references{ }
\examples{
data(envo)
head(envo)
}
\keyword{datasets}
