Name: customised_rpmrepos
Summary: Add a yum repository with customised rpms.
Version: {{VERSION}}
Group: Server-Applications
License: GPL
Release: {{REALEASE}}
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-{{TARGET_SYSTEM}}-atix
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
if [ ! -d $RPM_BUILD_ROOT/etc/yum.repos.d/ ] ; then  mkdir -p $RPM_BUILD_ROOT/etc/yum.repos.d/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/etc/yum.repos.d/hotfix/customised_rpms.repo $RPM_BUILD_ROOT/etc/yum.repos.d/customised_rpms.repo

%post

%clean
rm -fr $RPM_BUILD_ROOT

%postun

%files
%attr(644, root, root) /etc/yum.repos.d/customised_rpms.repo

%changelog
* Fri Dec 27 2013 olaf@atix.de - 14
 - All target yum repos get now a own rpm.
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
