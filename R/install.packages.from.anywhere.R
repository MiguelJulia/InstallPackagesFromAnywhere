#' Install R Packages from Anywhere (CRAN, Bioconductor, GitHub)
#'
#' Attempts to install packages from CRAN, then Bioconductor, and finally GitHub.
#' If a package cannot be found, it is returned in a vector.
#'
#' @param packages Character vector of package names
#' @param github_map Named vector mapping package names to GitHub repos ("owner/repo")
#' @param update Logical, whether to update dependencies in Bioconductor
#' @param verbose Logical, whether to print progress messages
#'
#' @return Character vector of packages not found
#' @export
install.packages.from.anywhere <- function(packages, github_map = NULL, update = FALSE, verbose = TRUE) {

  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    install.packages("jsonlite")
  }

  not_found <- c()

  search_github_repo <- function(pkg) {
    query <- URLencode(paste(pkg, "in:name"))
    url <- paste0("https://api.github.com/search/repositories?q=", query, "&sort=stars&order=desc")

    res <- tryCatch(jsonlite::fromJSON(url), error = function(e) NULL)
    if (is.null(res) || length(res$items) == 0) return(NULL)

    exact <- res$items[tolower(res$items$name) == tolower(pkg), ]
    if (nrow(exact) > 0) return(exact$full_name[1])

    return(res$items$full_name[1])
  }

  for (pkg in packages) {

    if (requireNamespace(pkg, quietly = TRUE)) {
      if (verbose) message(pkg, " already installed")
      next
    }

    if (verbose) message("\n=== Processing: ", pkg, " ===")

    # --- CRAN ---
    ap <- tryCatch(available.packages(), error = function(e) NULL)
    if (!is.null(ap) && pkg %in% rownames(ap)) {
      tryCatch({
        install.packages(pkg)
        if (verbose) message(pkg, " installed from CRAN")
      }, error = function(e) NULL)
    }
    if (requireNamespace(pkg, quietly = TRUE)) next

    # --- Bioconductor ---
    tryCatch({
      BiocManager::install(pkg, ask = FALSE, update = update)
      if (requireNamespace(pkg, quietly = TRUE)) {
        if (verbose) message(pkg, " installed from Bioconductor")
      }
    }, error = function(e) NULL)
    if (requireNamespace(pkg, quietly = TRUE)) next

    # --- GitHub ---
    repo <- NULL
    if (!is.null(github_map) && pkg %in% names(github_map)) {
      repo <- github_map[[pkg]]
    } else {
      repo <- search_github_repo(pkg)
    }

    if (!is.null(repo)) {
      tryCatch({
        remotes::install_github(repo, upgrade = "never")
        if (requireNamespace(pkg, quietly = TRUE)) {
          if (verbose) message(pkg, " installed from GitHub: ", repo)
        }
      }, error = function(e) NULL)
    }

    if (!requireNamespace(pkg, quietly = TRUE)) {
      not_found <- c(not_found, pkg)
      if (verbose) message(pkg, " NOT FOUND anywhere")
    }
  }

  return(unique(not_found))
}
