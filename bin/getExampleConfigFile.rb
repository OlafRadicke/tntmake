
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
    makeRules.thirdpartlibs="-boost"
    makeRules.tntdbsupport="y"
    makeRules.standalone="y"
    makeRules.buildDir="bulid_1"
    makeRules.email="maintainer@nix.org"

    return YAML.dump(makeRules)
end
