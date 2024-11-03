QVM Toolchain Container
-----------------------
Simple access to q3vm compiler toolchain. 

```
$ docker build -t ktx-qvm .
$ cd /path/to/ktx
$ docker run --rm -v `pwd`:/src ktx-qvm
```