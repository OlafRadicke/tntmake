VERSION=13
RPMNAME=customised_rpmrepos

clean: 
	rm -Rvf ./$(RPMNAME)-$(VERSION)/
	
dist-tar: clean
	mkdir ./$(RPMNAME)-$(VERSION)
	cp -Rv ./files/* ./$(RPMNAME)-$(VERSION)/
	tar -cvzf  ./$(RPMNAME)-$(VERSION).tar.gz ./$(RPMNAME)-$(VERSION)/
	ls -lah ./files/etc/yum.repos.d/*/*


build: 
	if [ ! -d ./files/etc/yum.repos.d/assemblyhall/ ] ; then  mkdir -p ./files/etc/yum.repos.d/assemblyhall/ ; fi;
	cat  ./files/etc/yum.repos.d/customised_rpms.repo.template |  sed  's/$${TARGET_SYSTEM}/assemblyhall/g' > ./files/etc/yum.repos.d/assemblyhall/customised_rpms.repo.1_step
	cat  ./files/etc/yum.repos.d/assemblyhall/customised_rpms.repo.1_step |  sed  's/$${SERVER-IP}/192.168.50.146/g' > ./files/etc/yum.repos.d/assemblyhall/customised_rpms.repo
	rm ./files/etc/yum.repos.d/assemblyhall/customised_rpms.repo.1_step

	if [ ! -d ./files/etc/yum.repos.d/intigration/ ] ; then  mkdir -p ./files/etc/yum.repos.d/intigration/ ; fi;
	cat  ./files/etc/yum.repos.d/customised_rpms.repo.template |  sed  's/$${TARGET_SYSTEM}/intigration/g' > ./files/etc/yum.repos.d/intigration/customised_rpms.repo.1_step
	cat  ./files/etc/yum.repos.d/intigration/customised_rpms.repo.1_step |  sed  's/$${SERVER-IP}/192.168.50.146/g' > ./files/etc/yum.repos.d/intigration/customised_rpms.repo
	rm ./files/etc/yum.repos.d/intigration/customised_rpms.repo.1_step

	if [ ! -d ./files/etc/yum.repos.d/hotfix/ ] ; then  mkdir -p ./files/etc/yum.repos.d/hotfix/ ; fi;
	cat  ./files/etc/yum.repos.d/customised_rpms.repo.template |  sed  's/$${TARGET_SYSTEM}/hotfix/g' > ./files/etc/yum.repos.d/hotfix/customised_rpms.repo.1_step
	cat  ./files/etc/yum.repos.d/hotfix/customised_rpms.repo.1_step |  sed  's/$${SERVER-IP}/192.168.50.146/g' > ./files/etc/yum.repos.d/hotfix/customised_rpms.repo
	rm ./files/etc/yum.repos.d/hotfix/customised_rpms.repo.1_step

	if [ ! -d ./files/etc/yum.repos.d/qa/ ] ; then  mkdir -p ./files/etc/yum.repos.d/qa/ ; fi;
	cat  ./files/etc/yum.repos.d/customised_rpms.repo.template |  sed  's/$${TARGET_SYSTEM}/qa/g' > ./files/etc/yum.repos.d/qa/customised_rpms.repo.1_step
	cat  ./files/etc/yum.repos.d/qa/customised_rpms.repo.1_step |  sed  's/$${SERVER-IP}/192.168.50.146/g' > ./files/etc/yum.repos.d/qa/customised_rpms.repo
	rm ./files/etc/yum.repos.d/qa/customised_rpms.repo.1_step

	if [ ! -d ./files/etc/yum.repos.d/qaa/ ] ; then  mkdir -p ./files/etc/yum.repos.d/qaa/ ; fi;
	cat  ./files/etc/yum.repos.d/customised_rpms.repo.template |  sed  's/$${TARGET_SYSTEM}/qaa/g' > ./files/etc/yum.repos.d/qaa/customised_rpms.repo.1_step
	cat  ./files/etc/yum.repos.d/qaa/customised_rpms.repo.1_step |  sed  's/$${SERVER-IP}/192.168.50.146/g' > ./files/etc/yum.repos.d/qaa/customised_rpms.repo
	rm ./files/etc/yum.repos.d/qaa/customised_rpms.repo.1_step

	if [ ! -d ./files/etc/yum.repos.d/vorschau/ ] ; then  mkdir -p ./files/etc/yum.repos.d/vorschau/ ; fi;
	cat  ./files/etc/yum.repos.d/customised_rpms.repo.template |  sed  's/$${TARGET_SYSTEM}/vorschau/g' > ./files/etc/yum.repos.d/vorschau/customised_rpms.repo.1_step
	cat  ./files/etc/yum.repos.d/vorschau/customised_rpms.repo.1_step |  sed  's/$${SERVER-IP}/vlxsv037.mmgmuc.de/g' > ./files/etc/yum.repos.d/vorschau/customised_rpms.repo
	rm ./files/etc/yum.repos.d/vorschau/customised_rpms.repo.1_step
	
	

dist-rpm: build dist-tar
	rm -Rvf  ~/rpmbuild/*
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	rpmbuild -vv -ta ./$(RPMNAME)-$(VERSION).tar.gz	
