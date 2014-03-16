#!/usr/bin/ruby -w

require 'yaml'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Repräsentiert die Build-Konfiguration
class MakeRules

    attr_accessor :tntmakeVersion,
        :binName,
        :cppCompiler,
        :cppFlags,
        :cppLinkerFlags,
        :ecppCompiler,
        :ecppFlags,
        :hFiles,
        :cppFiles,
        :ecppFiles,
        :resourcesFiles,
        :resourcesRoot,
        :buildDir,
        :useThread

    ##
    # Der Constructor der bei Ruby nicht Constructor heißt.
    def initialize

        ##
        # The version of tntmake that is create the configuration file.
        # With this number it can check the compatibility of a configuration.
        @tntmakeVersion = 1

        ## path to c++ compiler
        @cppCompiler = "g++"

        @cppFlags = "-c -Wall -pedantic  -I ./src  "

        @cppLinkerFlags = " -I./src -lcxxtools -ltntnet -ltntdb "

        @ecppFlags = "-I./src"

        ## path to ecpp file comiler
        @ecppCompiler = "ecppc"

        ## Name of excitable file
        @binName = "helloweld"


        ## Build directoy name
        @buildDir = "./build"

        ## List of header files
        @hFiles  = Array.new

#         def hFiles=( _new )
#             @hFiles  = _new
#         end

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

        ## add a file in the list of CSS, pics and so one files
        def addresourcesFiles( new_resourcesFiles )
            @resourcesFiles.push( new_resourcesFiles )
        end

        ## Path to resources root directory. "./src" for example.
        @resourcesRoot = "./src/"

        ## using threads for builds y/n
        @useThread = false


    end

    def toJson()

        makeRules = Hash.new
        makeRules["tntmakeVersion"] = @tntmakeVersion
        makeRules["binName"] = @binName
        makeRules["cppCompiler"] = @cppCompiler
        makeRules["cppFiles"] = @cppFiles
        makeRules["cppFlags"] = @cppFlags
        makeRules["cppLinkerFlags"] = @cppLinkerFlags
        makeRules["ecppCompiler"] = @ecppCompiler
        makeRules["ecppFlags"] = @ecppFlags
        makeRules["hFiles"] = @hFiles
        makeRules["ecppFiles"] = @ecppFiles
        makeRules["resourcesFiles"] = @resourcesFiles
        makeRules["resourcesRoot"] = @resourcesRoot
        makeRules["buildDir"] = @buildDir

        return JSON.generate(makeRules)
    end

    def loadJson( newJson )

        makeRules = JSON.parse( newJson )
        @tntmakeVersion = makeRules["tntmakeVersion"]
        @binName = makeRules["binName"]
        @cppCompiler = makeRules["cppCompiler"]
        @cppFiles = makeRules["cppFiles"]
        @cppFlags = makeRules["cppFlags"]
        @cppLinkerFlags = makeRules["cppLinkerFlags"]
        @ecppCompiler = makeRules["ecppCompiler"]
        @ecppFlags = makeRules["ecppFlags"]
        @hFiles = makeRules["hFiles"]
        @ecppFiles = makeRules["ecppFiles"]
        @resourcesFiles = makeRules["resourcesFiles"]
        @resourcesRoot = makeRules["resourcesRoot"]
        @buildDir = makeRules["buildDir"]

    end


end
