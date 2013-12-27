
##
# Die Funktion soll eine Beispielkonfiguration ausspucken.
def getExampleConfigFile ()

    # new Project
    rpmInjection = RPMinjection.new
    rpmInjection.setrpmName( "customised_rpmrepos" )
    rpmInjection.setVersionNo( "14" )
    
    #======== assemblyhall ======== 
    # new file
    buildfile_1 = BulidFile.new('files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_1.addSubstitut( "SERVER-IP", "192.168.5.146" )
    buildfile_1.addSubstitut("TARGET_SYSTEM", "assemblyhall")
    
    # new file
    buildfile_1_1 = BulidFile.new('files/customised_rpmrepos.spec')
    # values...
    buildfile_1_1.addSubstitut( "VERSION", rpmInjection.getVersionNo() )
    buildfile_1_1.addSubstitut("REALEASE", "1")
    buildfile_1_1.addSubstitut("TARGET_SYSTEM", "assemblyhall")

    # new build job
    buldjob_1 = BuildJob.new('assemblyhall')
    buldjob_1.addbuildFile(buildfile_1)
    buldjob_1.addbuildFile(buildfile_1_1)

    rpmInjection.addJob(buldjob_1)
    
    #======== intigration ======== 
    # new file
    buildfile_2 = BulidFile.new('files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_2.addSubstitut("SERVER-IP", "168.192.3.3")
    buildfile_2.addSubstitut("TARGET_SYSTEM", "intigration")
    
    # new file
    buildfile_2_1 = BulidFile.new('files/customised_rpmrepos.spec')
    # values...
    buildfile_2_1.addSubstitut( "VERSION", rpmInjection.getVersionNo() )
    buildfile_2_1.addSubstitut("REALEASE", "1")
    buildfile_2_1.addSubstitut("TARGET_SYSTEM", "intigration")

    # new build job
    buldjob_2 = BuildJob.new('intigration')
    buldjob_2.addbuildFile(buildfile_2)
    buldjob_2.addbuildFile(buildfile_2_1)
    
    rpmInjection.addJob(buldjob_2)

    #======== hotfix ======== 
    # new file
    buildfile_3 = BulidFile.new('files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_3.addSubstitut("SERVER-IP", "168.192.3.3")
    buildfile_3.addSubstitut("TARGET_SYSTEM", "hotfix")
    
    # new file
    buildfile_3_1 = BulidFile.new('files/customised_rpmrepos.spec')
    # values...
    buildfile_3_1.addSubstitut( "VERSION", rpmInjection.getVersionNo() )
    buildfile_3_1.addSubstitut("REALEASE", "1")
    buildfile_3_1.addSubstitut("TARGET_SYSTEM", "hotfix")

    # new build job
    buldjob_3 = BuildJob.new('hotfix')
    buldjob_3.addbuildFile(buildfile_3)
    buldjob_3.addbuildFile(buildfile_3_1)
    
    rpmInjection.addJob(buldjob_3)
    
    #======== qa ======== 
    # new file
    buildfile_4 = BulidFile.new('files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_4.addSubstitut("SERVER-IP", "168.192.3.3")
    buildfile_4.addSubstitut("TARGET_SYSTEM", "qa")
    
    # new file
    buildfile_4_1 = BulidFile.new('files/customised_rpmrepos.spec')
    # values...
    buildfile_4_1.addSubstitut( "VERSION", rpmInjection.getVersionNo() )
    buildfile_4_1.addSubstitut("REALEASE", "1")
    buildfile_4_1.addSubstitut("TARGET_SYSTEM", "qa")

    # new build job
    buldjob_4 = BuildJob.new('qa')
    buldjob_4.addbuildFile(buildfile_4)
    buldjob_4.addbuildFile(buildfile_4_1)
    
    rpmInjection.addJob(buldjob_4)
    
    #======== preview ======== 
    # new file
    buildfile_5 = BulidFile.new('files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_5.addSubstitut("SERVER-IP", "168.192.3.3")
    buildfile_5.addSubstitut("TARGET_SYSTEM", "vorschau")
    
    # new file
    buildfile_5_1 = BulidFile.new('files/customised_rpmrepos.spec')
    # values...
    buildfile_5_1.addSubstitut( "VERSION", rpmInjection.getVersionNo() )
    buildfile_5_1.addSubstitut("REALEASE", "1")
    buildfile_5_1.addSubstitut("TARGET_SYSTEM", "preview")

    # new build job
    buldjob_5 = BuildJob.new('vorschau')
    buldjob_5.addbuildFile(buildfile_5)
    buldjob_5.addbuildFile(buildfile_5_1)
    
    rpmInjection.addJob(buldjob_5)

    #======== qaa ======== 
    # new file
    buildfile_6 = BulidFile.new('files/etc/yum.repos.d/customised_rpms.repo.template')
    # values...
    buildfile_6.addSubstitut("SERVER-IP", "168.192.3.3")
    buildfile_6.addSubstitut("TARGET_SYSTEM", "qaa")
    
    # new file
    buildfile_6_1 = BulidFile.new('files/customised_rpmrepos.spec')
    # values...
    buildfile_6_1.addSubstitut( "VERSION", rpmInjection.getVersionNo() )
    buildfile_6_1.addSubstitut("REALEASE", "1")
    buildfile_6_1.addSubstitut("TARGET_SYSTEM", "qaa")

    # new build job
    buldjob_6 = BuildJob.new('qaa')
    buldjob_6.addbuildFile(buildfile_6)
    buldjob_6.addbuildFile(buildfile_6_1)
    
    rpmInjection.addJob(buldjob_6)
    
    return YAML.dump(rpmInjection)
end
