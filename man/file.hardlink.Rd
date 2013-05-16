\name{file.hardlink}
\alias{file.hardlink}
\title{Make hardlink to file}
\usage{
  file.hardlink(from, to, DryRun = FALSE, Force = FALSE)
}
\arguments{
  \item{from}{Source file}

  \item{to}{(New) target hardlink file to create}

  \item{DryRun}{Just say what would happen}

  \item{Force}{Overwrite target file if it exists}
}
\value{
  logical indicating success
}
\description{
  Uses system call to access 'ln' command line utility
}
\author{
  jefferis
}
\seealso{
  \code{\link{file.symlink}}
}

