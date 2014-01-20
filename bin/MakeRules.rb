#!/usr/bin/ruby -w

require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Repräsentiert die Build-Konfiguration
class MakeRules

    attr_accessor :binName,
        :hFiles,
        :cppFiles,
        :ecppFiles,
        :resourcesFiles,
        :thirdpartlibs,
        :tntdbsupport,
        :standalone,
        :buildDir,
        :email

    ##
    # Der Constructor der bei Ruby nicht Constructor heißt.
    def initialize
        ## Name of excitable file
        @binName = ""

        ## List of header files
        @hFiles  = Array.new

        ## add a file in the header files list
        def addhFile( new_hFile )
            @hFiles.push( new_hFile )
        end

        ## List of *.cpp files
        @cppFiles  = Array.new

        ## add a file in the list of *.cpp files
        def addcppFiles( new_cppFiles )
            @cppFiles.push( new_cppFiles )
        end

        ## List of *.ecpp files
        @ecppFiles  = Array.new

        ## add a file in the list of *.ecpp files
        def addecppFiles( new_ecppFiles )
            @ecppFiles.push( new_ecppFiles )
        end

        ## List of resource files. CSS, pics and so one.
        @resourcesFiles  = Array.new

        ## add a file in the list of *.ecpp files
        def addresourcesFiles( new_resourcesFiles )
            @resourcesFiles.push( new_resourcesFiles )
        end

        ## Complier flags for third part libs
        @thirdpartlibs = ""

        ## tntbd support switch
        @tntdbsupport = true

        ## standalone application y/n
        @standalone = true

        ## Build directoy name
        @buildDir = "./build"

        ## email address
        @email = ""

    end



    ##
    # Einen neuen Build-Job hinzufühgen
    def addJob( job_ )
        @buildList.push(job_)
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
            targetsystem_ = buildJob_.getName()
            # create rpm
            system( "cd #{subdir_} && ls" )
            system( "cd #{subdir_} && ls" )
            system( "cd #{subdir_} && mv ./files ./#{rpmname_}-#{targetsystem_}-#{versionsno_}/" )
            system( "cd #{subdir_} && tar -cvzf  ./#{rpmname_}-#{targetsystem_}-#{versionsno_}.tar.gz ./#{rpmname_}-#{targetsystem_}-#{versionsno_}/" )
            system( "cd #{subdir_} && rpmbuild -vv -ta ./#{rpmname_}-#{targetsystem_}-#{versionsno_}.tar.gz" )
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
