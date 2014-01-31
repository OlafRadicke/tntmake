require 'yaml'
require 'json'
require 'mustache'
require 'fileutils'

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
        substituts_1["PROJECTNAME"] = @rules.projectName
        substituts_1["EMAILADRESS"] = @rules.email
        substituts_1["VERSIONNO"] = @rules.versionNo
        substituts_1["TARBALLNAME"] = @rules.tarballName
        substituts_1["PROJECTURL"] = @rules.projectURL

        puts "read: resources/configure.ac.template"
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/configure.ac.template", "rb")
        fileContent_ = file_.read()
        file_.close
        puts "write ./configure.ac"
        # create ./configure.ac and
        # Suchen und ersetzen....
        File.write('./configure.ac', Mustache.render(fileContent_ , substituts_1) )


        # ./SubMakefile.am.template
        substituts_2 = Hash.new(0)
        substituts_2["BINFILE"] = @rules.binName
        substituts_2["EXTRA_DIST"] = @rules.extreDist.join("\\\n")
        substituts_2["HEADERS"] = @rules.hFiles.join("\\\n")
        substituts_2["ECPPFILES"] = @rules.ecppFiles.join("\\\n")
        substituts_2["RESOURCES"] = @rules.resourcesFiles.join("\\\n")
        substituts_2["CPPFILES"] = @rules.cppFiles.join("\\\n")
        file_ = File.open( "#{File.dirname(__FILE__)}/resources/Makefile.am.template", "rb")
        fileContent_ = file_.read()
        file_.close
        puts "write ./Makefile.am"
        # create ./Makefile.am and
        # Suchen und ersetzen....
        File.write('./Makefile.am', Mustache.render(fileContent_ , substituts_2) )

    end

    ##
    # This function create the autotool files
    def buildRun()
        isNewComplied = false
        objectFiles = Array.new


        dirname = File.dirname(@rules.buildDir)
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end

        # compile ecpp files
        for ecppFile in @rules.ecppFiles
            objectFiles.push("#{@rules.buildDir}/#{ecppFile}.cpp.o")
            ## if *.cpp older than *.cpp
            if File.mtime("#{ecppFile}") > File.mtime(" #{ecppFile}.cpp")
                puts "compile  #{ecppFile}"
                returnValue = `#{@rules.ecppCompiler} #{@rules.ecppFlags} -o #{@rules.buildDir}/#{ecppFile}.cpp  #{ecppFile} `
                puts returnValue
                returnValue = `#{@rules.ecppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/#{ecppFile}.cpp.o #{@rules.buildDir}/#{ecppFile}.cpp`
                puts returnValue
                isNewComplied = true
            else
                puts "skip #{ecppFile}"
            end
        end

        # compiled resources
        objectFiles.push("#{@rules.buildDir}/resources.o")
        for resourcesFile in @rules.resourcesFiles
            if File.mtime("#{resourcesFile}") > File.mtime("resources.cpp")
                puts "compile resources.cpp"
                # compile resource files
                returnValue = `#{@rules.ecppCompiler} -bb -z -n resources -p -o #{@rules.buildDir}/resources.cpp #{@rules.ecppFlags} #{@rules.resourcesFiles}`
                puts returnValue
                returnValue = `#{@rules.ecppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/resources.o  #{@rules.buildDir}/resources.cpp`
                puts returnValue
                isNewComplied = true
                break
            end
        end


        # compile ecpp files
        for cppFile in @rules.cppFiles
            objectFiles.push("#{@rules.buildDir}/#{cppFile}.cpp.o")
            # if *.cpp older than *.cpp.o
            if File.mtime("#{cppFile}") > File.mtime(" #{cppFile}.cpp.o")
                puts "compile  #{cppFile}"
                returnValue = `#{@rules.ecppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/#{cppFile}.cpp.o #{cppFile}`
                puts returnValue
                isNewComplied = true
            else
                puts "skip #{cppFile}"
            end
        end

        puts "linking programm"
        returnValue = `#{@rules.cppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/#{@rules.projectName} #{objectFiles.join(" ")}`
        puts returnValue


    end


    ##
    # This function generate a example makefile.
    def getExampleConfigFile ()

        # new Project
        makeRules = MakeRules.new

        makeRules.projectName = "HalloWelt"
        makeRules.binName = "hallowelt"
        makeRules.versionNo = 1
        makeRules.tarballName = "hallowelt"
        makeRules.projectURL = "http://hallowelt.org/"
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

        return makeRules.toJson()

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
