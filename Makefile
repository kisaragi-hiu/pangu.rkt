# Based on Greg Hendershott's Makefiles:
# https://www.greghendershott.com/2017/04/racket-makefiles.html

PACKAGE-NAME=pangu
DEPS-FLAGS=--check-pkg-deps --unused-pkg-deps

.PHONY: all install remove setup clean check-deps test

all: setup

install:
	raco pkg install --name $(PACKAGE-NAME) --deps search-auto

remove:
	raco pkg remove $(PACKAGE-NAME)

setup:
	raco setup --tidy $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

clean:
	raco setup --fast-clean --pkgs $(PACKAGE-NAME)

check-deps:
	raco setup --no-docs $(DEPS-FLAGS) $(PACKAGE-NAME)

test:
	raco test -x -p $(PACKAGE-NAME)
