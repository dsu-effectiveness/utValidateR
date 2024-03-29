% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checker-helpers.R
\name{date_before_present_year}
\alias{date_before_present_year}
\title{Checks whether a given date falls before the present year}
\usage{
date_before_present_year(date, year = format(Sys.Date(), "\%Y"))
}
\arguments{
\item{date}{Date-valued vector to check}

\item{year}{defaults to the present year (as of \code{Sys.Date()})}
}
\description{
Used in S12a, G05a
}
