# gi

Small program that generates .gitignore files. The templates are taken from
[toptal/gitignore](https://github.com/toptal/gitignore). They are all bundled
in the compiled binary, so there is no need to keep a folder with the templates, making it easier to install. 

## Building and installation
Make sure you have the [zig](https://ziglang.org) compiler [installed](https://ziglang.org/download/) on your machine. Then:
```
git clone --recurse-submodules https://github.com/dmbfm/gi.git
cd gi
zig build -Drelease-safe --prefix ~/.local
```

to install `gi` to `~/.local/bin` (or replace this with any other location on your PATH).


## Usage

```
Usage: gi [<template_name>...]
```

Just call `gi` followed by one ore more template names. 

```
$ gi zig > .gitignore
$ cat .gitignore
# Zig programming language

zig-cache/
zig-out/
build/
build-*/
docgen_tmp/
```

To list all the avilable templates, call `gi --list` or `gi -l`.

