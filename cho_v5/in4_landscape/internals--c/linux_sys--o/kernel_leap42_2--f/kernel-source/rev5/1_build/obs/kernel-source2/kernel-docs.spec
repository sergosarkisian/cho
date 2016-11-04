#
# spec file for package kernel-docs
#
# Copyright (c) 2016 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


%define patchversion 4.4.20
%define variant %{nil}

%include %_sourcedir/kernel-spec-macros

%define use_fop	1

Name:           kernel-docs
Summary:        Kernel Documentation (man pages)
License:        GPL-2.0
Group:          Documentation/Man
Version:        4.4.20
%if 0%{?is_kotd}
Release:        <RELEASE>.g2e38f57
%else
Release:        0
%endif
BuildRequires:  kernel-source%variant
BuildRequires:  xmlto
%if %use_fop
BuildRequires:  fop
%else
BuildRequires:  docbook-toys
BuildRequires:  docbook-utils
BuildRequires:  texlive-courier
BuildRequires:  texlive-dvips
BuildRequires:  texlive-ec
BuildRequires:  texlive-helvetic
BuildRequires:  texlive-jadetex
BuildRequires:  texlive-times
%endif
Url:            http://www.kernel.org/
Provides:       %name = %version-%source_rel
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source:         kernel-spec-macros

%description
These are the man pages (section 9) built from the current kernel sources.

%source_timestamp

%package pdf
Summary:        Kernel Documentation (PDF)
License:        GPL-2.0
Group:          Documentation/Other

%description pdf
These are PDF documents built from the current kernel sources.

%source_timestamp

%package html
Summary:        Kernel Documentation (HTML)
License:        GPL-2.0
Group:          Documentation/HTML

%description html
These are HTML documents built from the current kernel sources.

%source_timestamp

%prep
%if !%use_fop
cp -av /etc/texmf/web2c/texmf.cnf .
cat << EOF >> texmf.cnf
main_memory.pdfjadetex = 5000000
hash_extra.pdfjadetex = 140000
max_strings.pdfjadetex = 240000
save_size.pdfjadetex = 20000
EOF
%endif
%setup -T -c

%build
%if !%use_fop
# use texmf.cnf from local source
export TEXMFCNF=$RPM_BUILD_DIR
%endif
export LANG=en_US
mkdir -p man
make -C /usr/src/linux%variant O=$PWD/man mandocs %{?jobs:-j%jobs}
mkdir -p html
make -C /usr/src/linux%variant O=$PWD/html htmldocs %{?jobs:-j%jobs}
mkdir -p pdf
make \
%if %use_fop
    XMLTOFLAGS="-m /usr/src/linux%{variant}/Documentation/DocBook/stylesheet.xsl --skip-validation --with-fop" \
%endif
  -C /usr/src/linux%variant O=$PWD/pdf pdfdocs %{?jobs:-j%jobs}

%install
install -d $RPM_BUILD_ROOT/%{_mandir}/man9
# filter out obscure device drivers - they clutter up the rpm and don't add any real value
find man/Documentation/DocBook/ -name '*.9.gz' | 
grep -E -v 'man/(sis[69]|rio|fsl|struct_rio|RIO|mpc85|set_rx_mode|mdio_(read|write)|mii_ioctl|mca_|z8530|nand|sppp|piix|(read|write)_zs)' |  
while read i ; do
	cp $i $RPM_BUILD_ROOT/%{_mandir}/man9
done
if [ -d man/Documentation/kdb ] ; then
    for i in man/Documentation/kdb/*.m* ; do
	k=`basename $i`
	k=${k/man/9}
	k=${k/mm/9}
	cp $i $RPM_BUILD_ROOT/%{_mandir}/man9/$k
    done
fi

ln -s %{_mandir}/man9/request_threaded_irq.9.gz $RPM_BUILD_ROOT%{_mandir}/man9/request_irq.9.gz

install -d $RPM_BUILD_ROOT%{_datadir}/doc/kernel/pdf
cp -a pdf/Documentation/DocBook/*.pdf $RPM_BUILD_ROOT%{_datadir}/doc/kernel/pdf || true

install -d $RPM_BUILD_ROOT%{_datadir}/doc/kernel/html
cp -a html/Documentation/DocBook/* $RPM_BUILD_ROOT%{_datadir}/doc/kernel/html || true
rm -f $RPM_BUILD_ROOT%{_datadir}/doc/kernel/html/*.xml
rm -f $RPM_BUILD_ROOT%{_datadir}/doc/kernel/html/*.{gif,png}
rm -f $RPM_BUILD_ROOT%{_datadir}/doc/kernel/html/*/*.proc

cp -a /usr/src/linux%variant/{COPYING,CREDITS,MAINTAINERS,README,REPORTING-BUGS} .

%files
%defattr(-,root,root)
%doc COPYING CREDITS MAINTAINERS README REPORTING-BUGS
%{_mandir}/man9/*

%files pdf
%defattr(-,root,root)
%dir %{_datadir}/doc/kernel
%docdir %{_datadir}/doc/kernel/pdf
%{_datadir}/doc/kernel/pdf

%files html
%defattr(-,root,root)
%dir %{_datadir}/doc/kernel
%docdir %{_datadir}/doc/kernel/html
%{_datadir}/doc/kernel/html

%changelog
