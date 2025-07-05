VC := v
PREFIX := /usr/local/bin

.PHONY: all build install

all: build/objbinpack

build: 
	mkdir build

build/objbinpack: src/main.v src/maker_c.v src/maker_cpp.v src/strutil.v build
	$(VC) . -prod -o build/objbinpack

install:
	install build/objbinpack $(PREFIX)/objbinpack