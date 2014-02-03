# tntmake #

Tntmake ist ein Tool, das eine einfache Möglichkeit bieten soll für
Tntnet-Projekte Makefiles zu erstellen. Tntmake dient hier bei als Frontend
für Autotools. Und Tntmake soll wiederum als Backend für ein Wizard dienen,
mit dem auf einfache weise Tntnet-Projekte erstellt und gepflegt werden können
soll.

## Autor ##

Olaf Radicke <radicke@atix.de>

## Lizenz ##

GPLv3 oder höher.

## Installation ##

Es gibt ein Makefile im Basisverzeichnis mit dem ein RPM erstellt werden kann:

    make dist-rpm

Unterhalb von ~/rpmbuild/RPMS/noarch/ liegt dann eine Datei tntmake-*.noarch.rpm
Diese wird dann installiert mit:

    rpm -i tntmake-*.noarch.rpm

Alternativ kann man tntmake auch am RPM-System vorbei installieren mit

    make install

## Doku ##

### Grundidee ###

Tntmake ist inspiriert von qmake. Das Qt-Projekt hat eine ähnliche
Herausforderung für den Benutzer wie Tntnet. In beiden Fällen wird ein
Precompiler benutzt. Das was der Meta Object Compiler (moc) ist, ist in Tntnet
der ecppc.

Tntmake versucht die Verwendung des ecppc zu verbergen und mit einer
JSON-Configuration die Steuerung möglichst einfach zu halten. Sowohl für
Menschen als auch für Tools die auf Tntmake aufsetzen.

Tntmake ist weder besonders mächtig, noch besonders portabel. Es
soll einfach nur möglichst einfach zu bedienen sein. Zielgruppe sind
Umsteiger die von Skriptsprachen wie PHP, RubyOnRails, Perl oder
auch aus der Java-Welt kommen.

Wer mehr braucht oder will muss sih dan in Make, Autotools, cmake oder
qmake einarbeiten.

### Kommandozeilen-Optionen ###

Die Bedienung ist recht überschaubar. Der Befehl "tntmake" hat die folgenden
Parameter:

    --example oder -e

Generiert eine einfache Beispiel Konfiguration die in der Standardausgabe
ausgegeben wird.

    --scan oder -s

Ist eine experimentelle Funktion. Das Tool durchsucht alle Unterverzeichnisse
und versucht zu erraten welche Dateien um Projekt gehören um sie in die
Konfiguration aufzunehmen. Eine Überprüfung auf Plausibilität ist hier angeraten.
Die Ausgabe kann in eine Datei umgelenkt werden, die man dann noch
nach bearbeitet:

    tntmake -s > ./Makefile.tnt

Diese Datei wird dann als Parameter wiederum mit tntmake aufgerufen um damit
die Auto-Make-Files zu generieren:

    tntmake ./Makefile.tnt




