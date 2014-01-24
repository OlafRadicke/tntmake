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
        :extreDist,
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

        ## Build directoy name
        @buildDir = "./build"

        ## email address
        @email = ""

    end


end
