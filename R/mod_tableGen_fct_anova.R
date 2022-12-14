#' Generate ANOVA using table generator blocks
#'
#' @param column the variable to perform ANOVA on,
#' this also contains the class of the column
#' based on the data file the column came from
#' @param week filter the variable by certain week
#' @param group the groups to compare for the ANOVA
#' @param data the data to use 
#'
#' @return an ANOVA table of grouped variables
#' @family tableGen Functions
#' @keywords tabGen
#' 
#' @noRd
app_anova <- function(column, week, group, data) {
  UseMethod("app_anova", column)
}


#' @return NULL
#' @rdname app_anova
#' @family tableGen Functions
#' @noRd

app_anova.default <- function(column, week, group, data) {
  rlang::abort(glue::glue(
    "Can't calculate mean because data is not classified as ADLB, BDS or OCCDS",
  ))
}

#' if ADSL supplied look for the column to take mean of
#' and look for a grouping variable to group_by
#' 
#' @importFrom rlang sym !! 
#' @import dplyr
#' @return an ANOVA table of grouped variables
#' @rdname app_anova
#' @family tableGen Functions
#' 
#' @noRd

app_anova.ADAE <- app_anova.ADSL <- function(column, week, group = NULL, data) {
  
  column <- as.character(column)
  
  if (!is.numeric(data[[column]])) {
    stop(paste("Can't calculate ANOVA, ", column, " is not numeric"))
  }
  
  if (is.null(group)) {
    
    stop(paste("Can't calculate ANOVA without grouping data"))
    
  } else {
    group <- rlang::sym(group)
    column <- rlang::sym(column)
    
    all_dat <- data %>% dplyr::distinct(!!column, !!group, USUBJID)
    
    ttest <- summary(aov(all_dat[[paste(column)]] ~ all_dat[[paste(group)]], data=all_dat))[[1]] %>%
      tidyr::as_tibble()
    
    group_n <- length(unique(all_dat[[paste(group)]])) + 2
    
    anova_df <- data.frame(matrix(NA, ncol=group_n, nrow=4))
    
    anova_df[1,1] <- "p-value"
    anova_df[2,1] <- "Test Statistic"
    anova_df[3,1] <- "Mean Sum of Squares"
    anova_df[4,1] <- "Sum of Squares"
    anova_df[1, group_n] <- round(ttest$`Pr(>F)`[1], 3)
    anova_df[2, group_n] <- round(ttest$`F value`[1], 2)
    anova_df[3, group_n] <- round(ttest$`Mean Sq`[1], 2)
    anova_df[4, group_n] <- round(ttest$`Sum Sq`[1], 2)
    
    anova_df <- dplyr::mutate_all(anova_df, as.character) %>%
      dplyr::mutate_all(dplyr::coalesce, "")
    
    anova_df
  }
  
  
}


#' if BDS filter by paramcd and week
#' We need to calculate the difference in N for this
#' and report missing values from the mean if any
#' 
#' @importFrom rlang sym !!
#' @import dplyr
#' @return an ANOVA table of grouped variables
#' @rdname app_anova
#' @family tableGen Functions
#' 
#' @noRd

app_anova.BDS <- function(column, week, group = NULL, data) {
  
  column <- as.character(column)
  
  if (!column %in% data[["PARAMCD"]]) {
    stop(paste("Can't calculate ANOVA, ", column, " has no AVAL"))
  }
  
  if (week == "NONE") {
    stop(paste("Select week from dropdown to calculate ANOVA"))
  }
  
  
  if (is.null(group)) {
    stop(paste("Can't calculate ANOVA without grouping data"))
  } else {
    group <- sym(group)
    
    all_dat <- data %>%  filter(PARAMCD == column & AVISIT == week)
    
    if (length(unique(all_dat[[paste(group)]])) == 1) stop(glue::glue("Only one {group} in data selected, choose another week for ANOVA"))
    
    ttest <- summary(aov(all_dat$AVAL ~ all_dat[[paste(group)]], data=all_dat))[[1]] %>%
      tidyr::as_tibble()

    group_n <- length(unique(all_dat[[paste(group)]])) + 2
    
    anova_df <- data.frame(matrix(NA, ncol=group_n, nrow=4))
    anova_df[1,1] <- "p-value"
    anova_df[2,1] <- "Test Statistic"
    anova_df[3,1] <- "Mean Sum of Squares"
    anova_df[4,1] <- "Sum of Squares"
    anova_df[1, group_n] <- round(ttest$`Pr(>F)`[1], 3)
    anova_df[2, group_n] <- round(ttest$`F value`[1], 2)
    anova_df[3, group_n] <- round(ttest$`Mean Sq`[1], 2)
    anova_df[4, group_n] <- round(ttest$`Sum Sq`[1], 2)
    
    anova_df <- dplyr::mutate_all(anova_df, as.character) %>%
      dplyr::mutate_all(dplyr::coalesce, "")
    anova_df
  }
  
}

#' @return NULL
#' @rdname app_anova
#' @family tableGen Functions
#' 
#' @noRd

app_anova.OCCDS <- function(column, week = NULL, group = NULL, data) {
  rlang::abort(glue::glue(
    "Currently no method to perform ANOVA on OCCDS"
  ))
}





#' @return NULL
#' @rdname app_anova
#' @family tableGen Functions
#' 
#' @noRd

app_anova.custom <- function(column, week = NULL, group = NULL, data) {
  rlang::abort(glue::glue(
    "Can't calculate ANOVA, data is not classified as ADLB, BDS or OCCDS"
  ))
}
