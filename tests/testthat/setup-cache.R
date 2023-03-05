if (!dir.exists("access-fixtures")) {
  dir.create("access-fixtures")
}

cache_access <- function(doi) {
  path <- file.path("access-fixtures", gsub("[/?<>\\:*|\"]", "_", doi))

  if (file.exists(path)) {
    readLines(path)
  } else {
    val <- what_access(doi)
    writeLines(val, path)
    val
  }
}
