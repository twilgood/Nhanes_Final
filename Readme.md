
Important Notes
================

## Generating Report

To generate the report, users should enter `make report.html` in the terminal and all other prerequisites should make with this statement.
The report will generate data on the sample characteristics stratified by military service experience and a stacked bar chart to show hypoglycemic control by military service history.

## Updating Project Package Libraries

- Ensure that your working directory is set in the project directory
- Use `make install` in order to activate and synchronize the project packages

## Organizational Structure

Please see organizational structure, with notes below.

- **Nhanes_Final/**
  - report.Rmd
  - render_report.R
  - sync_packages.R
  - **Code/**
    - 00_make_data_clean.R
    - 01_labels.R
    - 02_table1.R (makes table)
    - 03_make_barchart.R (makes figure)
  - **Output/**
    - table1.rds (generated from make)
    - barchart.rds (generated from make)
  - **Raw_data/**
    - DEMO_I.XPT
    - BPX_I.XPT
    - BMX_I.XPT
    - TRIGLY_I.XPT
    - GHB_I.XPT
    - DIQ_I.XPT
  - **Clean_Data/**
    - nhanes.rds (generated from make)
    - labeledNhanes.rds (generated from make and this is the data used for table1 and the bar chart)
  - Makefile
  - Readme.md
  - gitignore
  - .Rprofile
  - renv.lock
  - **renv/**
  