trigger countContactsOnAccount on Contact(after insert, after update, after delete, after undelete){
  
   List<Contact> contacts = new List<Contact>();
   contacts = (Trigger.isAfter && Trigger.isDelete) ? Trigger.old : Trigger.new;

   Set<Id> accountIds = new Set<Id>();

   for(Contact c : contacts){
       if(c.AccountId != null){
           accountIds.add(c.AccountId);
       }
   }
   
    List<Account> accountsToUpdate = new List<Account>(); 

   AggregateResult[] ar = [SELECT AccountId accId, COUNT(id) ContactCount  
                            FROM Contact 
                            WHERE AccountId IN :accountIds
                            GROUP BY AccountId ]; 

    for(AggregateResult result : ar){
        Account a = new Account();
        a.Id = (Id)result.get('accId');
        a.ContactCount__c = (integer)result.get('ContactCount');
        system.debug((integer)result.get('ContactCount'));
        accountsToUpdate.add(a);
    }

    update accountsToUpdate;
}