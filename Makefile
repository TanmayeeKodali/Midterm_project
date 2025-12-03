.PHONY: install report clean

install:
	Rscript -e "renv::restore()"

report:
	Rscript code/06_render_report.R

clean:
	rm -f output/tables/*.rds
	rm -f output/tables/*.csv
	rm -f output/figures/*.png
	rm -f report.html