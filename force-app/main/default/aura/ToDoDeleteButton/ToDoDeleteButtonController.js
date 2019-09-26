({
    handleClick : function(component, event, helper){
        // get the arrayIndex
        const arrayIndex = component.get('v.arrayIndex');
        // displatch an Event to delete the proper task
        const deleteEvent = $A.get('e.c:ToDoDeleteTask');
        deleteEvent.setParam("arrayIndex",arrayIndex);
        deleteEvent.fire();
    }
})