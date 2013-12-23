

##
# Repräsentiert einen Datensatz mit dem bestimmte Werte in
# Template-Files ausgetauscht werden
class Substitute
    def initialize ( key_, value_)
        @key = key_
        @value = value_
    end
    
    def getKey ()
        return @key
    end
    
    def getValue ()
        return @value
    end
end