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

        puts "Will create if not exit: #{@rules.buildDir}"
        Dir.mkdir(@rules.buildDir) unless File.exists?(@rules.buildDir)

        # compile ecpp files
        for ecppFile in @rules.ecppFiles
            objectFiles.push("#{ecppFile}.o")
            ## if *.cpp older than *.ecpp
            if  !File.exist?("#{ecppFile}.cpp") || File.mtime("#{ecppFile}") > File.mtime("#{ecppFile}.cpp")
                puts '##################### c_tmp -> o ########################'

                # ecpp -> cpp.tmp
#                 puts "compile  #{ecppFile}"
                ecpp_command = "#{@rules.ecppCompiler} #{@rules.ecppFlags} -o #{ecppFile}.c_tmp  #{ecppFile}"
                exit_code = system '#{ecpp_command}'
                puts "command: #{ecpp_command}"
                puts "exit code : [#{exit_code}]"
#                 exit_code = `$?`.delete!("\n")
#                 if exit_code != "0"
                if exit_code != true || exit_code == nil
                    puts "#{__FILE__} #{__LINE__} : "
                    puts "exit code : [#{exit_code}]"
#                     puts "return value: #{returnValue}"
                    puts "compiling command failed:"
                    puts "#{ecpp_command}"
                    raise 'compiling failed'
                end

                puts '====================== c_tmp -> o ========================'
                cpp_command = "#{@rules.cppCompiler} #{@rules.cppFlags} -o #{ecppFile}.o #{ecppFile}.c_tmp"
                exit_code = system '#{cpp_command}'
                puts "command: #{cpp_command}"
                puts "exit code : [#{exit_code}]"
                if exit_code != true || exit_code == nil
                    puts "#{__FILE__} #{__LINE__} :"
                    puts "exit code : [#{exit_code}]"
                    puts "compiling command failed:"
                    puts "#{cpp_command}"
                    raise 'compiling failed'
                end
                isNewComplied = true
            else
                puts "skip: #{ecppFile}"
                puts `ls -lah #{ecppFile}.cpp #{ecppFile} #{ecppFile}.cpp`
            end
        end

        # compiled resources
        objectFiles.push("#{@rules.buildDir}/resources.o")
        for resourcesFile in @rules.resourcesFiles
            puts "Check resources file: #{resourcesFile}"
            if !File.exist?("resources.cpp") || File.mtime(resourcesFile) > File.mtime("resources.cpp")
                puts "compile resources.cpp"
                # all -> cpp
                # compile resource files
                ecpp_command ="#{@rules.ecppCompiler} -bb -z -n resources -p -o #{@rules.buildDir}/resources.c_tmp #{@rules.ecppFlags} #{@rules.resourcesFiles}"
                exit_code = system '#{ecpp_command}'
                if exit_code != true || exit_code == nil
                    puts "#{__FILE__} #{__LINE__} :"
                    puts "exit code : [#{exit_code}]"
                    puts "compiling command failed:"
                    puts "#{ecpp_command}"
                    raise 'compiling failed'
                end

                p_command = "#{@rules.cppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/resources.o  #{@rules.buildDir}/resources.c_tmp "
                exit_code = system '#{p_command}'
                if exit_code != true || exit_code == nil
                    puts "#{__FILE__} #{__LINE__} :"
                    puts "exit code : [#{exit_code}]"
                    puts "compiling command failed:"
                    puts "#{cpp_command}"
                end

                isNewComplied = true
                break
            end
        end


        # compile cpp files
        for cppFile in @rules.cppFiles
            objectFiles.push("#{cppFile}.o")
            # if *.cpp older than *.cpp.o
            if !File.exist?("#{cppFile}.o") || File.mtime("#{cppFile}") > File.mtime("#{cppFile}.o")
                puts "compile  #{cppFile}"
                cpp_command = "#{@rules.cppCompiler} #{@rules.cppFlags} -o #{cppFile}.o #{cppFile}"
                exit_code = system( "#{cpp_command}  2>> ./tntmake.log")
                if exit_code != true || exit_code == nil
                    puts "compiling command failed:"
                    puts "#{cpp_command}"
                    raise 'compiling failed'
                end
                puts "#{__FILE__} #{__LINE__} exit_code: #{exit_code}"
                isNewComplied = true
            else
                puts "skip #{cppFile}"
                puts `ls -lah #{cppFile}.o #{cppFile} #{cppFile}.o`
            end
        end

        puts "linking programm"
        returnValue = `#{@rules.cppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/#{@rules.projectName} #{objectFiles.join(" ")}  2>&1`
        puts "#{__FILE__} #{__LINE__} : #{returnValue}"


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
    # remove the tntmake generated files (*.o *.c_tmp)
    def clean()
        cleanFiles = Array.new

        for ecppFile in @rules.ecppFiles
            cleanFiles.push("#{ecppFile}.o")
            cleanFiles.push("#{ecppFile}.c_tmp")
        end
        for cppFile in @rules.cppFiles
            cleanFiles.push("#{cppFile}.o")
        end
        cleanFiles.push(@rules.projectName)
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
