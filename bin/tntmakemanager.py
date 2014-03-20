
import os.path
import makerules
import shutil

##
# Make processor
class TNTMakeManager:

    rules = makerules.MakeRules()
    isNewComplied = False

    ##
    # This function create a executable file
    def buildRun(self):
        self.isNewComplied = False
        objectFiles = []

        print "Will create if not exit: ./" + self.rules.buildDir
        if os.path.exists(  self.rules.buildDir ) == False:
            print "create " + self.rules.buildDir
            os.makedirs( self.rules.buildDir )

        print '#################################################################'
        print '                      HEADER TOUCH CHECK'
        print '#################################################################'
        # check header files
        for hFile in self.rules.hFiles:
            print "check file: " + hFile
            if os.path.isfile( self.rules.buildDir + "/" + self.rules.binName ) \
                and os.path.getmtime( self.rules.buildDir + "/" + self.rules.binName ) < os.path.getmtime( hFile ):
                # if the execute file older than a header file than rebuild the
                # complete project new.
                print "A header file is updated. call clean function an rebuild new."
                self.clean()
                print "Will create if not exit: " + self.rules.buildDir
                if os.path.exists( self.rules.buildDir ) == False:
                    print "create " + self.rules.buildDir
                    os.makedirs( self.rules.buildDir )
                break

        #thrArrayECPP = []
        # compile ecpp files
        for ecppFile in self.rules.ecppFiles:
            objectFiles.append( ecppFile + ".o")
            if self.rules.useThread :
                # with threading
                #thrArrayECPP.append( compileCppFiles( ecppFile ) )
                pass
            else:
                # without threading
                self.compileEcppFiles( ecppFile )

        #for thr in thrArrayECPP:
            #thr.join()

        print '#################################################################'
        print '                   ENDE DES ERSTEN DURCHLAUF'
        print '#################################################################'

        # compiled resources
        if len( self.rules.resourcesFiles ) > 0:
            objectFiles.append( self.rules.buildDir + "/resources.o")

        for resourcesFile in self.rules.resourcesFiles:
            # no checks: The file names is not with real pathes...

            print "====================== xxx -> cpp? ========================"
            if os.path.isfile( self.rules.buildDir + "/resources.cpp" ):
                print "Check resources file: \n"
                print  self.rules.resourcesRoot  + resourcesFile + " \n"
                print os.path.getmtime( self.rules.resourcesRoot  + resourcesFile )
                print  self.rules.buildDir + "/resources.cpp"
                print os.path.getmtime( self.rules.buildDir + "/resources.cpp")

            if not os.path.isfile( self.rules.buildDir + "/resources.o" ) \
                or os.path.getmtime( self.rules.resourcesRoot  + resourcesFile ) >                    os.path.getmtime( self.rules.buildDir + "/resources.cpp" ):
                print "compile resources.cpp now...."
                # all -> cpp
                # compile resource files
                ecpp_command =  self.rules.ecppCompiler + " " + self.rules.ecppFlags + " "
                ecpp_command += "-bb -z -n resources -p -o "
                ecpp_command +=  self.rules.buildDir + "/resources  "
                seperator = " "
                ecpp_command +=  seperator.join( self.rules.resourcesFiles )
                print "(re-) compiling resources... \n"
                print "====================== step 1  ========================"
                print ecpp_command

                (cli_in, cli_out, cli_err) = os.popen3( ecpp_command )
                if len( cli_err.read() ) != 0:
                    print "exit code : [" + cli_err + "]"
                    print "compiling command failed:"
                    print  ecpp_command
                    #raise 'compiling failed'
                    exit()

                p_command =  self.rules.cppCompiler + " " + self.rules.cppFlags + " "
                p_command += "-o " + self.rules.buildDir + "/resources.o  "
                p_command +=  self.rules.buildDir + "/resources.cpp "

                print "====================== step 2  ========================"
                print p_command

                (cli_in, cli_out, cli_err) = os.popen3( p_command )
                if len( cli_err.read() ) != 0:
                    print "exit code : [" + cli_err.read() + "]"
                    print "compiling command failed:"
                    print  p_command
                    raise 'compiling failed'

                self.isNewComplied = True
                break

        print '#################################################################'
        print '                    ENDE DES ZWEITEN TEIL'
        print '#################################################################'
        # compile cpp files
        #thrArrayCPP = []
        for cppFile in self.rules.cppFiles:
            objectFiles.append( cppFile + ".o")

            if self.rules.useThread:
                # with threading
                #thrArrayCPP.append( Thread() { compileCppFiles( cppFile )  ))
                pass
            else:
                # without threading
                self.compileCppFiles( cppFile )
        #thrArrayCPP.each { |thr| thr.join  + "
        print '#################################################################'
        print '                    ENDE DES DRITTEN TEIL'
        print '#################################################################'
        print "linking programm"
        linkingCommand =  self.rules.cppCompiler
        linkingCommand += " " + self.rules.cppLinkerFlags
        linkingCommand +=  " -o " + self.rules.buildDir + "/"
        seperator = " "
        linkingCommand +=  self.rules.binName + " " + seperator.join( objectFiles )

        (cli_in, cli_out, cli_err) = os.popen3( linkingCommand )
        if len( cli_err.read() ) != 0 :
            print "compiling command failed:"
            print  linkingCommand
            #raise 'compiling failed'
            exit()

        print '#################################################################'
        print "          " + self.rules.buildDir + "/" + self.rules.binName + " is created!"
        print "                            END!"
        print '#################################################################'


    ## compile ecpp files
    def compileEcppFiles(self, fileName ):
        output = []
        ## if *.cpp older than *.ecpp
        if  not os.path.isfile( fileName + ".cpp") \
            or not os.path.isfile( fileName + ".o") \
            or os.path.getmtime( fileName ) > os.path.getmtime( fileName + ".cpp"):
            output += "##################### ecpp -> cpp ########################"
            ecpp_command =  self.rules.ecppCompiler + " "
            ecpp_command += self.rules.ecppFlags + " -o " + fileName + "  " + fileName
            output += "command: " + ecpp_command

            (cli_in, cli_out, cli_err) = os.popen3( ecpp_command )
            if len( cli_err.read() ) != 0 :
                print "exit code : [" + cli_err.read() + "]"
                print "compiling command failed:"
                print  ecpp_command
                #raise 'compiling failed'
                exit()

            output += "====================== cpp -> o ========================"
            cpp_command =  self.rules.cppCompiler + " " + self.rules.cppFlags
            cpp_command += " -o " + fileName + ".o " + fileName + ".cpp"
            output += "command: " + cpp_command

            (cli_in, cli_out, cli_err) = os.popen3( cpp_command )
            if len( cli_err.read() ) != 0 :
                print "exit code : [" + cli_err.read() + "]"
                print "compiling command failed:"
                print  cpp_command
                #raise 'compiling failed'
                exit
            self.isNewComplied = True
        else:
            output += "skip: " + fileName
            output += "`ls -lah " + fileName + "*`"
        print output


    ## compiled cpp files
    def compileCppFiles(self, fileName ):
        output = []
        # if *.cpp older than *.cpp.o
        if not os.path.isfile( fileName + ".o" ) \
            or os.path.getmtime( fileName ) > os.path.getmtime( fileName + ".o" ):

            output += "====================== cpp -> o ========================"
            output += "compile  " + fileName
            cpp_command =  self.rules.cppCompiler + " " + self.rules.cppFlags + " -o " + fileName + ".o " + fileName
            output +=  cpp_command

            (cli_in, cli_out, cli_err) = os.popen3( cpp_command )
            if len( cli_err.read() ) != 0 :
                print "compiling command failed:"
                print  cpp_command
                #raise 'compiling failed'
                exit()

            self.isNewComplied = True

        else:
            output += "skip " + fileName
            output += "`ls -lah " + fileName + ".o " + fileName + " "
            output += fileName + ".o`"
        print output


    def scanSourceDirs(self):

        makeRules = makerules.MakeRules()

        (cli_in, cli_out, cli_err) = os.popen3("find ./ -name '*.h'")
        fileList = cli_out.read()
        makeRules.hFiles = fileList.split("\n")
        if len( cli_err.read() ) != 0:
            print "---ERROR---"
            print cli_err.read()
            exit()

        (cli_in, cli_out, cli_err) = os.popen3("find ./ -name '*.cpp'")
        fileList = cli_out.read()
        makeRules.cppFiles = fileList.split("\n")
        if len( cli_err.read() ) != 0:
            print "---ERROR---"
            print cli_err.read()
            exit()

        (cli_in, cli_out, cli_err) = os.popen3("find ./ -name '*.ecpp'")
        fileList = cli_out.read()
        makeRules.ecppFiles = fileList.split("\n")
        if len( cli_err.read() ) != 0:
            print "---ERROR---"
            print cli_err.read()
            exit()


        (cli_in, cli_out, cli_err) = os.popen3( "find `find ./ -name '*resource*'` -type f")
        fileList = cli_out.read()
        makeRules.resourcesFiles = fileList.split("\n")
        if len( cli_err.read() ) != 0:
            print "---ERROR---"
            exit()

        return makeRules.toJson()


    ##
    # remove the tntmake generated files (*.o *.c_tmp)
    def clean(self):
        cleanFiles = array()

        for ecppFile in self.rules.ecppFiles:
            cleanFiles.append( ecppFile + ".o")
            cleanFiles.append( ecppFile + ".cpp")

        for cppFile in self.rules.cppFiles:
            cleanFiles.append( cppFile + ".o")

        seperator = " "
        cleanCommand = "rm -f  " + seperator.join( cleanFiles )

        (cli_in, cli_out, cli_err) = os.popen3( cleanCommand )
        if len( cli_err.read() ) != 0 :
            print "\n compiling command failed: \n"
            print "\n " + cleanCommand
            #raise 'compiling failed'
            exit()

        cleanCommand = "rm -fr  " + self.rules.buildDir

        (cli_in, cli_out, cli_err) = os.popen3( cleanCommand )
        if len( cli_err.read() ) != 0 :
            print "\n compiling command failed: \n"
            print "\n " + cleanCommand
            #raise 'compiling failed'
            exit()

        print "Remove: \n"
        print cleanFiles
        print self.rules.buildDir

    def cleanBuildDir(self):
        if os.path.isfile( self.buildDir ):
            shutil.rmtree( self.buildDir )
            os.makedirs( self.buildDir )
        else:
            os.makedirs( self.buildDir )
