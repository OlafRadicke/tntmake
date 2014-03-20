
import os.path
import makerules
import shutil
import subprocess

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

        print '#################################################################\n'
        print '                      HEADER TOUCH CHECK\n'
        print '#################################################################\n'
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

        print '#################################################################\n'
        print '                   ENDE DES ERSTEN DURCHLAUF\n'
        print '#################################################################\n'

        # compiled resources
        if len( self.rules.resourcesFiles ) > 0:
            objectFiles.append( self.rules.buildDir + "/resources.o")

        for resourcesFile in self.rules.resourcesFiles:
            # no checks: The file names is not with real pathes...

            print "====================== xxx -> cpp? ========================\n"
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
                print "====================== step 1  ========================\n"
                print ecpp_command

                if not self.doCLI( ecpp_command ) :
                    #raise 'compiling failed'
                    exit()

                p_command =  self.rules.cppCompiler + " " + self.rules.cppFlags + " "
                p_command += "-o " + self.rules.buildDir + "/resources.o  "
                p_command +=  self.rules.buildDir + "/resources.cpp "

                print "====================== step 2  ========================\n"
                print p_command

                if not self.doCLI( p_command ) :
                    #raise 'compiling failed'
                    exit()

                self.isNewComplied = True
                break

        print '#################################################################'
        print '                    ENDE DES ZWEITEN TEIL\n'
        print '#################################################################\n'
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
        print '#################################################################\n'
        print '                    ENDE DES DRITTEN TEIL\n'
        print '#################################################################\n'
        print "linking programm"
        linkingCommand =  self.rules.cppCompiler
        linkingCommand += " " + self.rules.cppLinkerFlags
        linkingCommand +=  " -o " + self.rules.buildDir + "/"
        seperator = " "
        linkingCommand +=  self.rules.binName + " " + seperator.join( objectFiles )

        if not self.doCLI( linkingCommand ) :
            #raise 'compiling failed'
            exit()

        print '#################################################################\n'
        print "          " + self.rules.buildDir + "/" + self.rules.binName + " is created!"
        print "                            END!"
        print '#################################################################\n'


    ## compile ecpp files
    def compileEcppFiles(self, fileName ):
        output = ""
        ## if *.cpp older than *.ecpp
        if  not os.path.isfile( fileName + ".cpp") \
            or not os.path.isfile( fileName + ".o") \
            or os.path.getmtime( fileName ) > os.path.getmtime( fileName + ".cpp"):
            output += "##################### ecpp -> cpp ########################\n"
            ecpp_command =  self.rules.ecppCompiler + " "
            ecpp_command += self.rules.ecppFlags + " -o " + fileName + "  " + fileName
            output += "command: " + ecpp_command

            if not self.doCLI( ecpp_command ) :
                #raise 'compiling failed'
                exit()

            output += "\n====================== cpp -> o ========================\n"
            cpp_command =  self.rules.cppCompiler + " " + self.rules.cppFlags
            cpp_command += " -o " + fileName + ".o " + fileName + ".cpp"
            output += "command: " + cpp_command

            if not self.doCLI( cpp_command ) :
                #raise 'compiling failed'
                exit()

            self.isNewComplied = True
        else:
            output += "skip: " + fileName
            output += "`ls -lah " + fileName + "*`"
        print output


    ## compiled cpp files
    def compileCppFiles(self, fileName ):
        output = ""
        # if *.cpp older than *.cpp.o
        if not os.path.isfile( fileName + ".o" ) \
            or os.path.getmtime( fileName ) > os.path.getmtime( fileName + ".o" ):

            output += "====================== cpp -> o ========================\n"
            output += "compile  " + fileName
            cpp_command =  self.rules.cppCompiler + " " + self.rules.cppFlags + " -o " + fileName + ".o " + fileName
            output +=  cpp_command

            if not self.doCLI( cpp_command ) :
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
        makeRules.hFiles = self.getFileList( "find ./ -name '*.h'" )
        makeRules.cppFiles = self.getFileList( "find ./ -name '*.cpp'" )
        makeRules.ecppFiles = self.getFileList( "find ./ -name '*.ecpp'" )
        makeRules.resourcesFiles = self.getFileList( "find `find ./ -name '*resource*'` -type f" )
        return makeRules.toJson()


    ##
    # remove the tntmake generated files (*.o *.c_tmp)
    def clean(self):
        print "Start clean process...\n"
        cleanFiles = []

        for ecppFile in self.rules.ecppFiles:
            cleanFiles.append( ecppFile + ".o")
            cleanFiles.append( ecppFile + ".cpp")

        for cppFile in self.rules.cppFiles:
            cleanFiles.append( cppFile + ".o")

        seperator = " "
        cleanCommand = "rm -f  " + seperator.join( cleanFiles )
        print "Will remove: \n"
        for fileName in cleanFiles:
            print fileName

        if not self.doCLI( cleanCommand ) :
            #raise 'compiling failed'
            exit()

        print "Will remove: \n"
        print self.rules.buildDir
        cleanCommand = "rm -fr  " + self.rules.buildDir

        if not self.doCLI( cleanCommand ) :
            #raise 'compiling failed'
            exit()

        print "...ready \n"


    def cleanBuildDir(self):
        if os.path.isfile( self.buildDir ):
            shutil.rmtree( self.buildDir )
            os.makedirs( self.buildDir )
        else:
            os.makedirs( self.buildDir )

    ##
    # Call a bash command. It get True if all okay.
    def doCLI(self, command ):
        proc = subprocess.Popen( command , \
            shell=True, \
            stdin=subprocess.PIPE, \
            stdout=subprocess.PIPE, \
            stderr=subprocess.PIPE, \
            close_fds=True)
        proc.wait()
        if len( proc.stderr.read() ) != 0:
            print "Error out: " + proc.stderr.read()
        if proc.returncode != 0:
            print "compiling command failed:"
            print  command + "\n"
            return False
        else:
            return True


    ##
    # Call a bash command. get back result as list.
    # If cli throw a error than call exit function.
    def getFileList(self, command ):
        proc = subprocess.Popen( command , \
            shell=True, \
            stdin=subprocess.PIPE, \
            stdout=subprocess.PIPE, \
            stderr=subprocess.PIPE, \
            close_fds=True)
        proc.wait()
        if len( proc.stderr.read() ) != 0:
            print "Error out: " + proc.stderr.read()
        if proc.returncode != 0:
            print "compiling command failed:"
            print  command + "\n"
            exit()
        else:
            fileList = proc.stdout.read()
            return fileList.split("\n")
