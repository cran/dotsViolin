#' Peaks of a continuous variable in a dataframe format
#'
#' This function allows you to get peaks and summary counts per group for a continuos variable in a dataframe format.
#' Handles ties; least frequent is ignored, except if it is the only
#' one, depends on \code{get.peaks} function
#' @param origtable dataframe
#' @param grouping_col column with categories - character
#' @param columnname column with numerical data
#' @param peak_number number of peaks to get, see get.peaks
#' @param adjust1 bandwith adjust parameter
#' @param signifi see get.peaks function
#' @param nsmall see get.peaks function
#' @returns data.frame
#' @examples
#' get_peaks_counts_continuous(fabaceae_clade_1Cx_df, "clade", "Cx", 2, 0.25, 1, 2)
#' @keywords peaks
#' @export
#' @importFrom stats bw.nrd0 smooth.spline
get_peaks_counts_continuous <- function(origtable, grouping_col, columnname, peak_number, adjust1, signifi, nsmall) {
  tmp <- split(origtable, origtable[[grouping_col]], drop = TRUE)
  modelist <- lapply(tmp, function(xx) {
    if (nrow(xx) == 1) {
      c(
        list(paste(format((ceiling(xx[, columnname] * 10^nsmall) / 10^nsmall), nsmall = nsmall))),
        rep(list(""), (peak_number - 1))
      )
    } else {
      lapply(1:peak_number, function(n) {
        tryCatch(
          paste(get.peaks(
            xx[, columnname],
            tryCatch(bw.nrd0(xx[, columnname]) * adjust1,
              error = function(e) {
                "bw.nrd0 in get.peaks couldn't produce a result"
                1
              }
            ),
            signifi, nsmall, peak_number
          )[n]),
          error = function(e) {
            message("get.peaks couldn't produce a result, peak not identifiable")
            NA
          }
        )
      })
    }
  })
  modelist_NA_replaced <- lapply(modelist, function(x) {
    unlist(lapply(x, function(y) {
      if (is.na(y)) {
        ""
      } else {
        if (grepl("get.peaks", y)) {
          ""
        } else {
          y
        }
      }
    }))
  })
  modes_df <- as.data.frame(do.call(rbind, modelist_NA_replaced), stringsAsFactors = FALSE)
  colnames(modes_df) <- paste0("m", seq_len(ncol(modes_df)))
  counts <- unlist(lapply(tmp, function(xx) length2(xx[[columnname]], na.rm = TRUE)))
  modes_df$counts <- counts
  modes_df[, grouping_col] <- rownames(modes_df)
  modes_df <- modes_df[, c(ncol(modes_df), 1:(ncol(modes_df) - 1))]
  return(modes_df)
}

length2 <- function(x, na.rm = FALSE) {
  if (na.rm) {
    sum(!is.na(x))
  } else {
    length(x)
  }
}
