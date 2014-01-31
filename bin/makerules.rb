#!/usr/bin/ruby -w

require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Repräsentiert die Build-Konfiguration
class MakeRules

    attr_accessor :binName,
        :projectName,
        :versionNo,
        :tarballName,
        :projectURL,
        :cppCompiler,
        :cppFlags,
        :ecppCompiler,
        :ecppFlags,
        :hFiles,
        :cppFiles,
        :ecppFiles,
        :resourcesFiles,
        :extreDist,
        :thirdpartlibs,
        :tntdbsupport,
        :standalone,
        :buildDir,
        :email

    ##
    # Der Constructor der bei Ruby nicht Constructor heißt.
    def initialize

        ## path to c++ compiler
        @cppCompiler = "g++"

        @cppFlags = "-c -I ./src"

        @ecppFlags = "-I./src"

        ## path to ecpp file comiler
        @ecppCompiler = "ecppc"

        ## Name of excitable file
        @binName = "helloweld"

#         def binName=(newValue_)
#             @binName = newValue_
#         end

        ## Project name
        @projectName = "helloweld"

#         def projectName=(newValue_)
#             @projectName = newValue_
#         end

        ## versions number
        @versionNo = 1

#         def versionNo=(newValue_)
#             @versionNo = newValue_
#         end

        ## TARBALLNAME
        @tarballName = "helloweld"

#         def tarballName=(newValue_)
#             @tarballName = newValue_
#         end

        ## Project url
        @projectURL = ""

#         def projectURL=(newValue_)
#             @projectURL = newValue_
#         end

        ## Build directoy name
        @buildDir = "./build"

        ## email address
        @email = ""

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

        ## Complier flags for third part libs
        @thirdpartlibs = ""

        ## tntbd support switch
        @tntdbsupport = true

        ## standalone application y/n
        @standalone = true


    end

    def toJson()

        makeRules = Hash.new
        makeRules["binName"] = @binName
        makeRules["projectName"] = @projectName
        makeRules["versionNo"] = @versionNo
        makeRules["tarballName"] = @tarballName
        makeRules["projectURL"] = @projectURL
        makeRules["cppCompiler"] = @cppCompiler
        makeRules["cppFiles"] = @cppFiles
        makeRules["cppCompiler"] = @cppCompiler
        makeRules["cppFlags"] = @cppFlags
        makeRules["ecppCompiler"] = @ecppCompiler
        makeRules["ecppFlags"] = @ecppFlags
        makeRules["hFiles"] = @hFiles
        makeRules["cppFiles"] = @cppFiles
        makeRules["ecppFiles"] = @ecppFiles
        makeRules["resourcesFiles"] = @resourcesFiles
        makeRules["extreDist"] = @extreDist
        makeRules["thirdpartlibs"] = @thirdpartlibs
        makeRules["tntdbsupport"] = @tntdbsupport
        makeRules["standalone"] = @standalone
        makeRules["buildDir"] = @buildDir
        makeRules["email"] = @email

        return JSON.generate(makeRules)
    end

    def loadJson( newJson )

        makeRules = JSON.parse( newJson )

        @binName = makeRules["binName"]
        @projectName = makeRules["projectName"]
        @versionNo = makeRules["versionNo"]
        @tarballName = makeRules["tarballName"]
        @projectURL = makeRules["projectURL"]
        @cppCompiler = makeRules["cppCompiler"]
        @cppFiles = makeRules["cppFiles"]
        @cppCompiler = makeRules["cppCompiler"]
        @cppFlags = makeRules["cppFlags"]
        @ecppCompiler = makeRules["ecppCompiler"]
        @ecppFlags = makeRules["ecppFlags"]
        @hFiles = makeRules["hFiles"]
        @cppFiles = makeRules["cppFiles"]
        @ecppFiles = makeRules["ecppFiles"]
        @resourcesFiles = makeRules["resourcesFiles"]
        @extreDist = makeRules["extreDist"]
        @thirdpartlibs  = makeRules["thirdpartlibs"]
        @tntdbsupport = makeRules["tntdbsupport"]
        @standalone = makeRules["standalone"]
        @buildDir = makeRules["buildDir"]
        @email = makeRules["email"]

    end


end
