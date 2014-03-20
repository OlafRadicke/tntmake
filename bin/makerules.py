#!/usr/bin/python

import json

##
# Represent the build configuration
class MakeRules:

    def __init__( self ):
        ##
        # The version of tntmake that is create the configuration file.
        # With this number it can check the compatibility of a configuration.
        self.tntmakeVersion = 1
        ## path to c++ compiler
        self.cppCompiler = "g++"
        self.cppFlags = "-c -Wall -pedantic  -I ./src  "
        self.cppLinkerFlags = " -I./src -lcxxtools -ltntnet -ltntdb "
        self.ecppFlags = "-I./src"
        ## path to ecpp file comiler
        self.ecppCompiler = "ecppc"
        ## Name of excitable file
        self.binName = "helloweld"
        ## Build directoy name
        self.buildDir = "./build"
        ## List of header files
        self.hFiles  = []
        self.cppFiles = []
        self.ecppFiles = []
        self.resourcesFiles = []
        ## Path to resources root directory. "./src" for example.
        self.resourcesRoot = "./src/"
        ## using threads for builds y/n
        self.useThread = False

    def toJson( self ):
        makeRules = dict()
        makeRules["tntmakeVersion"] = self.tntmakeVersion
        makeRules["binName"] = self.binName
        makeRules["cppCompiler"] = self.cppCompiler
        makeRules["cppFiles"] = self.cppFiles
        makeRules["cppLinkerFlags"] = self.cppLinkerFlags
        makeRules["ecppCompiler"] = self.ecppCompiler
        makeRules["ecppFlags"] = self.ecppFlags
        makeRules["hFiles"] = self.hFiles
        makeRules["ecppFiles"] = self.ecppFiles
        makeRules["resourcesFiles"] = self.resourcesFiles
        makeRules["resourcesRoot"] = self.resourcesRoot
        makeRules["buildDir"] = self.buildDir
        return json.dumps( makeRules, separators=(',', ':'), sort_keys = False, indent = 4)

    def loadJson( self, newJson ):
        makeRules = json.loads( newJson )
        print "makeRules: "
        print makeRules
        self.tntmakeVersion = makeRules["tntmakeVersion"]
        self.binName = makeRules["binName"]
        self.cppCompiler = makeRules["cppCompiler"]
        self.cppFiles = makeRules["cppFiles"]
        self.cppFlags = makeRules["cppFlags"]
        self.cppLinkerFlags = makeRules["cppLinkerFlags"]
        self.ecppCompiler = makeRules["ecppCompiler"]
        self.ecppFlags = makeRules["ecppFlags"]
        self.hFiles = makeRules["hFiles"]
        self.ecppFiles = makeRules["ecppFiles"]
        self.resourcesFiles = makeRules["resourcesFiles"]
        self.resourcesRoot = makeRules["resourcesRoot"]
        self.buildDir = makeRules["buildDir"]

