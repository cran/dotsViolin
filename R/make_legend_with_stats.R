#' Make legends with stats
#'
#' This function merges all columns in a dataframe
#' to be used as legends
#' @param data dataframe with columns to be merged into 1
#' @param namecol name to be given to new column
#' @param start_column_idx numeric index of first column to process
#' @param first_justified_left boolean when \code{TRUE} justifies first column to the left, defaults to \code{FALSE}
#' @keywords legend
#' @importFrom gtools invalid
#' @importFrom stringr str_sub
#' @importFrom dplyr case_when
#' @examples
#' fabaceae_mode_counts <- get_modes_counts(fabaceae_clade_n_df, "clade", "parsed_n")
#' fabaceae_clade_n_df_count <- make_legend_with_stats(fabaceae_mode_counts, "label_count", 1, TRUE)
#' fabaceae_Cx_mode_counts_per_clade_df <- get_peaks_counts_continuous(
#'   fabaceae_clade_1Cx_df,
#'   "clade", "Cx", 2, 0.25, 1, 2
#' )
#' namecol <- "labelcountcustom"
#' fabaceae_clade_1Cx_modes_count_df <- make_legend_with_stats(
#'   fabaceae_Cx_mode_counts_per_clade_df,
#'   namecol, 1, TRUE
#' )
#' @export
#' @returns data.frame with combined source columns
make_legend_with_stats <- function(data, namecol, start_column_idx = 2, first_justified_left = FALSE) { # nolint
  firstcol <- as.data.frame(data[, 1])
  names(firstcol) <- names(data)[1]
  data <- data[, c(start_column_idx:ncol(data))]
  data[is.na(data)] <- ""
  data[, ncol(data)] <- paste0("(", data[, ncol(data)], ")")
  nchar1 <- nchar(as.character(data[, 1]))
  nchar2 <- nchar(colnames(data)[1])
  maxlen <- max(c(nchar1, nchar2))
  justify_string <- case_when(
    first_justified_left ~ "%-",
    .default = "%"
  )
  data[, 1] <- sprintf(paste0(justify_string, maxlen, "s"), data[, 1])
  data[, ncol(data) + 1] <- paste(data[, 1], data[, 2], sep = " ")
  ncharmin2 <- min(nchar(data[, 2]))
  y <- ncharmin2 - 1
  nchara1 <- nchar(data[, ncol(data)]) # 7
  init1 <- min(nchara1)
  y2 <- init1 - 1
  minchar <- min(nchar(data[, 2]))
  maxchar <- max(c(nchar(colnames(data)[2]), (nchar(data[, 2]))))
  dif <- if (!invalid(maxchar) && !invalid(minchar)) {
    maxchar - minchar
  } else {
    0
  }
  if (dif > 0) {
    for (i3 in minchar:(maxchar - 1)) {
      y2 <- y2 + 1
      y <- y + 1
      stringr::str_sub(data[nchar(data[, ncol(data)]) == y2, ][, ncol(data)], y2 - y, y2 - y) <- "  "
    }
  }
  nd <- ncol(data) - 2
  if (ncol(data) > 3) {
    for (i in 2:nd) {
      x3 <- i
      data[, ncol(data) + 1] <- paste(data[, ncol(data)], data[, x3 + 1], sep = " ")
      minchar <- min(nchar(data[, x3 + 1]))
      maxchar <- max(c(nchar(colnames(data)[x3 + 1]), (nchar(data[, x3 + 1]))))
      ncharmin2 <- min(nchar(data[, x3 + 1]))
      y <- ncharmin2 - 1
      nchara1 <- nchar(data[, ncol(data)])
      init1 <- min(nchara1)
      y2 <- init1 - 1
      dif <- if (!gtools::invalid(maxchar) && !gtools::invalid(minchar)) {
        maxchar - minchar
      } else {
        0
      }
      if (dif > 0) {
        for (i2 in minchar:(maxchar - 1)) {
          y2 <- y2 + 1
          y <- y + 1
          stringr::str_sub(data[nchar(data[, ncol(data)]) == y2, ][, ncol(data)], y2 - y, y2 - y) <- "  "
        }
      }
    }
  }
  data <- as.data.frame(data[, c(ncol(data))])
  data <- cbind(firstcol, data)
  names(data)[2] <- paste(namecol)
  data[, 1] <- gsub("\\s+$", "", data[, 1])
  data
}
