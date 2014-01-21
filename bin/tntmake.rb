#!/usr/bin/ruby -w

require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"
load 'getExampleConfigFile.rb'
load 'MakeRules.rb'


##
# Liest eine Konfiguration ein und inizialisiert
# damit die Klasse MakeRules. Das hier ein Objekt der
# Klasse "MakeRules" generiert wird sieht man zwar nicht,
# aber so ist das halt in Ruby...
def loadConfig( filename_ )

    # Convert from YAML config file in to a MakeRules class (so i hope!)
    rpmInjection =  YAML.load_file(filename_)
    puts rpmInjection.class.name
    rpmInjection.run()

end


##
# Billiger Komandozeilenparser. Geht bestimmt besser.
# Aber erst mal soll es reichen.
def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            puts getExampleConfigFile()
        elsif a == "--selftest" || a == "-t"
            rpmInjection =  YAML::load( getExampleConfigFile() )
            puts rpmInjection.class.name
        else
            loadConfig( a )
        end
    end
end

argParse()


