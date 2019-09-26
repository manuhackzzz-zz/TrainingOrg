// DisplayRecordsController.apxc
public class DisplayRecordsController {
    @AuraEnabled
    public static String getFieldSet(String sObjectName, String fieldSetName) { // to get fieldSet fields
        String result = '';
        
        SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);//metadata 
        Schema.DescribeSObjectResult d = objToken.getDescribe();
        Map<String, Schema.FieldSet> FieldsetMap = d.fieldSets.getMap();//<fset name, label>
        system.debug('@@@@@ FieldsetMap is @@@@@@@ ' + FieldsetMap);
        if(FieldsetMap.containsKey(fieldSetName))
            for(Schema.FieldSetMember f : FieldsetMap.get(fieldSetName).getFields()) {
                if(result != ''){
                    result += ',';
                }
                String sstr = '{';
                sstr += '"label":"' + f.getLabel() + '",';
                sstr += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                sstr += '"type":"' + (f.getType()) + '",';
                sstr += '"name":"' + f.getFieldPath() + '"';//returns fields api name
                sstr += '}';
                result += sstr;
            }
        system.debug('result is@@@@'+result);
        return '['+result+']';
        //return result;//fieldset name,fields ,type..
    }
    
    @AuraEnabled
    public static String getRecords(String sObjectName, String fieldName,decimal pageNumber, integer recordsToDisplay){ //// to get SObject Records 
        system.debug('fieldName '+fieldName);
        system.debug('sObjectName '+sObjectName);
        
        //integer pageSize = recordsToDisplay;
        // integer offset = ((integer)pageNumber - 1) * pageSize;
        
        List<sObject> lstResult = new List<sObject>();
        String result = '[]';
        List<String> fieldNames = (List<String>) JSON.deserialize(fieldName, List<String>.class);
        Set<String> setFieldNames = new Set<String>();
        Integer lmt=10;
        String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sObjectName;
        system.debug('query@@@'+query);
        
        for(sObject s : Database.query(query)){
            lstResult.add(s);
            system.debug('lstResult@@@'+lstResult);
        }
        if(lstResult.size() > 0) {
            result = JSON.serialize(lstResult);
            system.debug('result@@@'+result);
        }
        
        system.debug('size is--'+lstResult.size());
        
        return result;
        //returns the fields name on sobject and serialize them.(all inclusively) 
    }
    
    @AuraEnabled
    public static sObjectWrapper fetchSobjectRecords(Integer pageNumber ,String fieldName, Integer recordToDisplay, String sObjectName) {
        Integer pageSize = recordToDisplay;
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        system.debug('offset @@@ '+ offset);
        // create a instance of wrapper class.
        sObjectWrapper obj =  new sObjectWrapper();
        // set the pageSize, Page(Number), total records and to-fetch records(using OFFSET)   
        obj.pageSize = pageSize;
        system.debug('obj.pageSize @@@ '+ obj.pageSize);
        obj.page = (Integer) pageNumber;
        system.debug('obj.page @@@ '+ obj.page);
        String queryTotal = 'SELECT Id FROM ' + sObjectName; 
        obj.total = Database.query(queryTotal).size();
        
        List<sObject> lstResult = new List<sObject>();

        List<String> fieldNames = (List<String>) JSON.deserialize(fieldName, List<String>.class);
        Set<String> setFieldNames = new Set<String>();

        String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sObjectName + ' ORDER BY Name LIMIT '+ recordToDisplay + ' OFFSET ' + offset;
		system.debug('query ---> ' + query);
        lstResult = Database.query(query);
        if(lstResult.size() > 0){
        	obj.sObjectRecords = JSON.serialize(lstResult);   
            
        system.debug('obj.total @@@ '+ obj.total);
        } else{
            obj.sObjectRecords = ''; 
        }
        
        return obj;
    }
    
    // create a wrapper class with @AuraEnabled Properties    
    public class sObjectWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public String sObjectRecords {get;set;}
    }
    
}