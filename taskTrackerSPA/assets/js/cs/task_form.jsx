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
    console.log(params);
    api.submit_task(params.form);
  }

  function clear(ev) {
    params.dispatch({
      type: 'CLEAR_FORM',
    });
  }

  let users = _.map(params.users, (uu) => <option key={uu.id} value={uu.id}>{uu.name}</option>);
  return <div style={{padding: "4ex"}}>
    <h2>Create New</h2>

    <FormGroup>
      <Label for="Task Title">Task Title</Label>
      <Input type="textarea" name="name"  value={params.form.name} onChange={update}/>
    </FormGroup>

    <FormGroup>
      <Label for="assigned_to"> Assign To</Label>
      <Input type="select" name="assigned_to"  value={params.form.assigned_to} onChange={update}>
        { users }
      </Input>
    </FormGroup>

    <FormGroup>
      <Label for="assigned_by"> Assigned By</Label>
      <Input type="number" name="user_id"  value={params.form.user_id} onChange={update}>
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
      <Label for="Completed">Completed</Label>
      <Input type="checkbox" name="completed" value={params.form.completed} onChange={update}/>

    </FormGroup>



    <Button onClick={submit}>Create Task</Button>
    <Button onClick={clear}>Clear</Button>

  </div>;
}


function state2props(state) {
  //console.log("rerender", state);
  return { form: state.form };
}

// Export the result of a curried function call.
export default connect(state2props)(TaskForm);
