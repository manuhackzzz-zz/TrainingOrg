({
    myInit : function(component, event, helper) {
        var action = component.get("c.getDetails");
        action.setParams({ accId : component.get("v.accountId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let weatherDataString = response.getReturnValue();
                let weatherData = JSON.parse(weatherDataString); //oppo stringify
                component.set("v.weatherData",weatherData); console.log(weatherData);
                //alert("From server: " + response.getReturnValue());                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });        
        $A.enqueueAction(action);
    }
})