#!/usr/bin/ruby -w


require 'yaml'
require 'mustache'
require 'fileutils'


# require File.dirname(__FILE__) + "/getexampleconfigfile.rb"
require File.dirname(__FILE__) + "/makerules.rb"
require File.dirname(__FILE__) + "/tntmakemanager.rb"


##
# Billiger Komandozeilenparser. Geht bestimmt besser.
# Aber erst mal soll es reichen.
#
# --example -e
#    Create a simple make file and write this on standard output.
#
# --scan -s
#     Same like "-e" but it is scanning all directories and collecting
#     information about the project. After then write the yaml code on standard
#     output.
#
# --clean -c
#     clean up generated files in the build directory.
#
# tntmake [Makefile.tnt]
#     it is reading the yaml makefile of tntmake and generated the autotools
#     files.
#
def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            tntmakeManager = TNTMakeManager.new()
            puts tntmakeManager.getExampleConfigFile()
        elsif a == "--clean" || a == "-c"
            tntmakeManager = TNTMakeManager.new()
            tntmakeManager.clean()
        elsif a == "--scan" || a == "-s"
            tntmakeManager = TNTMakeManager.new()
            puts tntmakeManager.scanSourceDirs()
        else
            # Convert from YAML config file in to a MakeRules class (so i hope!)
            makeRules =  YAML.load_file( a )
            puts "#########################################################"
            puts makeRules.binName
            puts "#########################################################"
            tntmakeManager = TNTMakeManager.new()
            tntmakeManager.rules=makeRules
            tntmakeManager.createAutoConf()
        end
    end
end

argParse()



