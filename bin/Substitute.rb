

##
# Repräsentiert einen Datensatz mit dem bestimmte Werte in
# Template-Files ausgetauscht werden
class Substitute
    
    ##
    # Constructor
    def initialize ( key_, value_)
        @key = key_
        @value = value_
    end
    
    ##
    # Bezeichner der Injection
    def getKey ()
        return @key
    end
    
    ##
    # Wert der Injection
    def getValue ()
        return @value
    end
end