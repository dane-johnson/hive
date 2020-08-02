SRCDIR=src
OUTDIR=out
BUILDDIR=build
RESOURCEDIR=resources

SRCS=$(wildcard $(SRCDIR)/*.fnl)

.PHONY: all play
all: $(BUILDDIR)/hive.love
$(BUILDDIR)/hive.love: $(OUTDIR)/main.lua
	mkdir -p $(BUILDDIR)
	cp -r $(RESOURCEDIR) $(OUTDIR)/resources
	cd $(OUTDIR) && zip -r hive.love *
	mv $(OUTDIR)/hive.love $@

$(OUTDIR)/main.lua: $(SRCS)
	mkdir -p $(OUTDIR)
	./compile.lua > $@
