\name{cloudrml_init}
\alias{cloudrml_init}
\title{Initialize Deployment Assets}
\usage{
cloudrml_init(model_path, packages = NULL, output_dir = ".")
}
\arguments{
\item{model_path}{Path to the saved R model (e.g., "model.rds")}

\item{packages}{Character vector of R packages required by the model}

\item{output_dir}{Directory to save the assets (defaults to current directory ".")}
}
\description{
Scaffolds a \code{plumber.R} and \code{Dockerfile} based on your model. It also copies
the model to the destination directory. Base R packages (e.g., 'stats') are
automatically filtered out to prevent installation errors during the Docker build.
}
\examples{
\dontrun{
cloudrml_init("my_model.rds", packages = c("xgboost"), output_dir = "deploy")
}
}
