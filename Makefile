VERSION=7
RPMNAME=tntmake

clean:
	rm -Rvf ./$(RPMNAME)-$(VERSION)/

dist-tar:
	tar -cvzf  ~/rpmbuild/SOURCES/$(RPMNAME)-$(VERSION).tar.gz $(RPMNAME)-$(VERSION)/

dirbuild:
	if [ ! -d ./$(RPMNAME)-$(VERSION)/bin/ ] ; then  mkdir -p ./$(RPMNAME)-$(VERSION)/bin/ ; fi;
	cp -R ./bin/*  ./$(RPMNAME)-$(VERSION)/bin/
	cp ./bin/tntmake.spec ./$(RPMNAME)-$(VERSION)/


dist-rpm: dirbuild dist-tar
#	rm -Rvf  ~/rpmbuild/*
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
#	rpmbuild -vv -ta ./$(RPMNAME)-$(VERSION).tar.gz
	rpmbuild -vv -bb ./bin/tntmake.spec


install:
	if [ ! -d /usr/lib/tntmake/ ] ; then  mkdir -p /usr/lib/tntmake/ ; fi;
	cp  bin/*.py /usr/lib/tntmake/

	if [ ! -d /usr/bin/ ] ; then  mkdir -p /usr/bin/ ; fi;
	cp  bin/tntmake /usr/bin/tntmake



uninstall:
	rm -Rvf /usr/lib/tntmake
	rm -Rvf /usr/bin/tntmake
