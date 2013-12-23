
## 
# Repräsentiert die Daten, die gebraucht werden um ein RPM für ein
# bestimmtes Ziel zu erstellen.
class BuildJob

    ##
    # Constructor
    def initialize ( name_ )
        @bulidName = name_
        @buldFiles = Array.new
    end

    ##
    # Name des Build-Jobs
    def getName ()
        puts @bulidName
    end

    ##
    # Datei hinzufühgen die eine Injection bekommen soll.
    def addbuildFile ( bulidFile_ )
        @buldFiles.push(bulidFile_)

    end

end