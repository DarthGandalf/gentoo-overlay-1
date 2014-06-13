# Copyright 1999-2014 Gentoo Foundation
# Copyright 2014 Thomas Schneider <thosch97@gmail.com>
# Distributed under the terms of the MIT License

EAPI=5

DESCRIPTION="Rod Smith's fork of rEFIt UEFI Boot Manager"
HOMEPAGE="http://www.rodsbooks.com/refind/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${PN}-src-${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64" # Be sure what you do when expanding this!

DEPEND=">=sys-boot/gnu-efi-3.0u"

inherit toolchain-funcs

# Many things borrowed from Arch’s PKGBUILD
# See https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/refind-efi

src_prepare() {
	sed -i 's|^ThisDir=.*|ThisDir="/usr/share/refind/"|g' install.sh
	sed -i 's|^RefindDir=.*|RefindDir="/usr/share/refind/"|g' install.sh
	sed -i 's|^ThisScript=.*|ThisScript="/usr/sbin/refind-install"|g' install.sh

	sed -i 's|../Styles/styles.css|styles.css|' docs/refind/*.html
}

src_compile() {
	emake -j1 gnuefi fs_gnuefi ARCH=x86_64
}

src_install() {
	local arch
	use amd64 && arch="x64"

	newsbin install.sh refind-install
	newsbin mkrlconf.sh refind-mkrlconf
	newsbin mvrefind.sh refind-mvrefind
	newbin fonts/mkfont.sh refind-mkfont

	dodoc *.txt
	dodoc docs/refind/*

	insinto /usr/share/${PN}
	doins refind/refind_${arch}.efi
	doins -r drivers_${arch}
	doins -r icons
	doins refind.conf-sample

	insinto /usr/share/${PN}/tools_${arch}
	doins gptsync/gptsync_${arch}.efi

	insinto /usr/share/${PN}/fonts
	doins fonts/*.png

	insinto /usr/share/${PN}/images
	doins images/*.{png,bmp}
}
