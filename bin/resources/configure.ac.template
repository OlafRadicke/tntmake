AC_INIT(peruschim_cpp, 1, [Olaf Radicke <briefkasten@olaf-radicke.de>])
AM_INIT_AUTOMAKE
AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_HEADERS([src/config.h])
AC_CONFIG_SRCDIR([src/peruschim_cpp.cpp])

AC_PROG_CXX
AC_PROG_LIBTOOL
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET

AX_CHECK_COMPILE_FLAG([-Wall], [CPPFLAGS="$CPPFLAGS -Wall"])
AX_CHECK_COMPILE_FLAG([-pedantic], [CPPFLAGS="$CPPFLAGS -pedantic"])

AC_LANG(C++)
AC_CHECK_HEADER([cxxtools/arg.h], , AC_MSG_ERROR([cxxtools headers not found]))
AC_CHECK_HEADER([tnt/tntnet.h], , AC_MSG_ERROR([tntnet headers not found]))
AC_CHECK_HEADER([tntdb/connect.h], , AC_MSG_ERROR([tntdb headers not found]))
AC_CHECK_PROGS(ECPPC, [ecppc])

AC_CONFIG_FILES([Makefile
                 src/Makefile
                 utest/Makefile])

AC_OUTPUT
