import React from 'react';
import { Card, CardBody, Button } from 'reactstrap';
import api from '../api';
import store from '../store';

export default function Post(params) {
  function deleteSelectedTask(){
  	api.delete_task(task);
  }

  function editTask(task){
  	let action = {
      type: 'UPDATE_FORM',
      data: task,
    };
  	store.dispatch(action);
  }

  function getUserName(users, userId){
    
    let targetUser = _.find(users, function(user){ return user.id==userId});
    
    if(targetUser != undefined){
      return targetUser.name;  
    }
    
    return userId;
    
  }

  function getTaskCompletedStatus(status){
    if(status == true){
      return "Completed";
    }
    else{
      return "Incomplete";
    }
  }

  let task = params.task;
  let users = params.users;
  
  return <Card>
    <CardBody>
      <div>
      	<h3> Task Name <b> { task.name }</b> </h3>
        <p>Assigned by <b>{ task.user.name }</b></p>
        <p>Assigned to <b> { getUserName(users, task.assigned_to) }</b></p>
        <p>Description <b> { task.description }</b></p>
        <p>Minutes worked <b> { task.minutes_worked }</b></p>
        <p>Status <b> { getTaskCompletedStatus(task.completed) }</b></p>
        <Button className="btn btn-primary" style={{marginRight: "2ex"}} onClick={function(){editTask(task)}}> Edit </Button>  
        <Button className="btn btn-danger" style={{marginLeft: "2ex"}} onClick={function(){deleteSelectedTask()}}> Delete </Button>
      </div>
    </CardBody>
  </Card>;
}