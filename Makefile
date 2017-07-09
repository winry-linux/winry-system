Version=17.1

PREFIX = /usr/local
SYSCONFDIR = /etc

SCRIPTS = \
	$(wildcard scripts/*.in)

SCRIPTS_BIN = \
        scripts/keyring-upgrade

HOOKS = \
	$(wildcard hooks/*.hook)

LIB = \
	$(wildcard lib/*.sh)

all: $(SCRIPTS_BIN)

edit = sed -e "s|@prefix@|${PREFIX}|"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@m4 -P $@.in | $(edit) >$@
	@chmod a-w "$@"
	@chmod +x "$@"

clean:
	rm -f $(SCRIPTS)

install:
	install -dm0755 $(DESTDIR)$(PREFIX)/share/libalpm/scripts
	install -m0755 ${SCRIPTS_BIN} $(DESTDIR)$(PREFIX)/share/libalpm/scripts

	install -dm0755 $(DESTDIR)$(PREFIX)/share/libalpm/hooks
	install -m0644 ${HOOKS} $(DESTDIR)$(PREFIX)/share/libalpm/hooks

	install -dm0755 $(DESTDIR)$(PREFIX)/lib/winry
	install -m0644 ${LIB} $(DESTDIR)$(PREFIX)/lib/winry

uninstall:
	for f in ${SCRIPTS}; do rm -f $(DESTDIR)$(PREFIX)/share/libalpm/scripts/$$f; done
	for f in ${HOOKS}; do rm -f $(DESTDIR)$(PREFIX)/share/libalpm/hooks/$$f; done
	for f in ${LIB}; do rm -f $(DESTDIR)$(PREFIX)/lib/winry/$$f; done

install: install

uninstall: uninstall


.PHONY: all clean install uninstall
