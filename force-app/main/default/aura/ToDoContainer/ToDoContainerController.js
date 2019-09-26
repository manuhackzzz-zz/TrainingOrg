({
    handleDeleteTask: function(component, event, helper){
        //alert('Deleted'); 
        // Get List of Tasks
        let tasks = component.get('v.tasks');
        // Get the arrayIndex
        const index = event.getParam('arrayIndex');
        // Remove the porper one
        tasks.splice(index,1);        
        // Set the List of tasks
        component.set('v.tasks',tasks);
    },

    handleCreateTask: function(component, event, helper){
        // Get list of tasks
        let tasks = component.get('v.tasks');
        // Get new task
        const newTask = event.getParam('taskName');
        // Add the new task
        tasks.push(newTask);
        // Set the tasks
        component.set('v.tasks', tasks);
    }
})