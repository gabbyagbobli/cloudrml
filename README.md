# cloudrml

`cloudrml` is an R package designed to take the friction out of deploying machine learning models to Google Cloud. It handles the generation of Plumber APIs and Dockerfiles, and wraps `gcloud` commands to build and deploy your models to Cloud Run using **Artifact Registry**.

## Installation

```R
# Coming soon: devtools::install_github("gabrielagbobli/cloudrml")
```

## Workflow

### 1. Initialize Deployment Assets
Scaffold a `plumber.R` and `Dockerfile` based on your model.

```R
library(cloudrml)

# Scaffold assets into a deployment folder
cloudrml_init(
  model_path = "my_model.rds", 
  packages = c("xgboost", "dplyr"),
  output_dir = "deploy"
)
```

### 2. Test Locally (Optional but Recommended)
Test your model inside a Docker container on your local machine.

```R
# Run locally on port 8000
cloudrml_test(image_name = "my-model-api")
```

### 3. Create Artifact Registry & Build
Create a repository and submit a build to Google Cloud Build.

```R
# One-time setup: Create the repo
cloudrml_create_repo(project_id = "my-gcp-project")

# Build and push to Artifact Registry
cloudrml_build(
  project_id = "my-gcp-project",
  image_name = "my-model-api"
)
```

### 4. Deploy to Cloud Run
Run your container as a serverless API.

```R
# Deploy to Cloud Run
cloudrml_deploy(
  service_name = "my-model-api",
  project_id = "my-gcp-project",
  location = "us-central1"
)
```

## Prerequisites

- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install) installed and authenticated.
- [Docker](https://www.docker.com/products/docker-desktop) installed for local testing.
- An active GCP project with Cloud Build, Cloud Run, and Artifact Registry APIs enabled.
