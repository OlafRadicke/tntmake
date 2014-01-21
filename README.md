# tntmake #

Zusammenfssung (folgt)

## Autor ##

Olaf Radicke <radicke@atix.de>

## Lizenz ##

GPLv3 oder höher.

## Installation ##

Es gibt ein Makefile im Basisverzeichnis mit dem ein RPM erstellt werden kann:

    make dist-rpm

Unterhalb von ~/rpmbuild/RPMS/noarch/ liegt dann eine Datei tntmake-*.noarch.rpm Diese wird dann installiert mit:

    rpm-i tntmake-*.noarch.rpm

Alternativ am RPM-System vorbei mit

    make install

## Doku ##

### Grundidee ###

