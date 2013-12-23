
##
# Repräsentiert die Daten, die gebraucht werden um ein Template-File zu befüllen
class BulidFile
    
    ##
    # Constructor
    def initialize( filePath_ )
        @filePath = filePath_
        @substituts = Array.new(0)
    end

    ##
    # Eine Ersetzung für die Injection hinzufühgen.
    def addSubstitut( substitute_ )
        @substituts.push( substitute_ )
    end

end