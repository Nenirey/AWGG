# norootforbuild

%define awgg awgg

Name:		awgg-gtk
Summary:	Download Manager
Version:	0.5.0
Release:	1
URL:		https://sites.google.com/site/awggproject/
Source0:	%{awgg}-%{version}.orig.tar.gz
License:	GPL
Group:		Applications/File
BuildRequires:	fpc >= 2.6.0 fpc-src glib2-devel gtk2-devel lazarus >= 1.0.0
%if 0%{?mandriva_version}
BuildRequires:  libncurses-devel libdbus-1-devel libbzip2-devel
%endif
%if 0%{?fedora_version} || 0%{?rhel}
BuildRequires:  xorg-x11-devel ncurses-devel dbus-devel bzip2-devel
%endif
%if 0%{?suse_version} >= 1110
BuildRequires: ncurses-devel dbus-1-devel libbz2-devel
%endif 
Provides:	awgg
Conflicts:	awgg-qt
BuildRoot:	%{_tmppath}/%{awgg}-%{version}-build

%description
AWGG is a cross platform download manager that uses the most popular downloads engines (text based) like wget, aria2, cURL and axel, AWGG is most that an frontend, is multiprocess, portable and simple, includes a programer, clipboard monitor and can be integrated to firefox with flashgot plugin.

%prep
%setup -q -n %{awgg}-%{version}

%build
./build.sh beta gtk2

%install
install/linux/install.sh --install-prefix=%{buildroot}

%clean
[ %{buildroot} != "/" ] && ( rm -rf %{buildroot} )

%files
%defattr(-,root,root)
%{_libdir}/%{awgg}
%{_bindir}/%{awgg}
%{_datadir}/%{awgg}
%{_datadir}/applications/%{awgg}.desktop

%changelog
* Sat Nov 28 2015 - Reinier Romero Mir <nenirey@gmail.com>
- Initial package, version 0.5.0
