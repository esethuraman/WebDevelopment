import React from 'react';
import { connect } from 'react-redux';
import { Button, Col, Row, FormGroup, Label, Input } from 'reactstrap';
import api from '../api';

function TaskForm(params) {

  function update(ev) {
    let tgt = $(ev.target);

    let data = {};

    // attribution: https://stackoverflow.com/questions/37073010/checkbox-value-true-false?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    if (tgt.attr('name') == "completed") {
      data["completed"] = $(tgt).is(':checked') ? 'true' : 'false';
    }
    else {
      data[tgt.attr('name')] = tgt.val();
    }

    let action = {
      type: 'UPDATE_FORM',
      data: data,
    };
    console.log(action);
    params.dispatch(action);
  }

  function submit(ev) {
    console.log("Should create Task.");
    console.log(params.form);
    if(params.form.name.length == 0){
      alert("Please Enter a name for task");
    }
    else if(params.form.minutes_worked%15 != 0){
      alert("Please enter minutes worked only as a multiple of 15");
    }
    else if (params.form.description.length == 0){
      alert("Please enter a task description");
    }
    else if (params.form.assigned_to.length == 0){
      alert("Please select a valid user from the dropdown list");
    }

    else{
      api.submit_task(params.form); 
      clear(); 
    }
    
  }

  function clear(ev) {
    params.dispatch({
      type: 'CLEAR_FORM',
    });
  }

  function getButtonLabel(){
    console.log("Getting button label..");
    if((params.form.name != null) && (params.form.name.length != 0)){
      return "Update Task";
    }
    else{
      return "Create Task";
    }
  }

  let users = _.map(params.users, (uu) => <option key={uu.id} value={uu.id}>{uu.name}</option>);

  return <div style={{padding: "4ex"}}>
    <h2>Create New</h2>

    <FormGroup>
      <Label for="Task Title">Task Title</Label>
      <Input type="text" name="name"  value={params.form.name} onChange={update}/>
    </FormGroup>

    <FormGroup>
      <Label for="assigned_to"> Assign To</Label>
      <Input type="select" name="assigned_to"  value={params.form.assigned_to} onChange={update}>
        { users }
      </Input>
    </FormGroup>

    <FormGroup>
      <Label for="assigned_by"> Assigned By</Label>
      <Input type="number" name="user_id"  value={params.form.user_id} readOnly>
      </Input>
    </FormGroup>

    <FormGroup>
      <Label for="TaskName">Body</Label>
      <Input type="textarea" name="body" value={params.form.body} onChange={update}/>
    </FormGroup>

    <FormGroup>
      <Label for="Description">Description</Label>
      <Input type="textarea" name="description" value={params.form.description} onChange={update}/>
    </FormGroup>

    <FormGroup>
      <Label for="Minutes_Worked">Minutes Worked</Label>
      <Input type="number" step="15" name="minutes_worked" value={params.form.minutes_worked} onChange={update}/>
    </FormGroup>

    <FormGroup>
      <Label for="Completed" style={{marginRight: "2ex"}}>Completed</Label>
      <Input type="checkbox" name="completed" value={params.form.completed} onChange={update}/>

    </FormGroup>

    <Button onClick={submit} style={{marginRight: "2ex"}}> Create/Update Task </Button>
    <Button onClick={clear} style={{marginLeft: "2ex"}}>Clear</Button>

  </div>;
}


function state2props(state) {
  //console.log("rerender", state);
  return { form: state.form , users: state.users};
}

// Export the result of a curried function call.
export default connect(state2props)(TaskForm);
