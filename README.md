# tntmake #

Tntmake ist ein Proof of concept. Tntmake hat zwei Ziele:

 * Es dem Benutzer so einfach wie möglich zu machen sein Tntnet-Projekt zu übersetzen.
 * Die Build-Konfiguration muss einfach zu parsen sein, da mit Tntmake für andere Projekte (Frontends) als Backend dienen kann.

Mehr Details zu zu Tntnet findet sich auf der Seite [http://tntnet.org](http://tntnet.org)
Der Source Code zu diesem Projekt findet sich unter [https://github.com/OlafRadicke/tntmake](https://github.com/OlafRadicke/tntmake)

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

## Todo ##

* Einbeziehung der Header-Dateien
* Code aufräumen
* Reimplementierung in C++, Java oder was auch immer...

## Doku ##

### Grundidee ###

Tntmake ist inspiriert von qmake. Das Qt-Projekt hat eine ähnliche
Herausforderung für den Benutzer wie Tntnet. In beiden Fällen wird ein
Precompiler benutzt. Das was der Meta Object Compiler (moc) ist, ist in Tntnet
der ecppc.

Tntmake versucht die Verwendung des ecppc zu verbergen und mit einer
JSON-Configuration die Steuerung der Build-Prozess möglichst einfach zu halten. Sowohl für
Menschen als auch für Tools die auf Tntmake aufsetzen.

Tntmake ist weder besonders mächtig, noch besonders portabel. Es
soll einfach nur möglichst einfach zu bedienen sein. Zielgruppe sind
Umsteiger die von Skriptsprachen wie PHP, RubyOnRails, Perl oder
auch aus der Java-Welt kommen.

Wer mehr braucht oder will muss sich in Make, Autotools, cmake oder
qmake einarbeiten.

### Kommandozeilen-Optionen ###

Die Bedienung ist recht überschaubar. Der Befehl "tntmake" hat die folgenden
Parameter:

    --example oder -e

Generiert eine einfache Beispiel Konfiguration die in der Standardausgabe
ausgegeben wird.

    --scan oder -s

Ist eine experimentelle Funktion. Das Tool durchsucht alle Unterverzeichnisse
und versucht zu erraten welche Dateien zum Projekt gehören um sie in die
Konfiguration aufzunehmen. Eine Überprüfung auf Plausibilität ist hier angeraten.
Die Ausgabe kann in eine Datei umgelenkt werden, die man dann noch
nach bearbeitet:

    tntmake -s > ./Makefile.tnt

Nach diese Datei wird Tntmake suchen, wenn er mit mit dem übersetzen des Projektes
beginnt. Die Konfiguration muss "" heißen und im selben Verzeichnis liegen von
dem aus Tntmake gestartet wird. Befehl zum kompilieren lautet:

    tntmake -b



