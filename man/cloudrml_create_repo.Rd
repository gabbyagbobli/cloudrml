\name{cloudrml_create_repo}
\alias{cloudrml_create_repo}
\title{Create Artifact Registry Repository}
\usage{
cloudrml_create_repo(project_id, repository = "cloudrml-models", location = "us-central1")
}
\arguments{
\item{project_id}{Google Cloud Project ID}

\item{repository}{Repository name (defaults to "cloudrml-models")}

\item{location}{GCP Region (defaults to "us-central1")}
}
\description{
Creates a Docker repository in Google Artifact Registry to store your model images.
This is a one-time setup step per project/location.
}
\examples{
\dontrun{
cloudrml_create_repo("my-gcp-project")
}
}
