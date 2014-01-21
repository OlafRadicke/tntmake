VERSION=1
RPMNAME=tntmake

clean:
	rm -Rvf ./$(RPMNAME)-$(VERSION)/

dist-tar:
	tar -cvzf  $(RPMNAME)-$(VERSION).tar.gz $(RPMNAME)-$(VERSION)/

dirbuild:
	if [ ! -d ./$(RPMNAME)-$(VERSION)/bin/ ] ; then  mkdir -p ./$(RPMNAME)-$(VERSION)/bin/ ; fi;
	cp -R ./bin/*  ./$(RPMNAME)-$(VERSION)/bin/
	cp ./bin/tntmake.spec ./$(RPMNAME)-$(VERSION)/


dist-rpm: dirbuild dist-tar
	rm -Rvf  ~/rpmbuild/*
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	rpmbuild -vv -ta ./$(RPMNAME)-$(VERSION).tar.gz


install:
	if [ ! -d /usr/lib/tntmake/ ] ; then  mkdir -p /usr/lib/tntmake/ ; fi;
	install  bin/*.rb /usr/lib/tntmake/

	if [ ! -d /usr/lib/tntmake/resources/ ] ; then  mkdir -p /usr/lib/tntmake/resources/ ; fi;
	install  bin/resources/* /usr/lib/tntmake/resources/

	if [ ! -d /usr/bin/ ] ; then  mkdir -p /usr/bin/ ; fi;
	install  bin/tntmake /usr/bin/tntmake
