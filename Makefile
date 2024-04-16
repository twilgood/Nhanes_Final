# Generate Report
report.html: render_report.R report.Rmd barchart.rds table1.rds
	Rscript render_report.R
	
# Sync Packages
.PHONY: install
install: 
	R -e "renv::restore()"

# Make Barchart:
barchart.rds: Code/03_make_barchart.R labeledNhanes.rds
	Rscript Code/03_make_barchart.R

# Make Table1
table1.rds: Code/02_table1.R labeledNhanes.rds
	Rscript Code/02_table1.R

# Generating Labeled Data
labeledNhanes.rds: Code/01_labels.R nhanes.rds
	Rscript Code/01_labels.R

# Generating Clean Data
nhanes.rds: Code/00_make_data_clean.R 
	Rscript Code/00_make_data_clean.R

# Make repository clean
.PHONY: clean
clean:
	rm -f Output/*.rds && rm -f report/report.html && rm -f Clean_Data/*.rds && rm -f docker_image
	
# Docker rules
PROJECTFILES = report.rmd render_report.R Code/00_make_data_clean.R Code/01_labels.R Code/02_table1.R Code/03_make_barchart.R Makefile
RENVFILES = renv.lock renv/activate.R renv/settings.json

# Building an image
docker_image: $(PROJECTFILES) $(RENVFILES) Dockerfile
	docker build -t final .
	touch $@

# Running a container
report/report.html:
	docker run -v "/$$(pwd)/report":/Final_Project/report twilgood/final || docker run -v "$$(pwd)/report:/Final_Project/report" twilgood/final
