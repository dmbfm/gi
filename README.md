# gi

Small program that generates .gitignore files. The templates are taken from
[toptal/gitignore](https://github.com/toptal/gitignore). They are all bundled
in the compiled binary, so there is no need to keep a folder with the templates, making it easier to install. 

## Building and installation
Make sure you have the [zig](https://ziglang.org) compiler [installed](https://ziglang.org/download/) on your machine. Then:
```
git clone --recurse-submodules https://github.com/dmbfm/gi.git
cd gi
zig build -Drelease-safe
```

After that, copy or symlink the file `./zig-out/bin/gi` to a directory in your
PATH and you can just call `gi` and use it.

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

