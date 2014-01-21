#!/usr/bin/ruby -w


require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"
#load "#{File.dirname(__FILE__)}/getExampleConfigFile.rb"
load 'getExampleConfigFile.rb'
load 'MakeRules.rb'
load 'TNTMake.rb'


##
# Liest eine Konfiguration ein und inizialisiert
# damit die Klasse MakeRules. Das hier ein Objekt der
# Klasse "MakeRules" generiert wird sieht man zwar nicht,
# aber so ist das halt in Ruby...
def createAutoConf( _tntmakefileName )

    # Convert from YAML config file in to a MakeRules class (so i hope!)
    makeRules =  YAML.load_file( _tntmakefileName )
    tntmake = TNTMake.new()
    tntmake.rules=makeRules
    tntmake.createAutoConf()

end


##
# Billiger Komandozeilenparser. Geht bestimmt besser.
# Aber erst mal soll es reichen.
def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            puts getExampleConfigFile()
        elsif a == "--clean" || a == "-c"
            tntmake = TNTMake.new()
            tntmake.clean()
        else
            createAutoConf( a )
        end
    end
end

argParse()



