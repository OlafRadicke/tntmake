Name: tntmake
Summary: A very simple to use build system for tntnet projects.
Version: 7
Group: develop
License: GPL
Release: 1
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-olaf
BuildArch: noarch
Source: %{name}-%{version}.tar.gz
Requires: python
Vendor: Olaf Radicke
Packager: Olaf Radicke briefkasten@olaf-radicke.de

%description
A very simple to use build system for tntnet projects.


%prep

%setup


%install
if [ ! -d $RPM_BUILD_ROOT/usr/lib/tntmake/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/lib/tntmake/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/*.py $RPM_BUILD_ROOT/usr/lib/tntmake/

if [ ! -d $RPM_BUILD_ROOT/usr/bin/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/bin/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/tntmake $RPM_BUILD_ROOT/usr/bin/tntmake


%files
/usr/lib/tntmake/
/usr/bin/tntmake

%changelog
* Thu Mar 20 2014 briefkasten@olaf-radicke - 7
 - Bugfixing version.
* Thu Mar 20 2014 briefkasten@olaf-radicke - 6
 - Get compiler warnings.
* Thu Mar 20 2014 briefkasten@olaf-radicke - 5
 - Bugfixing version.
* Thu Mar 20 2014 briefkasten@olaf-radicke - 4
 - Bugfixing version.
* Thu Mar 20 2014 briefkasten@olaf-radicke - 3
 - Reimplementation in python.
* Tue Jan 21 2014 briefkasten@olaf-radicke - 1
 - Init-Version.
