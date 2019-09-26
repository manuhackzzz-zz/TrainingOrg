<aura:application extends="force:slds">
    <!-- <c:Parent/>  -->
    <c:LightningTable 
                      sObjectName="Opportunity" 
                      fieldSetName="oppoFieldSet" 
                      parentFieldName="AccountId" 
                      parentRecordId="0012v00002UukxmAAB"/>
</aura:application>