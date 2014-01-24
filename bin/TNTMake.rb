require 'yaml'
require 'mustache'
require 'fileutils'


# require "#{File.dirname(__FILE__)}/foo_class"


##
# Make processor
class TNTMake

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

        fileList = `find ./ -name '*.h'`
        puts fileList
        @rules = MakeRules.new
        for fileName in fileList.split('/n')
            @rules.addhFile( fileName )
        end

        fileList = `find ./ -name '*.cpp'`
        puts fileList
        @rules = MakeRules.new
        for fileName in fileList.split('/n')
            @rules.addcppFiles( fileName )
        end

        fileList = `find ./ -name '*.eccp'`
        puts fileList
        @rules = MakeRules.new
        for fileName in fileList.split('/n')
            @rules.addecppFiles( fileName )
        end

        fileList = `find ./ -name 'src*resource.*'`
        puts fileList
        @rules = MakeRules.new
        for fileName in fileList.split('/n')
            @rules.addresourcesFiles( fileName )
        end

        @rules.email="breifkasten@olaf-radicke.de"
        @rules.tntdbsupport="y"
        @rules.standalone="y"
        @rules.buildDir="bulid"
        @rules.binName = "tntsoa"


        # ./configure.ac.template
        substituts_1 = Hash.new(0)
        substituts_1["EMAILADRESS"] = @rules.email
        puts "read: resources/configure.ac.template"
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/configure.ac.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
#         "./configure.ac" << Mustache.render(fileContent_ , substituts_1)
        File.write('./configure.ac', Mustache.render(fileContent_ , substituts_1))


        # ./Makefile.am.template
        substituts_2 = Hash.new(0)
        substituts_2["EXTRA_DIST"] = @rules.extreDist.join("\n")
        puts "read: resources/Makefile.am.template"
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/Makefile.am.template", "rb")
        fileContent_ = file_.read()
        # create ./configure.ac and
        # Suchen und ersetzen....
#         "./Makefile.am" << Mustache.render(fileContent_ , substituts_2)
        File.write('./Makefile.am', Mustache.render(fileContent_ , substituts_2))


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
#         "./src/Makefile.am" << Mustache.render(fileContent_ , substituts_3)
        File.write('./src/Makefile.am', Mustache.render(fileContent_ , substituts_3))
        puts  Mustache.render(fileContent_ , substituts_3)


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
