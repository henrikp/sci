# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 git-r3

DESCRIPTION="Image processing utilities for Astropy"
HOMEPAGE="https://github.com/astropy/imageutils"
EGIT_REPO_URI="https://github.com/astropy/${PN}.git"

LICENSE="BSD"
SLOT="0"
IUSE="doc"

RDEPEND="
	>=dev-python/astropy-0.4[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( README.rst )

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e '/import ah_bootstrap/d' -i setup.py || die "Removing ah_bootstrap failed"
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}" || die
	"${EPYTHON}" -c "import ${PN}, sys;r = ${PN}.test(verbose=True);sys.exit(r)" \
		|| die "tests fail with ${EPYTHON}"
}

python_compile_all() {
	if use doc; then
		python_export_best
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
