all: BlockTrampoline FuncReloc Uninst Uninst-10.2.1

BlockTrampoline: BlockTrampoline.cpp
	g++ -g -o BlockTrampoline -O2 -std=c++11 BlockTrampoline.cpp \
		-I$(DYNINST_ROOT)/include \
		-L$(DYNINST_ROOT)/lib \
		-ldyninstAPI -lboost_system -ltbbmalloc -ltbbmalloc_proxy \
		-Wl,-rpath='$(DYNINST_ROOT)/lib'

FuncReloc: FuncReloc.cpp
	g++ -g -o FuncReloc -O2 -std=c++11 FuncReloc.cpp \
		-I$(DYNINST_RELEASE)/include \
		-L$(DYNINST_RELEASE)/lib \
		-ldyninstAPI -lboost_system -ltbbmalloc -ltbbmalloc_proxy \
		-Wl,-rpath='$(DYNINST_RELEASE)/lib'

Uninst: Uninst.cpp
	g++ -g -o Uninst -O2 -std=c++11 Uninst.cpp \
		-I$(DYNINST_ROOT)/include \
		-L$(DYNINST_ROOT)/lib \
		-ldyninstAPI -lsymtabAPI -lboost_system \
		-Wl,-rpath='$(DYNINST_ROOT)/lib'

Uninst-10.2.1: Uninst.cpp
	g++ -g -o Uninst-10.2.1 -O2 -std=c++11 Uninst.cpp \
		-I$(DYNINST_RELEASE)/include \
		-L$(DYNINST_RELEASE)/lib \
		-ldyninstAPI -lsymtabAPI -lboost_system \
		-Wl,-rpath='$(DYNINST_RELEASE)/lib'

clean:
	rm -f BlockTrampoline FuncReloc Uninst Uninst-10.2.1
