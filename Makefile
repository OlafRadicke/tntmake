VERSION=1
RPMNAME=tntmake

clean:
	rm -Rvf ./$(RPMNAME)-$(VERSION)/

dist-tar:
	tar -cvzf  ./$(RPMNAME)-$(VERSION).tar.gz ./$(RPMNAME)-$(VERSION)/

dirbuild:
	if [ ! -d ./$(RPMNAME)-$(VERSION)/bin/ ] ; then  mkdir -p ./$(RPMNAME)-$(VERSION)/bin/ ; fi;
	cp ./bin/*.rb  ./$(RPMNAME)-$(VERSION)/bin/
	cp ./rpminjection ./$(RPMNAME)-$(VERSION)/bin/
	cp ./bin/rpminjection.spec ./$(RPMNAME)-$(VERSION)/


dist-rpm: dirbuild dist-tar
	rm -Rvf  ~/rpmbuild/*
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	rpmbuild -vv -ta ./$(RPMNAME)-$(VERSION).tar.gz


