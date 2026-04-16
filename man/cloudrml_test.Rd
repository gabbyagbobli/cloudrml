\name{cloudrml_test}
\alias{cloudrml_test}
\title{Test Container Locally}
\usage{
cloudrml_test(image_name, port = 8000)
}
\arguments{
\item{image_name}{Name of the local image}

\item{port}{Local port to map (default 8000)}
}
\description{
Builds a local Docker image from the current directory and runs it.
This allows for local testing and debugging of the Plumber API before deploying to the cloud.
Requires Docker to be installed and running locally.
}
\examples{
\dontrun{
cloudrml_test("my-model-api")
}
}
