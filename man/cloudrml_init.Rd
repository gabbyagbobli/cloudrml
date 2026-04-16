\name{cloudrml_init}
\alias{cloudrml_init}
\title{Initialize Deployment Assets}
\usage{
cloudrml_init(model_path, packages = NULL, output_dir = ".")
}
\arguments{
\item{model_path}{Path to the saved R model (e.g., "model.rds")}

\item{packages}{Character vector of R packages required by the model}

\item{output_dir}{Directory to save the assets (defaults to current)}
}
\description{
Scaffolds a plumber.R API and a Dockerfile based on your model.
Copies the model file into the output directory to ensure a self-contained build context.
}
\examples{
\dontrun{
cloudrml_init("my_model.rds", packages = c("xgboost", "dplyr"), output_dir = "deploy")
}
}
