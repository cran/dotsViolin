#' get modes, handle ties, ignore less frequent values
#'
#' This function comes from an answer for a question in stackoverflow
#' https://stackoverflow.com/questions/42698465/obtaining-3-most-common-elements-of-groups-concatenating-ties-and-ignoring-les
#' @param data data.frame
#' @param grouping_col string split by this column
#' @param col2 string numerical data column
#' @param mode_number numeric number of modes to retrieve
#' @examples
#' get_modes_counts(fabaceae_clade_n_df, "clade", "parsed_n")
#' @export
#' @returns data.frame with modes and counts per group
get_modes_counts <- function(data, grouping_col, col2, mode_number = 3) {
  stopifnot(mode_number > 0)
  data_list <- lapply(split(data, data[[grouping_col]]), function(x) {
    val <- factor(x[[col2]])
    z1 <- tabulate(val)
    z2 <- sort(z1[z1 > 0], decreasing = TRUE)
    lenx <- length(unique(z2))
    if (lenx == 1) {
      return(c(paste((levels(val)[which(z1 %in% z2)]), collapse = ","), rep(NA_character_, mode_number - 1), sum(z1)))
    } else if (lenx > 1) {
      z2 <- setdiff(z2, min(z2))
      z2 <- sapply(z2, function(y) paste(levels(val)[which(z1 %in% y)], collapse = ","))
      z2_ind <- which(cumsum(lengths(unlist(lapply(z2, strsplit, split = ","), recursive = FALSE))) >= mode_number)
      if (length(z2_ind) > 0) {
        z2 <- z2[seq_len(z2_ind[1])]
      }
      if (length(z2) != mode_number) {
        z2[(length(z2) + 1):mode_number] <- NA_character_
      }
      return(c(z2, sum(z1)))
    } else {
      return(as.list(rep(NA_character_, mode_number), NA_character_))
    }
  })
  data_list <- do.call("rbind", data_list)
  result_df <- data.frame(group = rownames(data_list), data_list, stringsAsFactors = FALSE)
  colnames(result_df) <- c(grouping_col, paste("m", 1:mode_number, sep = ""), "count")
  rownames(result_df) <- NULL
  return(result_df)
}
