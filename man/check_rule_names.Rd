% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/testdata.R
\name{check_rule_names}
\alias{check_rule_names}
\title{QC-check on rule names--these should all match rule names in checklist}
\usage{
check_rule_names(df, checklist, colname = "USHE rule")
}
\arguments{
\item{df}{dataframe to check}

\item{checklist}{dataframe containing rule specification}

\item{colname}{Column name for \code{df} containing rule names}
}
\description{
Rows with non-matching names are removed with a warning
}
