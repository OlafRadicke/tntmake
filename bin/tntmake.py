#!/usr/bin/python

import sys
import tntmakemanager
import makerules

def helpText():
    print """
    --example -e
        Create a simple make file and write this on standard output.

    --scan -s
        Same like -e but it is scanning all directories and collecting
        information about the project. So if you want a make file do:
        tntmake -s > ./Makefile.tnt

    --clean -c
        Clean up generated files in the build directory.

    --build -b
        Try to read Makefil.tnt an build the binary file.

    --thread-build -tb
        Try to read Makefil.tnt an build the binary file.

    --convert-autotools -am
        it is reading the Makefile.tnt generated the autotools files.
    """

##
# Billiger Komandozeilenparser. Geht bestimmt besser.
# Aber erst mal soll es reichen.
def argParse():
    i = 0
    for a in sys.argv:
        i += 1
        if i == 1:
            continue
        print "a: " + a
        if a == "--example" or a == "-e":
            tntmakeManager = tntmakemanager.TNTMakeManager()
            print tntmakeManager.getExampleConfigFile()
        elif a == "--clean" or a == "-c":
            f = open('Makefile.tnt', 'r+')
            makeRules = makerules.MakeRules()
            makeRules.loadJson( f.read() )
            f.close()

            tntmakeManager = tntmakemanager.TNTMakeManager()
            tntmakeManager.rules = makeRules
            tntmakeManager.clean()
        elif a == "--scan" or a == "-s":
            tntmakeManager = tntmakemanager.TNTMakeManager()
            print tntmakeManager.scanSourceDirs()
        elif a == "--build" or a == "-b":
            f = open('Makefile.tnt', 'r+')
            makeRules = makerules.MakeRules()
            makeRules.loadJson( f.read() )
            f.close()

            tntmakeManager = tntmakemanager.TNTMakeManager()
            tntmakeManager.rules = makeRules
            tntmakeManager.buildRun()
        elif a == "--thread-build" or a == "-tb":
            f = open('Makefile.tnt', 'r+')
            makeRules = makerules.MakeRules()
            makeRules.loadJson( f.read() )
            f.close()
            makeRules.useThread = true

            tntmakeManager = tntmakemanager.TNTMakeManager()
            tntmakeManager.rules = makeRules
            tntmakeManager.buildRun()
        elif a == "--help" or a == "-h":
            helpText()
        else:
            helpText()

argParse()



