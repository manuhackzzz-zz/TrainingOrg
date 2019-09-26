({
    handleCreateTask : function(component, event, helper){       
        // get input value
        const taskIp = document.getElementById('task-input').value;
        //alert('taskIp = ' + taskIp);
        // add to the List
        const createTaskEvent = $A.get("e.c:ToDoCreateTask");
        createTaskEvent.setParam('taskName',taskIp);
        createTaskEvent.fire();        
    }
})