
##
# Die Funktion soll eine Beispielkonfiguration ausspucken.
def getExampleConfigFile ()
    

    # new Project
    rpmInjection = RPMinjection.new        
    
    #======== assemblyhall ======== 
    # new file
    buildfile_1 = BulidFile.new('/files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_1.addSubstitut( Substitute.new("SERVER-IP", "192.168.5.146") )
    buildfile_1.addSubstitut(Substitute.new("TARGET_SYSTEM", "assemblyhall"))

    # new build job
    buldjob_1 = BuildJob.new('assemblyhall')
    buldjob_1.addbuildFile(buildfile_1)

    rpmInjection.addJob(buldjob_1)
    
    #======== intigration ======== 
    # new file
    buildfile_2 = BulidFile.new('/files/customised_rpmrepos.spec')
    # values...
    buildfile_2.addSubstitut(Substitute.new("SERVER-IP", "168.192.3.3"))
    buildfile_2.addSubstitut(Substitute.new("TARGET_SYSTEM", "intigration"))

    # new build job
    buldjob_2 = BuildJob.new('intigration')
    buldjob_2.addbuildFile(buildfile_2)
    rpmInjection.addJob(buldjob_2)

    
    #======== hotfix ======== 
    # new file
    buildfile_3 = BulidFile.new('/files/customised_rpmrepos.spec')
    # values...
    buildfile_3.addSubstitut(Substitute.new("SERVER-IP", "168.192.3.3"))
    buildfile_3.addSubstitut(Substitute.new("TARGET_SYSTEM", "hotfix"))

    # new build job
    buldjob_3 = BuildJob.new('hotfix')
    buldjob_3.addbuildFile(buildfile_3)
    rpmInjection.addJob(buldjob_3)
    
    
    #======== qa ======== 
    # new file
    buildfile_4 = BulidFile.new('/files/customised_rpmrepos.spec')
    # values...
    buildfile_4.addSubstitut(Substitute.new("SERVER-IP", "168.192.3.3"))
    buildfile_4.addSubstitut(Substitute.new("TARGET_SYSTEM", "qa"))

    # new build job
    buldjob_4 = BuildJob.new('qa')
    buldjob_4.addbuildFile(buildfile_4)
    rpmInjection.addJob(buldjob_4)
    
    
    #======== preview ======== 
    # new file
    buildfile_5 = BulidFile.new('/files/customised_rpmrepos.spec')
    # values...
    buildfile_5.addSubstitut(Substitute.new("SERVER-IP", "168.192.3.3"))
    buildfile_5.addSubstitut(Substitute.new("TARGET_SYSTEM", "preview"))

    # new build job
    buldjob_5 = BuildJob.new('preview')
    buldjob_5.addbuildFile(buildfile_5)
    rpmInjection.addJob(buldjob_5)
    
    
    # print out
    puts YAML.dump(rpmInjection)
end
