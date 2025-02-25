TOPTARGETS := all clean install

SUBDIRS := $(wildcard asm-*/.) hello vram

.PHONY: $(TOPTARGETS) $(SUBDIRS)

$(TOPTARGETS): $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

