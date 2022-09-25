.ONESHELL: # Applies to every targets in the file!
.PHONY : all docs

all: article draft

## make articles
article: build build/article.pdf
	rm -f article.tex

## make draft: make draft version and article
draft: build build/draft.pdf build/article.pdf
	pdftk build/draft.pdf \
		build/article.pdf \
		cat output build/draft_compare.pdf
	rm -f article.tex

## make build/*.pdf : generate the pdf files
build/%.pdf: %.tex build
	xelatex -output-directory="./build" $<
	bibtex ./build/$(basename $<)
	makeglossaries -d ./build/ $(basename $<)
	xelatex -output-directory="./build" $<
	xelatex -output-directory="./build" $<


draft.tex : build
	echo "\documentclass[journal,article,submit,moreauthors,draft]{settings/mdpi}" > draft.tex
	awk 'FNR>57' main.tex >> draft.tex

article.tex : build
	echo "\documentclass[journal,article,submit,moreauthors]{settings/mdpi}" > article.tex
	awk 'FNR>57' main.tex >> article.tex

build:
	mkdir build

## make clean: clean all files
clean:
	mv src/data src/_data
	# git ls-files --others | xargs gio trash
	git clean -fXd
	mv src/_data src/data

## make help : show this message.
help :
	@grep -h -E '^##' ${MAKEFILE_LIST} | sed -e 's/## //g' \
		| column -t -s ':'
