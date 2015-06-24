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

is_port <- function(x) {
  # strip other characters
  x <- strextract(x, "[[:digit:]]+")
  grepl("[[:digit:]]", x) && nchar(x) == 4
}

add_http <- function(x) {
  if (!grepl("https?://", x, ignore.case = TRUE)) {
    paste0("http://", x)
  } else {
    x
  }
}

comp <- function(l) {
  Filter(Negate(is.null), l)
}

empty <- function(l) {
  is_length_zero <- function(z) {
    length(z) == 0
  }
  tmp <- Filter(Negate(is_length_zero), l)
  if (length(tmp) == 1 && is(tmp, "list")) {
    tmp[[1]]
  } else {
    tmp
  }
}

strextract <- function(str, pattern) {
  regmatches(str, regexpr(pattern, str))
}

strtrim <- function(str) {
  gsub("^\\s+|\\s+$", "", str)
}
