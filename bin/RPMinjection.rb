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

    def initialize
        @buildList  = Array.new
    end

    def addJob( job_ )
        @buildList.push(job_)
    end

    def getBuildList()
        @buildList.each do |thing|
            puts thing.getName()
        end
    end
    

end



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

def argParse()
    ARGV.each do|a|
        if a == "--example" || a == "-e"
            getExampleConfigFile()
        else
            loadConfig( a )
        end
        
        # getExampleConfigFile()
    end
end  

argParse()

# puts '====================================================='
# 
# puts '====================================================='
# puts Mustache.render("Hello {{planet}}! Hallo {{planet_de}}", :planet => "World!", :planet_de => "Welt!")
# puts '====================================================='

