//  DisplayDataFieldSetHelper.js 
({
    initRecordsFetch : function(component, event, helper) {
        var action = component.get("c.getFieldSet");
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            fieldSetName: component.get("v.fieldSetName")
        });		
        action.setCallback(this, function(response) {
            var fieldSetObj = JSON.parse(response.getReturnValue());
            component.set("v.fieldSetValues", fieldSetObj);         
            //helper.getSobjectRecords(component, 1, 50, component.get('v.sObjectName'));       //Call helper method to fetch the records
            																			//helper.getTableRows(component, event, helper);   
        })
        $A.enqueueAction(action);
    },
    
    getTableRows : function(component, event, helper){ // to get the Teable Heading cells ie Fields from the fieldset
        //debugger;
        var action = component.get("c.getRecords");
        var fieldSetValues = component.get("v.fieldSetValues");
        console.log('fieldSetValues',fieldSetValues);
        var setfieldNames = new Set();
        console.log('@@@@ ',fieldSetValues.length);
        var fieldlnt = fieldSetValues.length;
        for(var c = 0;fieldlnt > c; c++){             
            if(!setfieldNames.has(fieldSetValues[c].name)) {                 
                setfieldNames.add(fieldSetValues[c].name);
                console.log('setfieldNames ',setfieldNames);
                if(fieldSetValues[c].type == 'REFERENCE') {                     
                    if(fieldSetValues[c].name.indexOf('__c') == -1) {                     	
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('Id')) + '.Name');                          
                    }                     
                    else {
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('__c')) + '__r.Name');}                
                }             
            }         
        }  
        
        console.log('setfieldNames null',setfieldNames);
        var fieldNames = [];         
        setfieldNames.forEach(v => fieldNames.push(v));
        console.log(fieldNames);
        console.log('json',JSON.stringify(fieldNames));
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            fieldName: JSON.stringify(fieldNames)            
        });
        action.setCallback(this, function(response) {
            console.log('-------------------------------------------->'+response.getReturnValue());
            
            var list = JSON.parse(response.getReturnValue());
            console.log(list);
            component.set("v.tableRecords", list);
            component.set("v.tableRecordsBackup",list); // added for table records
            console.log(list);
        })
        $A.enqueueAction(action);
    },
    
    getSobjectRecords: function(component, page, recordToDisply, sObjectName) { // to get object records 
        														//debugger;
        var fieldSetValues = component.get("v.fieldSetValues");
        console.log('fieldSetValues',fieldSetValues);
        var setfieldNames = new Set();
        console.log('@@@@ ',fieldSetValues.length);
        var fieldlnt = fieldSetValues.length;
        for(var c = 0;fieldlnt > c; c++){             
            if(!setfieldNames.has(fieldSetValues[c].name)) {                 
                setfieldNames.add(fieldSetValues[c].name);
                console.log('setfieldNames ',setfieldNames);
                if(fieldSetValues[c].type == 'REFERENCE') {                     
                    if(fieldSetValues[c].name.indexOf('__c') == -1) {                     	
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('Id')) + '.Name');                          
                    }                     
                    else {
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('__c')) + '__r.Name');}                
                }             
            }         
        }  
        
        var fieldNames = [];         
        setfieldNames.forEach(v => fieldNames.push(v));        
        
        // create a server side action. 
        var action = component.get("c.fetchSobjectRecords");
        // set the parameters to method 
        action.setParams({
            "pageNumber": page,
            "recordToDisplay": recordToDisply,
            "sObjectName" : sObjectName,
            "fieldName" : JSON.stringify(fieldNames)
        });
        // set a call back   
        action.setCallback(this, function(response) {
            // store the response return value (wrapper class insatance)  
            var result = response.getReturnValue();
            console.log('result ---->' +JSON.stringify(result.sObjectRecords));
            // set the component attributes value with wrapper class properties.             
            component.set("v.page", result.page);
            component.set("v.total", result.total);
            component.set("v.pages", Math.ceil(result.total / recordToDisply));
            //console.log('recordToDisply'+recordToDisply);
            
            component.set("v.tableRecords", JSON.parse(result.sObjectRecords));
            component.set("v.tableRecordsBackup",JSON.parse(result.sObjectRecords));
        });
        $A.enqueueAction(action);
    }
})