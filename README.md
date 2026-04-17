# cloudrml

`cloudrml` is an R package designed to take the friction out of deploying machine learning models to Google Cloud. It handles the generation of Plumber APIs and Dockerfiles, and wraps `gcloud` commands to build and deploy your models to Cloud Run using **Artifact Registry**.

## Installation

```R
# Install the latest version from GitHub
remotes::install_github("gabbyagbobli/cloudrml")
```

---

## Workflow

### 1. Initialize Deployment Assets
Scaffold a `plumber.R` and `Dockerfile` based on your model. This command automatically filters out base R packages (like `stats`) to ensure a smooth Docker build.

```R
library(cloudrml)

# Scaffold assets into a specific deployment folder
cloudrml_init(
  model_path = "my_model.rds", 
  packages = c("xgboost", "dplyr"),
  output_dir = "deploy"
)
```

### 2. Test Locally (Requires Docker)
Before going to the cloud, verify that your container works on your local machine.

```R
# Pass the directory where you scaffolded the assets
cloudrml_test(image_name = "my-model-api", port = 8000, dir = "deploy")
```
*Visit `http://localhost:8000` to see your API docs!*

### 3. Setup GCP & Build
First-time setup requires creating a repository in Artifact Registry. Then, submit your code to Google Cloud Build.

```R
# One-time setup: Create the repo
cloudrml_create_repo(project_id = "my-gcp-project")

# Build and push to Artifact Registry
# Note: uses 'dir = "deploy"' to tell Google which folder to build
cloudrml_build(
  project_id = "my-gcp-project",
  image_name = "my-model-api",
  dir = "deploy"
)
```

### 4. Deploy to Cloud Run
Run your container as a specialized, serverless API.

```R
# Deploy and get a public URL
cloudrml_deploy(
  service_name = "my-model-api",
  project_id = "my-gcp-project"
)
```

---

## Prerequisites & Google Cloud Setup

To use this package, you must have the following installed on your machine:

1.  **Google Cloud SDK (gcloud)**: [Install here](https://cloud.google.com/sdk/docs/install).
2.  **Docker Desktop**: [Install here](https://www.docker.com/products/docker-desktop) (Required for local testing).

### One-Time GCP Configuration
Run these commands in your terminal (PowerShell or Command Prompt) to prepare your environment:

```bash
# 1. Login to Google Cloud
gcloud auth login

# 2. Set your active project
gcloud config set project [YOUR-PROJECT-ID]

# 3. Enable the required APIs (Mandatory for new projects)
gcloud services enable artifactregistry.googleapis.com \
                       cloudbuild.googleapis.com \
                       run.googleapis.com
```

---

## Troubleshooting

| Error Message | Likely Cause | Solution |
| :--- | :--- | :--- |
| **"Dependency not found: gcloud"** | gcloud is not in your PATH. | Reinstall gcloud SDK or add the `bin` folder to your System PATH. Windows users: verify `gcloud.cmd` is reachable. |
| **"Error checking gcloud authentication"** | You haven't logged in yet. | Run `gcloud auth login` in your terminal. |
| **"Port 8000 failed: port is already allocated"** | A previous test container is still running. | Stop the container in Docker Desktop or pick a new port: `port = 8001`. |
| **"API not enabled"** | Your GCP project hasn't turned on Cloud Build or Artifact Registry. | Run the `gcloud services enable` command listed in the Setup section. |
| **"Dockerfile not found"** | The `dir` argument is pointing to the wrong place. | Ensure `dir` matches the `output_dir` you used in `cloudrml_init`. |

---

## License
MIT
