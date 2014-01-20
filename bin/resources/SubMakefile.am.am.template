AUTOMAKE_OPTIONS = subdir-objects
bin_PROGRAMS = peruschim_cpp
AM_CPPFLAGS = -I$(srcdir)

EXTRA_DIST = \
	Core/controller/LogoutController.tnt.cpp \
	Core/resources/favicon.ico \
	Core/resources/piwik.ecpp \
	Core/resources/peruschim.css \
	Core/resources/small_screens.css \
	Core/views/parts/user-session.ecpp.html \
	Core/views/parts/head.ecpp.html \
	Core/views/parts/style.ecpp \
	Core/views/parts/foot.ecpp.html

noinst_HEADERS = \
	Core/initcomponent.h \
	Core/controller/AlterLogInController.h \
	Core/manager/BibleManager.h \
	Core/manager/EditionManager.h \
	Core/manager/KeywordRegister.h \
	Core/manager/QuoteManager.h \
	Core/manager/QuoteRegister.h \
	Core/manager/TableManager.h \
	Core/manager/WebACL.h \
	Core/models/AccountData.h \
	Core/models/Config.h \
	Core/models/DatabaseProxy.h \
	Core/models/Edition.h \
	Core/models/KeywordData.h \
	Core/models/OString.h \
	Core/models/PeruschimException.h \
	Core/models/Quote.h \
	Core/models/UserSession.h \
	RouteReverse/initcomponent.h \
	RouteReverse/manager/Manager.h \
	RouteReverse/models/URLData.h \
	SessionForm/manager/Manager.h

ecppSources = \
	Core/views/parts/style.ecpp \
	Core/views/AccountRegisterView.ecpp \
	Core/views/access_denied.ecpp \
	Core/views/EditAccountView.ecpp \
	Core/views/EditEditionsView.ecpp \
	Core/views/EditOwnVersesView.ecpp \
	Core/views/EditQuoteView.ecpp \
	Core/views/ExportOwnVersesView.ecpp \
	Core/views/home.ecpp \
	Core/views/ImportOwnVersesView.ecpp \
	Core/views/KeywordDetailView.ecpp \
	Core/views/KeywordRegisterView.ecpp \
	Core/views/LogInView.ecpp \
	Core/views/logout.ecpp \
	Core/views/mainmenu.ecpp \
	Core/views/NewAccountView.ecpp \
	Core/views/NewQuoteView.ecpp \
	Core/views/portalaccount.ecpp \
	Core/views/portaladmin.ecpp \
	Core/views/portalquote.ecpp \
	Core/views/ResetOwnPasswordView.ecpp \
	Core/views/RSSfeedView.ecpp \
	Core/views/SwitchToHandheldVersionView.ecpp \
	Core/views/TrustAUserView.ecpp \
	SessionForm/views/NoAvailabeTokenView.ecpp

staticSources = \
	Core/resources/favicon.ico \
	Core/resources/peruschim.css \
	Core/resources/small_screens.css \
	Core/resources/feed-icon.png

peruschim_cpp_SOURCES = \
	peruschim_cpp.cpp \
	Core/controller/AccountRegisterController.cpp \
	Core/controller/AlterLogInController.cpp \
	Core/controller/EditAccountController.cpp \
	Core/controller/EditEditionsController.cpp \
	Core/controller/EditOwnVersesController.cpp \
	Core/controller/EditQuoteController.cpp \
	Core/controller/ExportOwnVersesController.cpp \
	Core/controller/ImportOwnVersesController.cpp \
	Core/controller/KeywordDetailController.cpp \
	Core/controller/KeywordRegisterController.cpp \
	Core/controller/NewAccountController.cpp \
	Core/controller/NewQuoteController.cpp \
	Core/controller/ResetOwnPasswordController.cpp \
	Core/controller/SwitchToHandheldVersionController.cpp \
	Core/controller/TrustAUserController.cpp \
	Core/manager/BibleManager.cpp \
	Core/manager/EditionManager.cpp \
	Core/manager/KeywordRegister.cpp \
	Core/manager/QuoteManager.cpp \
	Core/manager/QuoteRegister.cpp \
	Core/manager/RSSfeedManager.cpp \
	Core/manager/TableManager.cpp \
	Core/manager/WebACL.cpp \
	Core/models/AccountData.cpp \
	Core/models/Config.cpp \
	Core/models/DatabaseProxy.cpp \
	Core/models/KeywordData.cpp \
	Core/models/OString.cpp \
	Core/models/Quote.cpp \
	Core/models/UserSession.cpp \
	RouteReverse/manager/Manager.cpp \
	SessionForm/controller/Controller.cpp \
	SessionForm/manager/Manager.cpp \
	$(ecppSources)

nodist_peruschim_cpp_SOURCES = \
	resources.cpp

peruschim_cpp_LDFLAGS = -lcxxtools -ltntnet -ltntdb

CLEANFILES = $(ecppSources:.ecpp=.cpp) $(ecppSources:.ecpp=.deps) resources.cpp

#
# Rules for tntnet applications
#
resources.cpp: $(staticSources) Makefile.am
	$(ECPPC) -bb -z -n resources -p -o resources.cpp -I $(srcdir) $(staticSources)

SUFFIXES=.ecpp .ico .cpp

.ecpp.cpp:
	$(ECPPC) -I $(top_srcdir)/src -o $@ $<
.ecpp.deps:
	$(ECPPC) -M -n $* -I $(srcdir) -I $(srcdir)/include $< | $(SED) '1s/\(.*\).cpp:/\1.cpp \1.deps:/' > $@
.ico.cpp:
	$(ECPPC) -b -m image/x-icon -o $@ $<

-include $(ecppSources:.ecpp=.deps)
