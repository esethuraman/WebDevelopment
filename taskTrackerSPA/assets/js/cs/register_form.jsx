import React from 'react';
import { connect } from 'react-redux';
import { Button, Col, Row, FormGroup, Label, Input } from 'reactstrap';
import { Link } from 'react-router-dom';
import api from '../api';

function RegisterForm(params) {

  function update(ev) {
    let tgt = $(ev.target);

    let data = {};
    data[tgt.attr('name')] = tgt.val();
    let action = {
      type: 'UPDATE_FORM',
      data: data,
    };
    
    params.dispatch(action);
  }

  function submit(ev) {    
    let userParams = {name: params.form.name, pass: params.form.pass, email: params.form.email}
    if(userParams.name.length == 0){
      alert("Please enter a name");
    }
    else if(userParams.pass.length == 0){
      alert("Please enter a password");
    }
    else if(userParams.email.length == 0){
      alert("Please enter a mail id");
    }
    else{
      api.submit_user(userParams);  
    }
    
  }

  

  return (
    <div style={{padding: "4ex"}}>
      <h2>User Registration page</h2>

      <FormGroup>
        <Label for="name">User name</Label>
        <Input type="text" name="name"  value={params.form.name} onChange={update}/>
      </FormGroup>

      <FormGroup>
        <Label for="password_hash"> Password </Label>
        <Input type="password" name="pass" placeholder="password"
                 value={params.form.pass} onChange={update} />
      </FormGroup>

      <FormGroup>
        <Label for="email"> Email ID </Label>
        <Input type="text" name="email"  value={params.form.email} onChange={update}>
        </Input>
      </FormGroup>

      <Link to="/" className="btn btn-primary" onClick={submit}> Register Me </Link>
      
    </div>);
}


function state2props(state) {
  //console.log("rerender", state);
  return { form: state.form };
}

// Export the result of a curried function call.
export default connect(state2props)(RegisterForm);
