#!/usr/bin/ruby -w

require 'yaml'
require 'mustache'

load 'Substitute.rb'
load 'BulidFile.rb'
load 'BuildJob.rb'
load 'getExampleConfigFile.rb'



##
# Repräsentiert die Geschäftslogik
class RPMinjection

    ##
    # Der Constructor der bei Ruby nicht Constructor heißt.
    def initialize
        @buildList  = Array.new
    end

    ##
    # Einen neuen Build-Job hinzufühgen
    def addJob( job_ )
        @buildList.push(job_)
    end

    ##
    # Gibt eine Liste der Namen der Bild-jobs zurück
    def getBuildList()
        @buildList.each do |thing|
            puts thing.getName()
        end
    end

    ##
    # Wird spähter mal die Jobs abarbeiten und die RPM-Injection
    # machen
    def run()
        # puts '====================================================='
        # 
        # puts '====================================================='
        # puts Mustache.render("Hello {{planet}}! Hallo {{planet_de}}", :planet => "World!", :planet_de => "Welt!")
        # puts '====================================================='        

end


##
# Liest eine Konfiguration ein und inizialisiert
# damit die Klasse RPMinjection. Das hier ein Objekt der
# Klasse "RPMinjection" generiert wird sieht man zwar nicht,
# aber so ist das halt in Ruby...
def loadConfig( filename_ )
    puts "================================"
    puts filename_
    puts "================================"
    file = File.open( filename_, "rb")
    contents = file.read
    # convert to YAML
    rpmInjection =  YAML::load( contents )
    puts rpmInjection
    rpmInjection.getBuildList()
    
end


##
# Billiger Komandozeilenparser. Geht bestimmt besser. 
# Aber erst mal soll es reichen.
def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            getExampleConfigFile()
        else
            loadConfig( a )
        end
    end
end  

argParse()



