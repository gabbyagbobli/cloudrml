\name{cloudrml_test}
\alias{cloudrml_test}
\title{Test Container Locally}
\usage{
cloudrml_test(image_name, port = 8000, dir = ".")
}
\arguments{
\item{image_name}{Name of the local image}

\item{port}{Local port to map (default 8000). The container's internal port 8080 is mapped to this.}

\item{dir}{Directory containing the Dockerfile (defaults to current directory ".")}
}
\description{
Builds a Docker image locally and starts a container to test your API.
}
\note{
Requires Docker Desktop to be running. If port 8000 is already in use, 
try a different port (e.g., 8001).
}
\examples{
\dontrun{
cloudrml_test("my-model-api", port = 8000, dir = "deploy")
}
}
