Name: tntmake
Summary: Create a autotool based build system for tntnet projects.
Version: 1
Group: develop
License: GPL
Release: 1
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-olaf
BuildArch: noarch
Source: %{name}-%{version}.tar.gz
Requires: tntnet
Vendor: Olaf Radicke
Packager: Olaf Radicke briefkasten@olaf-radicke.de

%description
Create a autotool based build system for tntnet projects.


%prep

%setup


%install
if [ ! -d $RPM_BUILD_ROOT/usr/lib/tntmake/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/lib/tntmake/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/*.rb $RPM_BUILD_ROOT/usr/lib/tntmake/

if [ ! -d $RPM_BUILD_ROOT/usr/lib/tntmake/resources/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/lib/tntmake/resources/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/resources/* $RPM_BUILD_ROOT/usr/lib/tntmake/resources/

if [ ! -d $RPM_BUILD_ROOT/usr/bin/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/bin/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/tntmake $RPM_BUILD_ROOT/usr/bin/tntmake


%files
/usr/lib/tntmake/
/usr/bin/tntmake

%changelog
* Tue Jan 21 2014 briefkasten@olaf-radicke - 1
 - Init-Version.
