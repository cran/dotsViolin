#' Get peaks of a continuous variable
#'
#' This function allows you to get peaks for a continuous variable.
#' Based on the kernel density function
#' @param x dataframe
#' @param bw bandwidth
#' @param signifi criteria to bin the data in number of digits
#' @param nsmall criteria to approximate (round) data
#' @param ranks numeric how many ranks to consider
#' @keywords modes
#' @export
#' @importFrom tidyr spread
#' @importFrom stats predict smooth.spline
#' @importFrom magrittr `%>%`
#' @importFrom dplyr mutate min_rank desc group_by summarize filter
#' @importFrom rlang int
#' @returns data.frame
get.peaks <- function(x, bw, signifi, nsmall, ranks = 3) {
  m <- NULL
  den <- density(x, kernel = c("gaussian"), bw = bw)
  den.s <- smooth.spline(den$x, den$y, all.knots = TRUE, spar = 0.1)
  s.1 <- predict(den.s, den.s$x, deriv = 1)
  s.0 <- predict(den.s, den.s$x, deriv = 0)
  den.sign <- sign(s.1$y)
  a <- c(1, 1 + which(diff(den.sign) != 0))
  b <- rle(den.sign)$values
  df <- data.frame(a, b)
  df <- df[which(df$b %in% -1), ]
  modes <- s.1$x[df$a]
  density <- s.0$y[df$a]
  df2 <- data.frame(modes, density)
  df2$int <- cut(df2$density,
    breaks = c(seq(min(df2$density) * (1 - 10^(-(signifi - 1))),
      max(df2$density) * (1 + 10^(-(signifi - 1))),
      by = 10^(-signifi)
    )), labels = FALSE
  )
  df <- as.data.frame(
    df2 %>%
      mutate(m = min_rank(desc(int))) %>%
      filter(m <= ranks & (m != max(m) | m == 1)) %>%
      group_by(m) %>%
      summarize(a = paste(format(round(modes, nsmall), nsmall = nsmall), collapse = ",")) %>%
      spread(m, a, sep = "")
  )
  return(df)
}
