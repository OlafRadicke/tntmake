#!/usr/bin/ruby -w

require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"
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
        @buildDir = "./build"
        @rpmName = ""
        @versionNo = ""
    end
    
    ##
    # Set RPM name
    def setrpmName( name_ )
        @rpmName = name_
    end
    
    ##
    # Get RPM name
    def getrpmName( )
        return @rpmName
    end

    ##
    # Set versions no.
    def setVersionNo( no_ )
        @versionNo = no_
    end
    
    ##
    # Get versions no.
    def getVersionNo( )
        return @versionNo
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
        self.cleanBuildDir()
        @buildList.each do | buildJob_ |
            subdir_ = @buildDir + "/" + buildJob_.getName()
            puts "Create: " + subdir_
            Dir.mkdir( subdir_, 0700)
            buildFilesList_ = buildJob_.getBuildFiles()
            buildFilesList_.each do | buildFile_ |
                puts "read: " + buildFile_.getPath()
                file_ = File.open( buildFile_.getPath(), "rb")
                fileContent_ = file_.read()
                newPath_ = subdir_ + "/" + buildFile_.getPath()
                        
                dirname_ = File.dirname( newPath_ )
                puts dirname_
                FileUtils.mkpath(dirname_)

                # create directoris...

                open( newPath_, 'w') do |f|
                    # Suchen und ersetzen....
                    f << Mustache.render(fileContent_ , buildFile_.getSubstitut())
                end
            end
            rpmname_ = self.getrpmName()
            versionsno_ = self.getVersionNo()
            
            # create rpm
            system( "cd #{subdir_} && ls" )
            system( "cd #{subdir_} && ls" )
            system( "cd #{subdir_} && mv ./files ./#{rpmname_}-#{versionsno_}/" )
            system( "cd #{subdir_} && tar -cvzf  ./#{rpmname_}-#{versionsno_}.tar.gz ./#{rpmname_}-#{versionsno_}/" )
            system( "cd #{subdir_} && rpmbuild -vv -ta ./#{rpmname_}-#{versionsno_}.tar.gz" )
        end

        
    end
        
    def cleanBuildDir()
        if File.directory?(@buildDir)
            FileUtils.rm_rf(@buildDir)
            Dir.mkdir(@buildDir, 0700)
        else
            Dir.mkdir(@buildDir, 0700)
        end        
        
    end

end


##
# Liest eine Konfiguration ein und inizialisiert
# damit die Klasse RPMinjection. Das hier ein Objekt der
# Klasse "RPMinjection" generiert wird sieht man zwar nicht,
# aber so ist das halt in Ruby...
def loadConfig( filename_ )

    # Convert from YAML config file in to a RPMinjection class (so i hope!)
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



