#!/usr/bin/ruby -w


require 'yaml'
require 'mustache'
require 'fileutils'


# require File.dirname(__FILE__) + "/getexampleconfigfile.rb"
require File.dirname(__FILE__) + "/makerules.rb"
require File.dirname(__FILE__) + "/tntmakemanager.rb"

def helpText()
    puts "
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
    "
end

##
# Billiger Komandozeilenparser. Geht bestimmt besser.
# Aber erst mal soll es reichen.
def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            tntmakeManager = TNTMakeManager.new()
            puts tntmakeManager.getExampleConfigFile()
        elsif a == "--clean" || a == "-c"
            jsonText = File.read( "Makefile.tnt" )
            makeRules = MakeRules.new()
            makeRules.loadJson( jsonText )

            tntmakeManager = TNTMakeManager.new()
            tntmakeManager.rules = makeRules
            tntmakeManager.clean()
        elsif a == "--scan" || a == "-s"
            tntmakeManager = TNTMakeManager.new()
            puts tntmakeManager.scanSourceDirs()
        elsif a == "--run" || a == "-r"
            returnmessage = `autoreconf --force --install && mkdir -p ./bulid && cd ./bulid && ../configure && make`
            puts returnmessage
        elsif a == "--build" || a == "-b"
            jsonText = File.read( "Makefile.tnt" )
            makeRules = MakeRules.new()
            makeRules.loadJson( jsonText )

            tntmakeManager = TNTMakeManager.new()
            tntmakeManager.rules = makeRules
            tntmakeManager.buildRun()
        elsif a == "--thread-build" || a == "-tb"
            jsonText = File.read( "Makefile.tnt" )
            makeRules = MakeRules.new()
            makeRules.loadJson( jsonText )
            makeRules.useThread = true

            tntmakeManager = TNTMakeManager.new()
            tntmakeManager.rules = makeRules
            tntmakeManager.buildRun()
        elsif a == "--convert-autotools" || a == "-am"
            # Convert from YAML config file in to a MakeRules class (so i hope!)
            makeRules =  YAML.load_file( "Makefile.tnt" )
            tntmakeManager = TNTMakeManager.new()
            tntmakeManager.rules=makeRules
            tntmakeManager.createAutoConf()
        elsif a == "--help" || a == "-h"
            helpText()
        else
            helpText()
        end
    end
end

argParse()



