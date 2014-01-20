Name: tntmake
Summary: Create a autotool based build system for tntnet projects.
Version: 1
Group: develop
License: GPL
Release: 1
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-olaf
BuildArch: noarch
Source: %{name}-%{version}.tar.gz
Vendor: Olaf Radicke
Packager: Olaf Radicke briefkasten@olaf-radicke.de

%description
Create a autotool based build system for tntnet projects.


%prep
%setup

%build

%install
if [ ! -d $RPM_BUILD_ROOT/usr/lib/rpminjection/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/lib/rpminjection/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/*.rb $RPM_BUILD_ROOT/usr/lib/rpminjection/

if [ ! -d $RPM_BUILD_ROOT/usr/bin/ ] ; then  mkdir -p $RPM_BUILD_ROOT/usr/bin/ ; fi;
install  $RPM_BUILD_DIR/%{name}-%{version}/bin/rpminjection $RPM_BUILD_ROOT/usr/bin/

%post

%clean
rm -fr $RPM_BUILD_ROOT

%postun

%files
%attr(777, root, root) /usr/lib/rpminjection/
%attr(777, root, root) /usr/bin/rpminjection

%changelog
* Fri Dec 27 2013 olaf@atix.de - 1
 - Init-Version.
