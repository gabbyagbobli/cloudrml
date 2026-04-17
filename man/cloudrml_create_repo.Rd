\name{cloudrml_create_repo}
\alias{cloudrml_create_repo}
\title{Create Artifact Registry Repository}
\usage{
cloudrml_create_repo(project_id, repository = "cloudrml-models",
  location = "us-central1")
}
\arguments{
\item{project_id}{Google Cloud Project ID}

\item{repository}{Repository name (defaults to "cloudrml-models")}

\item{location}{GCP Region (defaults to "us-central1")}
}
\description{
Creates a Docker repository in Google Artifact Registry. This is a one-time 
setup step required before you can build and push images.
}
\note{
Requires \code{gcloud} CLI to be installed and authenticated via \code{gcloud auth login}.
}
\examples{
\dontrun{
cloudrml_create_repo(project_id = "my-project-id")
}
}
