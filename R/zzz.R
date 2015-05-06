pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

is_url <- function(x){
  grepl("https?://", x, ignore.case = TRUE) || grepl("localhost:[0-9]{4}", x, ignore.case = TRUE)
}

is_port <- function(x) grepl("[[:digit:]]", x) && nchar(x) == 4

add_http <- function(x) {
  if (!grepl("http://", x, ignore.case = TRUE)) {
    paste0("http://", x)
  } else {
    x
  }
}
