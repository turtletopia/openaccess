test_open_access <- function(doi) {
  test_that("properly recognizes Open Access", {
    expect_equal(cache_access(doi), "Open Access")
  })
}

test_open_archive <- function(doi) {
  test_that("properly recognizes Open Archive", {
    expect_equal(cache_access(doi), "Open Archive")
  })
}

test_free_access <- function(doi) {
  test_that("properly recognizes Free Access", {
    expect_equal(cache_access(doi), "Free Access")
  })
}

test_closed_access <- function(doi) {
  test_that("properly recognizes Closed Access", {
    expect_equal(cache_access(doi), "Closed Access")
  })
}
