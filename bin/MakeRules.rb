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
    # This function create the autotool files
    def run()
        self.cleanBuildDir()

        # ./configure.ac.template
        substituts_1 = Hash.new(0)
        substituts["EMAILADRESS"] = @email
        puts "read: resources/configure.ac.template"
        file_ = File.open( "resources/configure.ac.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
        "./configure.ac" << Mustache.render(fileContent_ , substituts_1)


        # ./Makefile.am.template
        substituts_2 = Hash.new(0)
        puts "read: resources/Makefile.am.template"
        file_ = File.open( "resources/Makefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
        "./Makefile.am" << Mustache.render(fileContent_ , substituts_2)


        # ./SubMakefile.am.template
        substituts_3 = Hash.new(0)
        puts "read: resources/SubMakefile.am.template"
        file_ = File.open( "resources/SubMakefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./src/Makefile.am and
        # Suchen und ersetzen....
        "./src/Makefile.am" << Mustache.render(fileContent_ , substituts_3)

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
