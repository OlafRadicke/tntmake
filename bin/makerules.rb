#!/usr/bin/ruby -w

require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Repräsentiert die Build-Konfiguration
class MakeRules

    attr_accessor :binName,
        :cppCompiler,
        :cppFlags,
        :cppLinkerFlags,
        :ecppCompiler,
        :ecppFlags,
        :hFiles,
        :cppFiles,
        :ecppFiles,
        :resourcesFiles,
        :buildDir,
        :useThread

    ##
    # Der Constructor der bei Ruby nicht Constructor heißt.
    def initialize

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

        ## List of extra files. Config examples, docus.
        @extreDist  = Array.new

        ## add a file in the list of extra files files
        def addExtreDistFiles( new_extreDist )
            @extreDist.push( new_extreDist )
        end

        ## using threads for builds y/n
        @useThread = false


    end

    def toJson()

        makeRules = Hash.new
        makeRules["binName"] = @binName
        makeRules["cppCompiler"] = @cppCompiler
        makeRules["cppFiles"] = @cppFiles
        makeRules["cppCompiler"] = @cppCompiler
        makeRules["cppFlags"] = @cppFlags
        makeRules["cppLinkerFlags"] = @cppLinkerFlags
        makeRules["ecppCompiler"] = @ecppCompiler
        makeRules["ecppFlags"] = @ecppFlags
        makeRules["hFiles"] = @hFiles
        makeRules["cppFiles"] = @cppFiles
        makeRules["ecppFiles"] = @ecppFiles
        makeRules["resourcesFiles"] = @resourcesFiles
        makeRules["extreDist"] = @extreDist
        makeRules["buildDir"] = @buildDir

        return JSON.generate(makeRules)
    end

    def loadJson( newJson )

        makeRules = JSON.parse( newJson )

        @binName = makeRules["binName"]
        @cppCompiler = makeRules["cppCompiler"]
        @cppFiles = makeRules["cppFiles"]
        @cppCompiler = makeRules["cppCompiler"]
        @cppFlags = makeRules["cppFlags"]
        @cppLinkerFlags = makeRules["cppLinkerFlags"]
        @ecppCompiler = makeRules["ecppCompiler"]
        @ecppFlags = makeRules["ecppFlags"]
        @hFiles = makeRules["hFiles"]
        @cppFiles = makeRules["cppFiles"]
        @ecppFiles = makeRules["ecppFiles"]
        @resourcesFiles = makeRules["resourcesFiles"]
        @extreDist = makeRules["extreDist"]
        @buildDir = makeRules["buildDir"]

    end


end
