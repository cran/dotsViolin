#' Makes a composite dot-plot and violin-plot
#'
#' This function makes a dot-plot and violin-plot
#' @param dataframe dataframe
#' @param colgroup chr column to group by
#' @param collabel label to be used in the plot
#' @param maxcountcol numeric variable
#' @param maxx x axis maximum value
#' @param widthdots dotsize parameter for geom_dotplot
#' @param adjust adjust param, see geom_violin
#' @param binwidth see, plot_dotviolin
#' @param binexp digit to modify size of bins with base 10
#' @param desiredorder order for the colgroup categories
#' @param fill_group 2nd categorical data (use only 2 categories)
#' @param labelx label for x axis
#' @param dots boolean include dot plot
#' @param violin boolean include violin plot
#' @returns A grid of ggplots that mimics a single plot
#' @keywords dot-plot violin-plot
#' @importFrom ggplot2 ggplot theme element_blank
#' @examples
#' fabaceae_mode_counts <- get_modes_counts(fabaceae_clade_n_df, "clade", "parsed_n")
#' fabaceae_clade_n_df_count <- make_legend_with_stats(fabaceae_mode_counts, "label_count", 1, TRUE)
#' fabaceae_clade_n_df$label_count <- fabaceae_clade_n_df_count$label_count[match(
#'   fabaceae_clade_n_df$clade,
#'   fabaceae_clade_n_df_count$clade
#' )]
#' desiredorder1 <- unique(fabaceae_clade_n_df$clade)
#'
#' dots_and_violin(
#'   fabaceae_clade_n_df, "clade", "label_count", "parsed_n", 2,
#'   30, "Chromosome haploid number", desiredorder1, 1, .85, 4,
#'   "ownwork",
#'   violin = FALSE
#' )
#' \donttest{
#' dots_and_violin(
#'   fabaceae_clade_n_df, "clade", "label_count", "parsed_n", 2,
#'   30, "Chromosome haploid number", desiredorder1, 1, .85, 4,
#'   dots = FALSE
#' )
#' dots_and_violin(
#'   fabaceae_clade_n_df, "clade", "label_count", "parsed_n", 2,
#'   30, "Chromosome haploid number", desiredorder1, 1, .85, 4
#' )
#' }
#' fabaceae_Cx_mode_counts_per_clade_df <- get_peaks_counts_continuous(
#'   fabaceae_clade_1Cx_df,
#'   "clade", "Cx", 2, 0.25, 1, 2
#' )
#'
#' namecol <- "labelcountcustom"
#' fabaceae_clade_Cx_peaks_count_df <- make_legend_with_stats(
#'   fabaceae_Cx_mode_counts_per_clade_df,
#'   namecol, 1, TRUE
#' )
#' fabaceae_clade_1Cx_df$labelcountcustom <-
#'   fabaceae_clade_Cx_peaks_count_df$labelcountcustom[match(
#'     fabaceae_clade_1Cx_df$clade,
#'     fabaceae_clade_Cx_peaks_count_df$clade
#'   )]
#' desiredorder <- unique(fabaceae_clade_1Cx_df$clade)
#'
#' dots_and_violin(
#'   fabaceae_clade_1Cx_df, "clade", "labelcountcustom", "Cx", 3,
#'   3, "Genome Size", desiredorder, 0.03, 0.25, 2,
#'   "ownwork"
#' )
#' \donttest{
#' dots_and_violin(
#'   fabaceae_clade_1Cx_df, "clade", "labelcountcustom", "Cx", 3,
#'   3, "Genome Size", desiredorder, 0.03, 0.25, 2,
#'   dots = FALSE
#' )
#' dots_and_violin(
#'   fabaceae_clade_1Cx_df, "clade", "labelcountcustom", "Cx", 3,
#'   3, "Genome Size", desiredorder, 0.03, 0.25, 2,
#'   "ownwork",
#'   violin = FALSE
#' )
#' }
#' @export
dots_and_violin <- function(dataframe, colgroup, collabel, maxcountcol, widthdots, maxx,
                            labelx, desiredorder, binwidth, adjust, binexp,
                            fill_group = "fill_group", dots = TRUE, violin = TRUE) {
  bin_df <- binfunction(dataframe, colgroup, maxcountcol, binexp)
  maxfreq <- as.data.frame(groupingfun(bin_df, colgroup, "bin"))
  dataframe$n <- maxfreq$n[match(dataframe[, colgroup], maxfreq[, colgroup])]
  listofdf <- split(dataframe, dataframe[colgroup])
  order_index <- unlist(lapply(desiredorder, function(x) grep(x, names(listofdf))))
  ordered_list <- listofdf[order_index]
  plotout <- mapply(plot_dotviolin,
    dataset = ordered_list, par = widthdots, groupcol = collabel, vary = maxcountcol,
    labelx = labelx, adjust = adjust, binwidth = binwidth, maxx = maxx,
    fill_group = fill_group, dots = dots, violin = violin, SIMPLIFY = FALSE
  )
  plot_index <- unlist(lapply(names(plotout), function(x) grep(x, desiredorder)))
  missing <- setdiff(seq_along(desiredorder), plot_index)
  empty_df <- data.frame()
  ep <- ggplot(empty_df) +
    theme(panel.background = element_blank())
  plot2 <- list()
  plot2[plot_index] <- plotout
  plot2[missing] <- list(ep)
  gridExtra::grid.arrange(
    gridExtra::arrangeGrob(
      grobs = plot2, ncol = 1,
      heights = c(rep(1 / (length(plot2)), length(plot2)))
    ),
    bottom = grid::textGrob("", gp = grid::gpar(cex = 3))
  )
}

#' @importFrom magrittr `%>%`
#' @importFrom dplyr group_by summarise slice_max count select ungroup
#' @importFrom lazyeval interp
#' @importFrom tidyselect any_of
groupingfun <- function(df, colgroup1, varcount) {
  n <- NULL
  df %>%
    group_by(.data[[colgroup1]], .data[[varcount]]) %>%
    count() %>%
    ungroup() %>%
    select(!any_of(varcount)) %>%
    group_by(.data[[colgroup1]]) %>%
    slice_max(n)
}


binfunction <- function(x, colgroup, varcount, binexp) {
  tmp <- split(x, x[colgroup], drop = TRUE)
  tp <- lapply(tmp, function(k) {
    bin <- cut(k[, varcount],
      breaks = c(seq(min(k[, varcount]) * (1 - 10^(-(binexp + 1))),
        max(k[, varcount]) * (1 + 10^(-(binexp - 2))),
        by = 10^(-(binexp))
      )), labels = FALSE
    )
    cbind(k, data.frame(bin = bin))
  })
  tp <- do.call(rbind, tp)
  return(tp)
}
