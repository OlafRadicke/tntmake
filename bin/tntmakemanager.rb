require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Make processor
class TNTMakeManager

#     @rules

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
        "./configure.ac" << Mustache.render(fileContent_ , substituts_1)


        # ./Makefile.am.template
        substituts_2 = Hash.new(0)
        substituts_2["EXTRA_DIST"] = @rules.extreDist.join("\n")
        puts "read: resources/Makefile.am.template"
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/Makefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
        "./Makefile.am" << Mustache.render(fileContent_ , substituts_2)


        # ./SubMakefile.am.template
        substituts_3 = Hash.new(0)
        substituts_3["BINFILE"] = @rules.binName
        substituts_3["EXTRA_DIST"] = @rules.extreDist.join("\\\n")
        substituts_3["HEADERS"] = @rules.hFiles.join("\\\n")
        substituts_3["ECPPFILES"] = @rules.ecppFiles.join("\\\n")
        substituts_3["RESOURCES"] = @rules.resourcesFiles.join("\\\n")
        substituts_3["CPPFILES"] = @rules.cppFiles.join("\\\n")
        puts "read: resources/SubMakefile.am.template"
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/SubMakefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./src/Makefile.am and
        # Suchen und ersetzen....
        "./src/Makefile.am" << Mustache.render(fileContent_ , substituts_3)
        puts  Mustache.render(fileContent_ , substituts_3)

    end

    def scanSourceDirs()

        makeRules = MakeRules.new

        fileList = `find ./ -name '*.h'`
        puts '*.h:'
        puts fileList
        for fileName in fileList.split('/n')
            puts fileName
            makeRules.addhFile( fileName )
        end

        fileList_2 = `find ./ -name '*.cpp'`
        puts'*.cpp:'
        puts fileList_2
        for fileName_2 in fileList_2.split('/n')
            puts fileName_2
            makeRules.addcppFiles( fileName_2 )
        end

        fileList_3 = `find ./ -name '*.eccp'`
        puts '*.eccp:'
        puts fileList_3
        for fileName_3 in fileList_3.split('/n')
            puts fileName_3
            makeRules.addecppFiles( fileName_3 )
        end

        fileList_3 = `find ./ -name 'src*resource.*'`
        puts 'src*resource.*:'
        puts fileList_3
        for fileName_3 in fileList_3.split('/n')
            makeRules.addresourcesFiles( fileName_3 )
        end

        makeRules.email="breifkasten@olaf-radicke.de"
        makeRules.tntdbsupport="y"
        makeRules.standalone="y"
        makeRules.buildDir="bulid"
        makeRules.binName = "tntsoa"

        return YAML.dump(makeRules)

        ############################################################

#         # ./configure.ac.template
#         substituts_1 = Hash.new(0)
#         substituts_1["EMAILADRESS"] = @rules.email
#         puts "read: resources/configure.ac.template"
#         file_ = File.open( "#{File.dirname(__FILE__)}/resources/configure.ac.template", "rb")
#         fileContent_ = file_.read()
#         # create ./configure.ac and
#         # Suchen und ersetzen....
#         File.write('./configure.ac', Mustache.render(fileContent_ , substituts_1))
#
#
#         # ./Makefile.am.template
#         substituts_2 = Hash.new(0)
#         substituts_2["EXTRA_DIST"] = @rules.extreDist.join("\n")
#         puts "read: resources/Makefile.am.template"
#         file_ = File.open( "#{File.dirname(__FILE__)}/resources/Makefile.am.template", "rb")
#         fileContent_ = file_.read()
#         # create ./configure.ac and
#         # Suchen und ersetzen....
#         File.write('./Makefile.am', Mustache.render(fileContent_ , substituts_2))
#
#
#         # ./SubMakefile.am.template
#         substituts_3 = Hash.new(0)
#         substituts_3["BINFILE"] = @rules.binName
#         substituts_3["EXTRA_DIST"] = @rules.extreDist.join("\\\n")
#         substituts_3["HEADERS"] = @rules.hFiles.join("\\\n")
#         substituts_3["ECPPFILES"] = @rules.ecppFiles.join("\\\n")
#         substituts_3["RESOURCES"] = @rules.resourcesFiles.join("\\\n")
#         substituts_3["CPPFILES"] = @rules.cppFiles.join("\\\n")
#         puts "read: resources/SubMakefile.am.template"
#         file_ = File.open( "#{File.dirname(__FILE__)}/resources/SubMakefile.am.template", "rb")
#         fileContent_ = file_.read()
#         # create ./src/Makefile.am and
#         # Suchen und ersetzen....
#         File.write('./src/Makefile.am', Mustache.render(fileContent_ , substituts_3))
#         puts  Mustache.render(fileContent_ , substituts_3)


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
