require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Make processor
class TNTMakeManager


    def rules=( _newRules )
        @rules=_newRules
    end

    ##
    # This function create the autotool files
    def createAutoConf()

        # ./configure.ac.template
        substituts_1 = Hash.new(0)
        substituts_1["EMAILADRESS"] = @rules.email
        puts "read: resources/configure.ac.template"
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/configure.ac.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
        File.write('./configure.ac', Mustache.render(fileContent_ , substituts_1) )


        # ./Makefile.am.template
        substituts_2 = Hash.new(0)
        substituts_2["EXTRA_DIST"] = @rules.extreDist.join("\n")
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/Makefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
        File.write('./Makefile.am', Mustache.render(fileContent_ , substituts_2) )


        # ./SubMakefile.am.template
        substituts_3 = Hash.new(0)
        substituts_3["BINFILE"] = @rules.binName
        substituts_3["EXTRA_DIST"] = @rules.extreDist.join("\\\n")
        substituts_3["HEADERS"] = @rules.hFiles.join("\\\n")
        substituts_3["ECPPFILES"] = @rules.ecppFiles.join("\\\n")
        substituts_3["RESOURCES"] = @rules.resourcesFiles.join("\\\n")
        substituts_3["CPPFILES"] = @rules.cppFiles.join("\\\n")
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/SubMakefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./src/Makefile.am and
        # Suchen und ersetzen....
        File.write('./src/Makefile.am', Mustache.render(fileContent_ , substituts_3) )

    end

    ##
    # This function generate a example makefile.
    def getExampleConfigFile ()

        # new Project
        makeRules = MakeRules.new

        makeRules.binName = "hallowelt"
        makeRules.addhFile( "src/model/Model_1.h" )
        makeRules.addhFile( "src/model/Model_2.h" )
        makeRules.addhFile( "src/model/Model_3.h" )
        makeRules.addcppFiles( "src/model/Model_1.cpp" )
        makeRules.addcppFiles( "src/model/Model_2.cpp" )
        makeRules.addcppFiles( "src/model/Model_3.cpp" )
        makeRules.addecppFiles( "src/view/View_1.ecpp" )
        makeRules.addecppFiles( "src/view/View_2.ecpp" )
        makeRules.addecppFiles( "src/view/View_2.ecpp" )
        makeRules.addresourcesFiles( "src/resource/image_1.jpg")
        makeRules.addresourcesFiles( "src/resource/image_2.jpg")
        makeRules.addresourcesFiles( "src/resource/image_3.jpg")
        makeRules.addresourcesFiles( "src/resource/style.css")
        makeRules.addExtreDistFiles( "README.md")
        makeRules.addExtreDistFiles( "sql/example.sql")
        makeRules.thirdpartlibs="-boost"
        makeRules.tntdbsupport="y"
        makeRules.standalone="y"
        makeRules.buildDir="bulid_1"
        makeRules.email="maintainer@nix.org"

        return YAML.dump(makeRules)
    end



    def scanSourceDirs()

        makeRules = MakeRules.new

        fileList = `find ./ -name '*.h'`
        makeRules.hFiles = fileList.split("\n")
#         for fileName in fileList.split("\n")
#             puts "-" + fileName + "-"
#             makeRules.addhFile( fileName + "" )
#         end

        fileList_2 = `find ./ -name '*.cpp'`
        for fileName_2 in fileList_2.split("\n")
            makeRules.addcppFiles( fileName_2 )
        end

        fileList_3 = `find ./ -name '*.ecpp'`
        for fileName_3 in fileList_3.split("\n")
#             puts fileName_3
            makeRules.addecppFiles( fileName_3 )
        end

#         fileList_3 = `find ./ -name 'src*resource.*'`
        fileList_3 = `find \`find ./ -name '*resource*'\` -type f`
        for fileName_3 in fileList_3.split("\n")
            makeRules.addresourcesFiles( fileName_3 )
        end

        makeRules.email="breifkasten@olaf-radicke.de"
        makeRules.tntdbsupport="y"
        makeRules.standalone="y"
        makeRules.buildDir="bulid"
        makeRules.binName = "tntsoa"

#         return YAML.dump(makeRules)
        return makeRules.to_yaml( )


    end

    ##
    # remove the Makefile.tnt config file.
    def clean()
        FileUtils.rm_rf("Makefile.tnt")
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
