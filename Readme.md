
Important Notes
================

The report will generate data on the sample characteristics stratified by military service experience and a stacked bar chart to show hypoglycemic control by military service history.

## Generating Report

Please ensure that you have set your working directory to the project root directory prior to running the following commands:

- Generating automated report:
  - `make report/report.html`
  - This will pull and build `twilood/final` and generate a `report.html` in the `report/` folder for both windows and mac users
 
## Building Docker image locally and manually building report in container

1. Build docker image locally: \
1.1 `make docker_image` 
2. Run report with local docker image `final` \
2.2 Windows: `docker run -v "/$$(pwd)/report":/Final_Project/report final` \
2.3 Mac: `docker run -v "$$(pwd)/report":/Final_Project/report final` 
  
## Docker Hub

- Link to docker image is here: https://hub.docker.com/r/twilgood/final
- You can pull this image directly with `docker run twilgood/final`

## Manually syncing package versions

- Use `make install` to order to synchronize project packages

## Organizational Structure

Please see organizational structure, with notes below.

- **Nhanes_Final/**
  - report.Rmd
  - render_report.R
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
  - Makefile
  - Readme.md
  - .gitignore
  - .Rprofile
  - renv.lock
  - Dockerfile
  - **renv/**
  - **report/**
    - report.html (generated by make commands)
  