TOPTARGETS := all clean install

SUBDIRS := $(wildcard asm-*/.) hello vram noos

.PHONY: $(TOPTARGETS) $(SUBDIRS)

$(TOPTARGETS): $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

