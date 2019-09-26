({
    handleComponent : function(component, event, helper) {
        $A.createComponents([
            ["ui:outputText",{
                "value" :"Message1"
            }],
            ["ui:outputText",{
                "value" : "Message2"
            }],
            ["ui:outputText",{
                "value" :"Message3"
            }]
        ],
                            function(components, status, errorMessage){
                                if (status === "SUCCESS") {
                                    var body = component.get("v.body");
                                    alert(typeof body[0]);
                                    components.forEach(function(item){
                                        body.push(item);
                                    });
                                    component.set("v.body", body);
                                }
                                else if (status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.")
                                }
                                    else if (status === "ERROR") {
                                        console.log("Error: " + errorMessage);
                                    }
                            }
                           );
    },
})