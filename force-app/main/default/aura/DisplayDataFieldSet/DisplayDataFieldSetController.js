//  DisplayDataFieldSetController.js 
({
    doInit : function(component, event, helper) {
        helper.initRecordsFetch(component, event, helper);
    },
    
    navigate: function(component, event, helper) {
        
        var page = parseInt(component.get("v.page")) ; // this function call on click on the previous page button  
                                                        //var page = component.get("v.page");
                                                        //alert('page @@@'+page);
        
        var direction = event.getSource().get("v.label"); // get the previous button label  
        
        var recordToDisplay = component.find("recordSize").get("v.value");  //alert('direction @@@'+direction);
        																	// get the select option (drop-down) values. 
        
        page = direction === "Previous Page" ? (page - 1) : (page + 1); //alert('recordToDisplay @@@'+recordToDisplay);
        																// set the current page,(using ternary operator.)  
        																//alert('direction @@@'+ typeof page);
        
        // call the helper function
        helper.getSobjectRecords(component, page, recordToDisplay, component.get('v.sObjectName'));
        var recordsToShow = [];
        var tableRecordsBackup = component.get("v.tableRecordsBackup");
        var i=1;
        tableRecordsBackup.forEach(function(singleTableRecord){
            if(i<= recordToDisplay)
                recordsToShow.push(singleTableRecord);
            i++;
        })                                
        component.set("v.tableRecords",recordsToShow);        
    },
    
    onSelectChange: function(component, event, helper) {
        // this function call on the select opetion change,	 
        var page = 1
        var recordToDisplay = component.find("recordSize").get("v.value");
        helper.getSobjectRecords(component, page, recordToDisplay, component.get('v.sObjectName'));
    },
})