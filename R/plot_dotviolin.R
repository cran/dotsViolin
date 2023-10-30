#' Makes a dot-plot and violin-plot
#'
#' This function makes a dot-plot and violin-plot, internal function
#' @param dataset dataframe with columns to be merged into 1
#' @param par dot size
#' @param groupcol categories to group
#' @param vary numeric variable
#' @param labelx x axis label
#' @param maxx x axis maximum value
#' @param adjust geom_violin adjust parameter
#' @param binwidth geom_dotplot binwidth parameter
#' @param fill_group 2nd category with 2 options as a fill aes argument for geom_dotplot
#' @param font font family
#' @param dots boolean include dot plot
#' @param violin boolean include violin plot
#' @returns ggplot
#' @keywords violin dot_plots
#' @importFrom ggplot2 geom_violin geom_dotplot coord_flip facet_grid scale_y_continuous ylab theme
#' element_blank unit element_line element_text scale_x_discrete scale_fill_manual rel aes_string
#' @importFrom scales pretty_breaks
#' @export
plot_dotviolin <- function(
    dataset, par, groupcol, vary, labelx, maxx, adjust,
    binwidth, fill_group = "fill_group", font = "mono", dots = TRUE, violin = TRUE) {
  dataset$dummy1 <- dataset[, groupcol]
  if (!fill_group %in% colnames(dataset)) {
    dataset[, fill_group] <- "only_one"
  }
  ggplot(dataset, aes_string(x = groupcol, y = vary)) +
    list(
      if (dots) {
        geom_dotplot(aes_string(fill = fill_group),
          method = "histodot", binaxis = "y", stackdir = "center", binwidth = binwidth,
          stackratio = 1, dotsize = par / (dataset$n)
        )
      },
      if (violin) {
        geom_violin(aes_string(y = vary, x = groupcol),
          scale = "width",
          alpha = 0.4, adjust = adjust
        )
      }
    ) +
    coord_flip() +
    facet_grid(dummy1 ~ ., scales = "free") +
    scale_y_continuous(limits = c(0, maxx), breaks = pretty_breaks(20), expand = c(0, 0)) +
    coord_flip() +
    ylab(labelx) +
    theme(
      strip.text.y = element_blank(),
      axis.ticks.x = element_blank(),
      axis.title.y = element_blank(),
      plot.margin = unit(c(-0.06, 1, -0.85, 0), "cm"),
      panel.grid.major = element_line(size = 1.5, colour = "white"),
      axis.text.y = element_text(family = "mono", size = rel(1)),
      legend.position = "none"
    ) +
    scale_x_discrete(position = "bottom") +
    scale_fill_manual(values = c("black", "forestgreen"))
}
