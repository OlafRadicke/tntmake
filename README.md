# rpminjection #

Tool zum manitulieren von eigenen RPMs. Ist für den Kunden mmg gedacht. Soll aber universell einsetzbar sein.

## Autor ##

Olaf Radicke <radicke@atix.de>

## Lizenz ##

GPLv3 oder höher.

## TODOs ##

* Die gesamte Geschäftslogik fehlt noch.

## Doku ##

### Grundidee ###

Es sollen RPMs erstellt werden die generisch für bestimmte Zielsystem angepasst werden.

### Das Tamplet-System ###

In jedem RPM-Build-Projekt muss es ein Verzeichnis "/files" geben. In diesem Verzeichnis liegen alle Datein die in dem RPM enthalten sein sollen. In der Regel wird es sich dabei um Text basierte Konfigurationsdateien  handeln. Dies Konfigurationsdateien werden von rpminjection geparst und nach Schlüssel-Worten durchsucht die in "{{}}" stehen. Diese dienen als Platzhalter und werden durch Werte ersetzt die in einer separaten Konfiguration stehen.

### Die Konfiguration / bzw. Injectio ###

Es muss eine Konfigurationsdatei geben, mit den Ersetzungen, die von dem Tool rpminjection ausgelesen wird. Die Konfiguration ist im YAML-Format und listet alle Dateien und deren Ersetzungen auf. Gibt es eine Solche Konfiguration noch nicht, kann eine Beispiel-Konfiguration Generiert werden. Dazu wird das Tool mit dem Parameter "-e" oder "--example" aufgerufen. Wie die Konfiguration genannt wird ist egal. Sie wird dem Tool rpminjection als Parameter mitgegebenen. Also etwa so: "rpminjection ./meine.conf"

In der Konfiguration können beliebig fiel "BuildJob" definiert werden. Jeder BuildJob repräsentiert eine RPM-Variante für ein bestimmtes Zielsystem. Der Parameter "buildName:" sollte möglichst der Name des Zielsystems sein. Unterhalb von "buildFiles:" werden die Dateien aufgelistet, die in den Build hineinkommen sollen. "substituts:" sind die Platzhalter in den jeweiligen Dateien. Vordem Doppelpunkt steht der Platzhaltername und dahinter der Wehr der gesetzt werden soll.

Beispiel:

    - !ruby/object:BuildJob
    buildName: hotfix
    buildFiles:
    - !ruby/object:BulidFile
        filePath: files/etc/yum.repos.d/customised_rpms.repo
        substituts:
        SERVER-IP: 168.192.3.3
        TARGET_SYSTEM: hotfix
        
Für den BuildJob "hotfix" soll in der Datei "files/etc/yum.repos.d/customised_rpms.repo" nach dem Platzhalter "SERVER-IP" gesucht werden und durch "168.192.3.3" ersetzt werden.
