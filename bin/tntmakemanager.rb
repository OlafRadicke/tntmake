require 'yaml'
require 'json'
require 'mustache'
require 'fileutils'

##
# Make processor
class TNTMakeManager


    def rules=( _newRules )
        @rules=_newRules
        @isNewComplied = false
    end

    ##
    # This function create the autotool files
    def createAutoConf()

        # ./configure.ac.template
        substituts_1 = Hash.new(0)

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
    # This function create a executable file
    def buildRun()
        @isNewComplied = false
        objectFiles = Array.new

        puts "Will create if not exit: #{@rules.buildDir}"
        Dir.mkdir(@rules.buildDir) unless File.exists?(@rules.buildDir)

        puts '#################################################################'
        puts '                      HEADER TOUCH CHECK'
        puts '#################################################################'
        # check header files
        for hFile in @rules.hFiles
            puts "check file: #{hFile}"
            if File.exist?("#{@rules.buildDir}/#{@rules.binName}") && File.mtime("#{@rules.buildDir}/#{@rules.binName}") < File.mtime(hFile)
                # if the execute file older than a header file than rebuild the
                # complete project new.
                puts "A header file is updated. call clean function an rebuild new."
                clean()
                puts "Will create if not exit: #{@rules.buildDir}"
                Dir.mkdir(@rules.buildDir) unless File.exists?(@rules.buildDir)

                break
            end
        end

        thrArrayECPP = []
        # compile ecpp files
        for ecppFile in @rules.ecppFiles
            objectFiles.push("#{ecppFile}.o")
            if @rules.useThread
                # with threading
                thrArrayECPP <<  Thread.new { compileCppFiles( ecppFile ) }
            else
                # without threading
                compileEcppFiles( ecppFile )
            end
        end
        thrArrayECPP.each { |thr| thr.join }

        puts '#################################################################'
        puts '                ENDE DES ERSTEN THREAD-DURCHLAUF'
        puts '#################################################################'

        # compiled resources
        if @rules.resourcesFiles.size > 0
            objectFiles.push("#{@rules.buildDir}/resources.o")
        end
        for resourcesFile in @rules.resourcesFiles
            puts "Check resources file: #{resourcesFile}"
            if !File.exist?("resources.cpp") || File.mtime(resourcesFile) > File.mtime("resources.cpp")
                puts "compile resources.cpp"
                # all -> cpp
                # compile resource files
                ecpp_command ="#{@rules.ecppCompiler} #{@rules.ecppFlags} -bb -z -n resources -p -o #{@rules.buildDir}/resources  #{@rules.resourcesFiles.join(" ")}"
                puts "(re-) compiling resources: \n"
                puts ecpp_command
