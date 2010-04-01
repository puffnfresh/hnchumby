SOURCE=hnchumby.as
OUTPUT=hnchumby.swf
HEADER=320:240:12

all:
	mtasc -swf $(OUTPUT) -main -header $(HEADER) $(SOURCE)
