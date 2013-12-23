
##
# Repräsentiert die Daten, die gebraucht werden um ein Template-File zu befüllen
class BulidFile
    def initialize( filePath_ )
        @filePath = filePath_
        @substituts = Array.new(0)
    end

    def addSubstitut( substitute_ )
        @substituts.push( substitute_ )
    end

end