// trigger to add CaseTeamMember's in whenver new case is inserted.

trigger caseTeamCreate on Case(after insert){
    List<Case> cases = new List<Case>();
    
    if(Trigger.isInsert){
        cases.addAll(Trigger.new);
    }

    Map<Id, User> userMap = new Map<Id, User>([SELECT Id, ManagerId FROM User LIMIT 50000]);
    List<CaseTeamMember> ctmList = new List<CaseTeamMember>();

    CaseTeamRole role = [select id from CaseTeamRole WHERE name = 'dev']; 

    for(Case theCase : cases){
        CaseTeamMember ctm1 = new CaseTeamMember();
        ctm1.MemberId = theCase.OwnerId;
        ctm1.ParentId = theCase.Id;
        ctm1.TeamRoleId = role.Id;        
        ctmList.add(ctm1);

        CaseTeamMember ctm2 = new CaseTeamMember();
        ctm2.MemberId = userMap.get(ctm1.MemberId).ManagerId;
        ctm2.ParentId = theCase.Id;
        ctm2.TeamRoleId = role.Id;
        ctmList.add(ctm2);

        CaseTeamMember ctm3 = new CaseTeamMember();
        ctm3.MemberId = userMap.get(ctm2.MemberId).ManagerId;
        ctm3.ParentId = theCase.Id;
        ctm3.TeamRoleId = role.Id;
        ctmList.add(ctm3);
        system.debug(ctmList);
    }

    insert ctmList;

}