trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    Set<Id> asyncApexJobIds = new Set<Id>();
    for(BatchApexErrorEvent evt:Trigger.new){
        asyncApexJobIds.add(evt.AsyncApexJobId);
    }
    
    Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>(
        [SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
    );
    
    List<BatchLeadConvertErrors__c> records = new List<BatchLeadConvertErrors__c>();
    for(BatchApexErrorEvent evt:Trigger.new){
        //only handle events for the job(s) we care about
        if(jobs.get(evt.AsyncApexJobId).ApexClass.Name == 'BatchLeadConvert'){
            for (String item : evt.JobScope.split(',')) {
                BatchLeadConvertErrors__c b = new BatchLeadConvertErrors__c(
                    AsyncApexJobId__c = evt.AsyncApexJobId,
                    Records__c = evt.JobScope,
                    StackTrace__c = evt.stackTrace 
                );
                records.add(b);
            }
        }
    }
    system.debug('YYYYYYYYYYYYYYYYYYYYYYYYY');
    insert records;
    List<BatchLeadConvertErrors__c> be = [SELECT id from BatchLeadConvertErrors__c]; 
    system.debug('be @@@ : ' + be.size());
}