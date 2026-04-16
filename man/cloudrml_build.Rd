\name{cloudrml_build}
\alias{cloudrml_build}
\title{Build Container Image with Google Cloud Build}
\usage{
cloudrml_build(project_id, image_name, repository = "cloudrml-models",
  location = "us-central1", tag = "latest")
}
\arguments{
\item{project_id}{Google Cloud Project ID}

\item{image_name}{Name for the container image}

\item{repository}{Artifact Registry repository name}

\item{location}{GCP Region}

\item{tag}{Image tag (defaults to "latest")}
}
\description{
Submits a Docker build to Google Cloud Build and pushes the resulting image to Artifact Registry.
Requires gcloud CLI to be installed and authenticated.
}
\examples{
\dontrun{
cloudrml_build("my-gcp-project", "my-model-api")
}
}
