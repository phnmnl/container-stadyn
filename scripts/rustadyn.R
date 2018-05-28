#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(optparse))

options_list<-list(
  make_option(c("--input","-i"),help="Input for general information"),
  make_option(c("--files","-f"),help="Corrected files for metabolites (ouput of artimid)"),
  make_option(c("--label","-l"),help="Position of a record with labeling info"))

parser = OptionParser(option_list = options_list)
opt<-parse_args(parser,positional_arguments = FALSE)

if(!("input" %in% names(opt)) || !("files" %in% names(opt)) ) {
  print("no argument given!")
  print_help(parser)
  q(status = 1,save = "no")
}

library("simid")

isoform(isofi=opt$input, dor=opt$files,marca=as.integer(opt$label))

