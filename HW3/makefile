ZIPFILE=HW3_JoshGillham.zip

zip: $(ZIPFILE)

$(ZIPFILE) : *.s *.APJ
ifeq ( $( wildcard $(ZIPFILE) ), ) 
	zip -fr $@ . -x *.zip -x *.zip -x *.O -x *.o -x HW3; 
else
	zip -r $@ . -x *.zip -x *.zip -x *.O -x *.o -x HW3; 
endif

clean:
	rm -f *.zip *.o *.O HW3
