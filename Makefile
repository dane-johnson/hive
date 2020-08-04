SRCDIR=src
OUTDIR=out
BUILDDIR=build
RESOURCEDIR=resources
LOVE_ANDROID=${HOME}/srcbuilds/love-android/

SRCS=$(wildcard $(SRCDIR)/*.fnl)

.PHONY: all play playmobile
all: $(BUILDDIR)/hive.love $(BUILDDIR)/hive.apk
play: $(BUILDDIR)/hive.love
	love $<
playmobile: $(BUILDDIR)/hive.apk
	adb install $<
	adb shell am start -n org.hive/org.love2d.android.GameActivity

$(BUILDDIR)/hive.apk: $(BUILDDIR)/hive.love AndroidManifest.xml
	mkdir -p $(LOVE_ANDROID)/love_decoded/assets
	cp $< $(LOVE_ANDROID)/love_decoded/assets/game.love
	cp AndroidManifest.xml $(LOVE_ANDROID)/love_decoded/
	cd $(LOVE_ANDROID) && \
	apktool b -o hive.apk love_decoded && \
	signapk.sh hive.apk
	mv $(LOVE_ANDROID)/signed_hive.apk $@

$(BUILDDIR)/hive.love: $(OUTDIR)/main.lua
	mkdir -p $(BUILDDIR)
	cp -r $(RESOURCEDIR) $(OUTDIR)/resources
	cd $(OUTDIR) && zip -r hive.love *
	mv $(OUTDIR)/hive.love $@

$(OUTDIR)/main.lua: $(SRCS) compile.lua
	mkdir -p $(OUTDIR)
	./compile.lua > $@
