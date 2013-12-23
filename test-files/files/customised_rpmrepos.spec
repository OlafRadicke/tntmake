Name: customised_rpmrepos
Summary: Add a yum repository with customised rpms.
Version: 13
Group: Server-Applications
License: GPL
Release: 1
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-atix-%(%{__id_u} -n)
BuildArch: noarch
Source: %{name}-%{version}.tar.gz
Vendor: ATIX AG
Packager: ATIX AG technik@atix.de

%description
This RPM chooses the right yum repo dynamcly and automaticaly.
It is check the MAC address and the ip address.

%prep
%setup 

%build

%install

if [ ! -d $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/hotfix/ ] ; then  mkdir -p $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/hotfix/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/hotfix/customised_rpms.repo $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/hotfix/customised_rpms.repo

if [ ! -d $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/qa/ ] ; then  mkdir -p $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/qa/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/qa/customised_rpms.repo $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/qa/customised_rpms.repo

if [ ! -d $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/qaa/ ] ; then  mkdir -p $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/qaa/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/qaa/customised_rpms.repo $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/qaa/customised_rpms.repo

if [ ! -d $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/intigration/ ] ; then  mkdir -p $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/intigration/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/intigration/customised_rpms.repo $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/intigration/customised_rpms.repo

if [ ! -d $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/assemblyhall/ ] ; then  mkdir -p $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/assemblyhall/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/assemblyhall/customised_rpms.repo $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/assemblyhall/customised_rpms.repo

if [ ! -d $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/vorschau/ ] ; then  mkdir -p $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/vorschau/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/vorschau/customised_rpms.repo $RPM_BUILD_ROOT/var/lib/atix/etc/yum.repos.d/vorschau/customised_rpms.repo



%post
IPADDR=$(ifconfig eth0 | head -n 2 | tail -n 1 | cut -d: -f2 | cut -d" " -f 1)
MACADDR=$(ifconfig eth0 | head -n 1 | tail -n 1 | cut -dL -f2 | cut -d" " -f 5)

# hotfix check
if [ "192.168.50.145" = "${IPADDR}" ] && [ "00:50:56:91:59:34" = "${MACADDR}" ]  ; then YUMREPO="hotfix" ; fi ;
# qa check
if [ "192.168.50.143" = "${IPADDR}" ] && [ "00:50:56:91:59:2F" = "${MACADDR}" ]  ; then YUMREPO="qa" ; fi ;
# qaa check
if [ "192.168.50.144" = "${IPADDR}" ] && [ "00:50:56:91:59:33" = "${MACADDR}" ]  ; then YUMREPO="qaa" ; fi ;
# intigration check
if [ "192.168.50.148" = "${IPADDR}" ] && [ "00:50:56:91:66:12" = "${MACADDR}" ]  ; then YUMREPO="intigration" ; fi ;
# assemblyhall check
if [ "192.168.50.121" = "${IPADDR}" ] && [ "00:50:56:91:4F:20" = "${MACADDR}" ]  ; then YUMREPO="assemblyhall" ; fi ;
# vorschau check
if [ "10.10.12.145" = "${IPADDR}" ] && [ "00:50:56:91:18:9D" = "${MACADDR}" ]  ; then YUMREPO="vorschau" ; fi ;

if [ "${YUMREPO}" = "" ] ; then echo "Der Rechner konnte nicht zweifelsfrei identifiziert werden! IP: ${IPADDR} MAC: ${MACADDR}"; YUMREPO="unknown" ; fi ;
cp -af /var/lib/atix/etc/yum.repos.d/${YUMREPO}/customised_rpms.repo /etc/yum.repos.d/customised_rpms.repo 
yum clean all

%clean
rm -fr $RPM_BUILD_ROOT

%postun
rm -rf /etc/yum.repos.d/customised_rpms.repo

%files
%attr(644, root, root) /var/lib/atix/etc/yum.repos.d/hotfix/customised_rpms.repo
%attr(644, root, root) /var/lib/atix/etc/yum.repos.d/qa/customised_rpms.repo
%attr(644, root, root) /var/lib/atix/etc/yum.repos.d/qaa/customised_rpms.repo
%attr(644, root, root) /var/lib/atix/etc/yum.repos.d/intigration/customised_rpms.repo
%attr(644, root, root) /var/lib/atix/etc/yum.repos.d/assemblyhall/customised_rpms.repo
%attr(644, root, root) /var/lib/atix/etc/yum.repos.d/vorschau/customised_rpms.repo

%changelog
* Wed Dec 18 2013 olaf@atix.de - 13
 - Bugfix in YUM repo server path from vorschau.
* Wed Dec 18 2013 olaf@atix.de - 12
 - Change YUM repo server name from vorschau.
* Tue Dec 17 2013 olaf@atix.de - 11
 - Fix vorschau-server path.
* Tue Dec 17 2013 olaf@atix.de - 10
 - Add vorschau-server
* Mon Nov 25 2013 olaf@atix.de - 9
 - Edit description.
* Wed Nov 13 2013 olaf@atix.de - 8
 - Bugfix in MACADDR.
* Tue Nov 12 2013 olaf@atix.de - 7
 - Remove facter Requires.
* Tue Nov 12 2013 olaf@atix.de - 6
 - remove host name check.
* Wed Nov  6 2013 olaf@atix.de - 5
 - Bugfix 2 in MAC address form.
* Wed Nov  6 2013 olaf@atix.de - 4
 - Bugfix in MAC address form.
* Tue Oct  8 2013 olaf@atix.de - 3
 - RPM now chooses the right yum repo dynamcly and automaticaly.
* Mon Oct  7 2013 olaf@atix.de - 2
 - Add maintainer.
* Wed Oct 2 2013 olaf@atix.de - 1
 - Initial-Version.
