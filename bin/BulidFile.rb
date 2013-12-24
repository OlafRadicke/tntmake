
##
# Repräsentiert die Daten, die gebraucht werden um ein Template-File zu befüllen
class BulidFile
    
    ##
    # Constructor
    def initialize( filePath_ )
        @filePath = filePath_
        @substituts = Hash.new(0)
    end

    ##
    # Eine Ersetzung für die Injection hinzufühgen.
#     def addSubstitut( substitute_ )
#         @substituts.push( substitute_ )
#     end
    
    def addSubstitut( key_, value_)
        @substituts[key_] = value_
    end
    
    def getSubstitut()
        return @substituts
    end
    
    def getPath()
        return @filePath
    end

end