#                 puts @rules.resourcesFiles
                exit_code = system(ecpp_command)
                if exit_code != true || exit_code == nil
                    puts "#{__FILE__} #{__LINE__} :"
                    puts "exit code : [#{exit_code}]"
                    puts "compiling command failed:"
                    puts "#{ecpp_command}"
                    raise 'compiling failed'
                end

                p_command = "#{@rules.cppCompiler} #{@rules.cppFlags} -o #{@rules.buildDir}/resources.o  #{@rules.buildDir}/resources.cpp "
                puts p_command

                exit_code = system(p_command)
                if exit_code != true || exit_code == nil
                    puts "#{__FILE__} #{__LINE__} :"
                    puts "exit code : [#{exit_code}]"
                    puts "compiling command failed:"
                    puts "#{p_command}"
                    raise 'compiling failed'
                end

                @isNewComplied = true
                break
            end
        end


        # compile cpp files
        thrArrayCPP = []
        for cppFile in @rules.cppFiles
            objectFiles.push("#{cppFile}.o")

            if @rules.useThread
                # with threading
                thrArrayCPP << Thread.new { compileCppFiles( cppFile ) }
            else
                # without threading
                compileCppFiles( cppFile )
            end
        end
        thrArrayCPP.each { |thr| thr.join }

        puts '#################################################################'
        puts '                ENDE DES ZWEITEN THREAD-DURCHLAUF'
        puts '#################################################################'

        puts "linking programm"
        linkingCommand = "#{@rules.cppCompiler} #{@rules.cppLinkerFlags} -o #{@rules.buildDir}/#{@rules.binName} #{objectFiles.join(" ")}"
        exit_code = system( linkingCommand)
        puts linkingCommand

        if exit_code != true || exit_code == nil
            puts "compiling command failed:"
            puts "#{linkingCommand}"
            raise 'compiling failed'
        end
        puts "#{@rules.buildDir}/#{@rules.binName} is created!"
    end

    ## compile ecpp files
    def compileEcppFiles( fileName )
        output = []
        ## if *.cpp older than *.ecpp
        if  !File.exist?("#{fileName}.cpp") || !File.exist?("#{fileName}.o") || File.mtime("#{fileName}") > File.mtime("#{fileName}.cpp")
            output << "##################### ecpp -> cpp ########################"
            ecpp_command = "#{@rules.ecppCompiler} #{@rules.ecppFlags} -o #{fileName}  #{fileName}"
            exit_code = system(ecpp_command)

            output << "command: #{ecpp_command}"
            output << "exit code : [#{exit_code}]"
            if exit_code != true || exit_code == nil
                puts "#{__FILE__} #{__LINE__} : "
                puts "exit code : [#{exit_code}]"
                puts "compiling command failed:"
                puts "#{ecpp_command}"
                raise 'compiling failed'
            end

            output << "====================== cpp -> o ========================"
            cpp_command = "#{@rules.cppCompiler} #{@rules.cppFlags} -o #{fileName}.o #{fileName}.cpp"
            exit_code = system(cpp_command)
            output << "command: #{cpp_command}"
            output << "exit code : [#{exit_code}]"
            output << `ls -lah  #{fileName}.cpp`
            output << `ls -lah #{fileName}.o`
            if exit_code != true || exit_code == nil
                puts "#{__FILE__} #{__LINE__} :"
                puts "exit code : [#{exit_code}]"
                puts "compiling command failed:"
                puts "#{cpp_command}"
                raise 'compiling failed'
            end
            @isNewComplied = true
        else
            output << "skip: #{fileName}"
            output << `ls -lah #{fileName}*`
        end
        puts output

    end

    ## compiled cpp files
    def compileCppFiles( fileName )
        output = []
        # if *.cpp older than *.cpp.o
        if !File.exist?("#{fileName}.o") || File.mtime("#{fileName}") > File.mtime("#{fileName}.o")

            output << "====================== cpp -> o ========================"
            output << "compile  #{fileName}"
            cpp_command = "#{@rules.cppCompiler} #{@rules.cppFlags} -o #{fileName}.o #{fileName}"
            output << "#{cpp_command}"
            exit_code = system( cpp_command)
            if exit_code != true || exit_code == nil
                puts "compiling command failed:"
                puts "#{cpp_command}"
                raise 'compiling failed'
            end
            output << "#{__FILE__} #{__LINE__} exit_code: #{exit_code}"
            @isNewComplied = true

        else
            output << "skip #{fileName}"
            output << `ls -lah #{fileName}.o #{fileName} #{fileName}.o`
        end
        puts output
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
        makeRules.buildDir="build_1"

        return YAML.dump(makeRules)
    end



    def scanSourceDirs()

        makeRules = MakeRules.new

        fileList = `find ./ -name '*.h'`
        makeRules.hFiles = fileList.split("\n")

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

        return makeRules.toJson()

    end

    ##
    # remove the tntmake generated files (*.o *.c_tmp)
    def clean()
        cleanFiles = Array.new

        for ecppFile in @rules.ecppFiles
            cleanFiles.push("#{ecppFile}.o")
            cleanFiles.push("#{ecppFile}.cpp")
        end
        for cppFile in @rules.cppFiles
            cleanFiles.push("#{cppFile}.o")
        end

        cleanCommand = "rm -f  #{cleanFiles.join(" ")}"
        exit_code = system( cleanCommand )
        if exit_code != true || exit_code == nil
            puts "\n compiling command failed: \n"
            puts "\n #{cleanCommand}"
            raise 'compiling failed'
        end

        cleanCommand = "rm -fr  #{@rules.buildDir}"
        exit_code = system( cleanCommand )
        if exit_code != true || exit_code == nil
            puts "\n compiling command failed: \n"
            puts "\n #{cleanCommand}"
            raise 'compiling failed'
        end

        puts "Remove: \n"
        puts cleanFiles
        puts @rules.buildDir
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
