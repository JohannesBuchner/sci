# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="A free C++ CAS (Computer Algebra System) library and its interfaces"
HOMEPAGE="http://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="ftp://ftp-fourier.ujf-grenoble.fr/xcas/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples fltk"

RDEPEND=">=dev-libs/gmp-3
		>=sys-libs/readline-4.2
		fltk? ( >=x11-libs/fltk-1.1.9 )
		dev-libs/mpfr
		sci-libs/gsl
		>=sci-mathematics/pari-2.3
		>=dev-libs/ntl-5.2"

src_prepare(){
	sed -e "s:\$(prefix)/share:\$(DESTDIR)\$(prefix)/share:g" \
		-e "s:config.h \$(includedir)/giac:config.h \$(DESTDIR)\$(includedir)/giac:g" \
		-e "s:\$(DESTDIR)\$(DESTDIR):\$(DESTDIR):g"	\
		-i `find -name Makefile\*`
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	mv ${D}/usr/bin/{aide,giachelp}
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TROUBLES
	if use !doc; then
		rm -R ${D}/usr/share/doc/giac ${D}/usr/share/giac/doc/
	else
		for LANG in el en es fr pt; do
			if echo ${LINGUAS} | grep -v $LANG &> /dev/null; then
				rm -R ${D}/usr/share/giac/doc/$LANG
			fi
		done
	fi
	if use !examples; then
		rm -R ${D}/usr/share/giac/examples
	fi
}

