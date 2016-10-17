COLLECT=cs2500f16-jsonlab
TARGET=$(COLLECT).plt

$TARGET:
	mkdir $(COLLECT)
	cp -r info.rkt main.rkt scribblings $(COLLECT)
	raco link $(COLLECT)
	raco pack --replace --collect $(TARGET) $(COLLECT)
	raco link -r $(COLLECT)
	rm -rf $(COLLECT)
