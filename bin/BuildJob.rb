
## 
# Repräsentiert die Daten, die gebraucht werden um ein RPM für ein
# bestimmtes Ziel zu erstellen.
class BuildJob

    ##
    # Constructor
    def initialize ( name_ )
        @buildName = name_
        @buildFiles = Array.new
    end

    ##
    # Name des Build-Jobs
    def getName()
        return @buildName
    end

    ##
    # Datei hinzufühgen die eine Injection bekommen soll.
    def addbuildFile ( bulidFile_ )
        @buildFiles.push(bulidFile_)

    end
    
    def getBuildFiles()
        return @buildFiles
    end

end