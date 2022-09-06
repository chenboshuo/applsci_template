.ONESHELL: # Applies to every targets in the file!
.PHONY : all docs

all: article

## make articles
article: build
	pdflatex -output-directory="./build" main.tex
	bibtex ./build/main
	pdflatex -output-directory="./build" main.tex
	pdflatex -output-directory="./build" main.tex

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
