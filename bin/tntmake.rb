#!/usr/bin/ruby -w


require 'yaml'
require 'mustache'
require 'fileutils'


require File.dirname(__FILE__) + "/getexampleconfigfile.rb"
require File.dirname(__FILE__) + "/makerules.rb"
require File.dirname(__FILE__) + "/tntmakemanager.rb"

##
# Liest eine Konfiguration ein und inizialisiert
# damit die Klasse MakeRules. Das hier ein Objekt der
# Klasse "MakeRules" generiert wird sieht man zwar nicht,
# aber so ist das halt in Ruby...
def createAutoConf( _tntmakefileName )

    # Convert from YAML config file in to a MakeRules class (so i hope!)
    makeRules =  YAML.load_file( _tntmakefileName )
    tntmake = TNTMakeManager.new()
    tntmake.rules=makeRules
    tntmake.createAutoConf()

end


##
# Billiger Komandozeilenparser. Geht bestimmt besser.
# Aber erst mal soll es reichen.
#
# --example -e
#    Create a simple make file and write this on standard output.
#
# --scan -s
#     Same like "-e" but it is scanning all directories and collecting
#     information about the project.
# --clean -c
#     clean up generated files
#
def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            puts getExampleConfigFile()
        elsif a == "--clean" || a == "-c"
            tntmake = TNTMakeManager.new()
            tntmake.clean()
        elsif a == "--scan" || a == "-s"
            tntmake = TNTMakeManager.new()
            tntmake.scanSourceDirs()
        else
            createAutoConf( a )
        end
    end
end

argParse()



