#include "BPatch.h"
#include "BPatch_addressSpace.h"
#include "BPatch_binaryEdit.h"
#include "BPatch_module.h"
#include "BPatch_object.h"
#include "BPatch_function.h"

#include "Symtab.h"
#include "Region.h"
using namespace std;
using namespace Dyninst;
BPatch bpatch;

bool isPLTFunction(SymtabAPI::Symtab *symtab, Address addr) {
    std::vector<SymtabAPI::Symbol*> syms = symtab->findSymbolByOffset(addr);
    for (auto s : syms) {
        if (s->getMangledName().find("plt_call") != string::npos) return true;
    }
    return false;
}

int main(int argc, char ** argv) {
    BPatch_binaryEdit *binary = bpatch.openBinary(argv[1]);
    BPatch_image* image = binary->getImage();
    
    vector<BPatch_function*>* funcs2 = image->getProcedures(true);
    int count = 0;
    int total = 0;
    for (auto fit = funcs2->begin(); fit != funcs2->end(); ++fit) {
        BPatch_function* f = *fit; 
        Address addr = (Address)(f->getBaseAddr());
        BPatch_object* obj = f->getModule()->getObject();
        SymtabAPI::Symtab* symtab = SymtabAPI::convert(obj);
        SymtabAPI::Region* textReg;
        symtab->findRegion(textReg, ".text");
        if (textReg->getMemOffset() > addr || textReg->getMemOffset() + textReg->getMemSize() <= addr) continue;
        if (isPLTFunction(symtab, addr)) continue;
        total += 1;
        if (!f->isInstrumentable()) {
            printf("UNINSTRUMENTABLE at %p %s\n", (*fit)->getBaseAddr(), f->getName().c_str());
            count++;
        }   
    }   
    printf("uninstrumentable: %d, total: %d, %.2lf\%\n", count, total, count * 100.0 / total);
}
