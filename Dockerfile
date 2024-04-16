FROM rocker/r-ubuntu as base

# Creating project directory
RUN mkdir Final_Project
WORKDIR /Final_Project

RUN mkdir -p renv
COPY renv.lock .
COPY .Rprofile .
COPY renv/activate.R renv
COPY renv/settings.json renv

RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE renv/.cache

RUN R -e "renv::restore()"

###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######

# Adding programs
FROM rocker/r-ubuntu
RUN apt-get update
RUN apt-get install -y pandoc

WORKDIR /Final_Project
COPY --from=base /Final_Project .

# Making organizational structure 
RUN mkdir Code
RUN mkdir Output
RUN mkdir Raw_Data
RUN mkdir Clean_Data
RUN mkdir report

# Copying Data over
COPY Raw_Data Raw_Data
COPY Code Code
COPY Makefile .
COPY report.Rmd .
COPY render_report.R .

# Making report and moving it to shared folder
CMD make && mv report.html report
