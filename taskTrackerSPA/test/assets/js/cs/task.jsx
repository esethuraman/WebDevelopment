import React from 'react';
import { Card, CardBody, Button } from 'reactstrap';
import api from '../api';
import store from '../store';

export default function Post(params) {
  function deleteSelectedTask(){
  	api.delete_task(task);
  }

  function editTask(task){
  	console.log("on edit task...");
  	console.log(task);
  	let action = {
      type: 'UPDATE_FORM',
      data: task,
    };
  	store.dispatch(action);
  }

  let task = params.task;
  return <Card>
    <CardBody>
      <div>
        <p>Task Assigned by <b>{ task.user.name }</b></p>
        <p>{ task.body }</p>
        <p> { task.assigned_to }</p>
        <Button className="btn btn-primary" onClick={function(){editTask(task)}}> Edit </Button>  
        <Button className="btn btn-danger" onClick={function(){deleteSelectedTask()}}> Delete </Button>
      </div>
    </CardBody>
  </Card>;
}