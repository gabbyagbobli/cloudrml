#' Initialize Deployment Assets
#'
#' @param model_path Path to the saved R model (e.g., "model.rds")
#' @param packages Character vector of R packages required by the model
#' @param output_dir Directory to save the assets (defaults to current)
#' @export
cloudrml_init <- function(model_path, packages = NULL, output_dir = ".") {
  if (!file.exists(model_path)) {
    stop("Model file not found: ", model_path)
  }
  
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Copy model to output directory
  dest_model_path <- file.path(output_dir, basename(model_path))
  if (normalizePath(model_path) != normalizePath(dest_model_path)) {
    file.copy(model_path, dest_model_path, overwrite = TRUE)
  }
  
  # Prepare template data
  data <- list(
    model_path = basename(model_path),
    model_name = tools::file_path_sans_ext(basename(model_path)),
    extra_packages_exist = length(packages) > 0,
    extra_packages = if (length(packages) > 0) paste0("'", paste(packages, collapse = "', '"), "'") else ""
  )
  
  # Read templates
  tpl_dir <- system.file("templates", package = "cloudrml")
  # Fallback for dev environment
  if (tpl_dir == "") tpl_dir <- "inst/templates"
  
  plumber_tpl <- readLines(file.path(tpl_dir, "plumber_template.R"), warn = FALSE)
  docker_tpl <- readLines(file.path(tpl_dir, "dockerfile_template"), warn = FALSE)
  
  # Render templates
  plumber_content <- whisker::whisker.render(plumber_tpl, data)
  docker_content <- whisker::whisker.render(docker_tpl, data)
  
  # Write files
  writeLines(plumber_content, file.path(output_dir, "plumber.R"))
  writeLines(docker_content, file.path(output_dir, "Dockerfile"))
  
  message("\u2705 Assets scaffolded in: ", output_dir)
}

#' Create Artifact Registry Repository
#'
#' @param project_id Google Cloud Project ID
#' @param repository Repository name (defaults to "cloudrml-models")
#' @param location GCP Region (defaults to "us-central1")
#' @export
cloudrml_create_repo <- function(project_id, repository = "cloudrml-models", location = "us-central1") {
  check_auth()
  message("\ud83d\udce6 Creating Artifact Registry repository...")
  
  args <- c(
    "artifacts", "repositories", "create", repository,
    "--project", project_id,
    "--repository-format=docker",
    "--location", location,
    "--description=Repository for cloudrml models"
  )
  
  # Check if exists first would be better, but we'll use tryCatch or just let gcloud error
  tryCatch({
    processx::run("gcloud", args, echo = TRUE)
    message("\u2705 Repository ready: ", repository)
  }, error = function(e) {
    if (grepl("already exists", e$message)) {
      message("\u2139\ufe0f Repository already exists, skipping creation.")
    } else {
      stop(e)
    }
  })
}

#' Build Container Image with Google Cloud Build
#'
#' @param project_id Google Cloud Project ID
#' @param image_name Name for the container image
#' @param repository Artifact Registry repository name
#' @param location GCP Region
#' @param tag Image tag (defaults to "latest")
#' @export
cloudrml_build <- function(project_id, image_name, repository = "cloudrml-models", location = "us-central1", tag = "latest") {
  check_auth()
  image_uri <- sprintf("%s-docker.pkg.dev/%s/%s/%s:%s", location, project_id, repository, image_name, tag)
  
  message("\ud83d\ude80 Submitting build to Google Cloud Build...")
  message("\ud83d\udce6 Image URI: ", image_uri)
  
  args <- c(
    "builds", "submit",
    "--tag", image_uri,
    "--project", project_id
  )
  
  processx::run("gcloud", args, echo = TRUE)
  message("\u2705 Build complete!")
}

#' Deploy to Google Cloud Run
#'
#' @param service_name Name for the Cloud Run service
#' @param project_id Google Cloud Project ID
#' @param location GCP Region
#' @param image_name Name of the image to deploy
#' @param repository Artifact Registry repository name
#' @param tag Image tag
#' @param memory Memory limit (default "512Mi")
#' @param cpu CPU count (default "1")
#' @export
cloudrml_deploy <- function(service_name, project_id, location = "us-central1", image_name = service_name, 
                            repository = "cloudrml-models", tag = "latest", memory = "512Mi", cpu = "1") {
  check_auth()
  image_uri <- sprintf("%s-docker.pkg.dev/%s/%s/%s:%s", location, project_id, repository, image_name, tag)
  
  message("\ud83d\ude80 Deploying to Google Cloud Run...")
  
  args <- c(
    "run", "deploy", service_name,
    "--image", image_uri,
    "--region", location,
    "--platform", "managed",
    "--allow-unauthenticated",
    "--project", project_id,
    "--memory", memory,
    "--cpu", cpu
  )
  
  processx::run("gcloud", args, echo = TRUE)
  
  # Fetch the URL
  url_args <- c("run", "services", "describe", service_name, "--platform", "managed", "--region", location, "--project", project_id, "--format", "value(status.url)")
  res <- processx::run("gcloud", url_args)
  url <- trimws(res$stdout)
  
  message("\u2705 Deployment successful!")
  message("\ud83d\udd17 Service URL: ", url)
  return(url)
}

#' Test Container Locally
#'
#' @param image_name Name of the local image
#' @param port Local port to map (default 8000)
#' @export
cloudrml_test <- function(image_name, port = 8000) {
  check_binary("docker")
  message("\ud83e\uddea Testing container locally on port ", port, "...")
  message("\u2139\ufe0f This requires Docker to be running locally.")
  
  # First build locally
  message("\ud83d\udee0\ufe0f Building local image: ", image_name)
  processx::run("docker", c("build", "-t", image_name, "."), echo = TRUE)
  
  message("\ud83d\uddfa\ufe0f Starting container...")
  message("\u2139\ufe0f Press Ctrl+C in the R console to stop.")
  
  processx::run("docker", c("run", "--rm", "-p", paste0(port, ":8080"), image_name), echo = TRUE)
}

# --- Internal Helpers ---

check_binary <- function(bin) {
  res <- tryCatch({
    # works on windows and unix
    processx::run(if(.Platform$OS.type == "windows") "where" else "which", bin)
    TRUE
  }, error = function(e) FALSE)
  
  if (!res) {
    stop(sprintf("Dependency not found: '%s'. Please ensure it is installed and in your PATH.", bin))
  }
}

check_auth <- function() {
  check_binary("gcloud")
  
  # Check if authenticated
  res <- tryCatch({
    processx::run("gcloud", c("auth", "list", "--filter=status:ACTIVE", "--format=value(account)"))
  }, error = function(e) {
    stop("Error checking gcloud authentication. Is gcloud installed?")
  })
  
  if (trimws(res$stdout) == "") {
    stop("No active Google Cloud account found. Please run 'gcloud auth login' first.")
  }
}
