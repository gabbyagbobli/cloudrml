\name{cloudrml_deploy}
\alias{cloudrml_deploy}
\title{Deploy to Google Cloud Run}
\usage{
cloudrml_deploy(service_name, project_id, location = "us-central1",
  image_name = service_name, repository = "cloudrml-models",
  tag = "latest", memory = "512Mi", cpu = "1")
}
\arguments{
\item{service_name}{Name for the Cloud Run service}

\item{project_id}{Google Cloud Project ID}

\item{location}{GCP Region}

\item{image_name}{Name of the image to deploy}

\item{repository}{Artifact Registry repository name}

\item{tag}{Image tag}

\item{memory}{Memory limit (default "512Mi")}

\item{cpu}{CPU count (default "1")}
}
\description{
Deploys a container image from Artifact Registry to Google Cloud Run as a managed serverless service.
The service is created with '--allow-unauthenticated' enabled.
}
\value{
The URL of the deployed service (invisibly).
}
\examples{
\dontrun{
cloudrml_deploy("my-model-api", "my-gcp-project")
}
}
