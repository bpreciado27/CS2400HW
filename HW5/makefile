ZIPFILE=HW5_JoshGillham.zip
PARAMS=-x *.zip -x *.O -x *.o -x HW5 -x *.png

zip: $(ZIPFILE)

$(ZIPFILE) : *.s *.APJ
ifeq ( $( wildcard $(ZIPFILE) ), ) 
	zip -fr $@ . $(PARAMS) 
else
	zip -r $@ . $(PARAMS)
endif

clean:
	rm -f *.zip *.o *.O HW3
