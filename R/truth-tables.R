

#' High-level truth-table generator, returns a dataframe with all variables in
#' an expression and a logical `passes` column that is the result of calling the
#' expression on the dataframe
#'
#' @param x an expression like those in `checklist$checker`
#' @param limit maximum number of example rows to return per truth outcome (T or F)
#' @param extra_rows optional dataframe to which the expression will be applied,
#' supplementing rows of returned truth table
#' @importFrom dplyr bind_rows group_by ungroup slice_head
#' @export
get_truth_table <- function(x, limit = Inf, extra_rows = NULL) {

  data("aux_info", package = "utValidateR", envir = environment())
  aux_env <- new_environment(data = aux_info, parent = caller_env())

  vecs_list <- get_tt_vecs(x, aux_info) # named list of vectors for expand.grid()

  vecs_toexpand <- combine_same_vars(vecs_list)

  ttdf <- expand.grid(vecs_toexpand, stringsAsFactors = FALSE)

  if (!is.null(extra_rows)) {
    ttdf <- bind_rows(extra_rows[names(ttdf)], ttdf)
  }

  ttdf$passes <- eval_tidy(x, data = ttdf, env = aux_env)

  out <- ttdf %>%
    group_by(passes) %>%
    slice_head(n = limit) %>%
    ungroup()

  out
}

#' Utility function to combine same-name elements of veclist to produce a list
#' with unique names and unique values per element
#' @param veclist a list of vectors
combine_same_vars <- function(veclist) {
  out <- unique(names(veclist)) %>%
    setNames(., .) %>%
    map(~unique(unlist(veclist[names(veclist) == .], use.names = FALSE)))
  out
}


#' Should return a named list of vectors, which can be supplied to `expand.grid()`
#'
#' Recursive along sub-expressions of x, calls `get_tt_vecs_basecase` in base-case
#'
#' @param x an expression like those in `checklist$checker`
#' @param aux_info a list of auxiliary information, as used in `do_checks()`
get_tt_vecs <- function(x, aux_info) {
  if (is_base_expression(x))
    return(get_tt_vecs_basecase(x, aux_info)) # Named list of values

  x_list <- as.list(x)
  x_args <- x_list[-1] # First element is function call, remainder are args

  nested_tt_vec_list <- lapply(x_args, get_tt_vecs) # Each result of `get_tt_vecs()` is a list

  out <- unlist(nested_tt_vec_list, recursive = FALSE) # Now just a list of vectors
  out
}

#' Function for checking whether to treat as base-case or continue recursion
#' @param x an expression
is_base_expression <- function(x) {
  x_list <- as.list(x)
  length(as.list(x_list[[2]])) == 1
}

#' Returns a list of example values for creating truth table
#'
#' Might make more sense to code this directly into if() clause in get_tt_vecs()
#'
#' @param base_expr A non-nested expression
#' @param aux_info a list with auxiliary information to be used by the expression
get_tt_vecs_basecase <- function(base_expr, aux_info) {
  funname <- deparse(base_expr[[1]]) # function name as character
  arglist <- as.list(base_expr)[-1] # function arguments as list

  out <- lookup_tt_vecs(funname, args = arglist, aux_info = aux_info)
  out
}

#' Returns a named list containing vector of test values
#'
#' @param fun character function name
#' @param args Named list of arguments
#' @param aux_info a list with auxiliary information to be used by the expression
#' @importFrom rlang current_env
lookup_tt_vecs <- function(fun, args, aux_info) {

  if (fun == "is.na") {
    vec <- c(NA, 3)
  } else if (fun == "is_missing_chr") {
    vec <- c("a", "", NA_character_)
  } else if (fun == "%in%") {
    vec <- unique(c("bad_value", "", NA_character_, eval(args[[2]])))
  } else if (fun == "is_valid_ssn") {
    vec <- c("333-33-3333", "123456789", "123", "", NA_character_)
    # } else if (fun == "==") {
    #   vec <- c(eval(args[[2]]), "another_value")
  } else if (fun == "is_valid_previous_id") {
    vec <- c("a", "", NA_character_, "0", "000", "0123", "1230")
  } else if (fun == "is_alpha_chr") {
    vec <- c("abc", "123", "abc123", "", NA_character_)
  } else if (fun == "is_valid_zip_code") {
    vec <- c("54534", "54534-9999", "00000", "abcde", "123456", "", NA_character_)
  } else if (fun == "is_utah_county") {
    vec <- c("12", "22", "ab", "97", "99", "123")
  } else if (fun == "is_valid_values") {
    auxenv <- new_environment(aux_info, parent = current_env())
    vec <- unique(c("bad_value", "", NA, eval(args[[2]], envir = auxenv)))
  } else {
    stop("No truth table  is available for ", fun)
  }
  out <- setNames(list(vec), deparse(args[[1]]))
}
