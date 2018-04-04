import React from 'react';
import { NavLink, Link } from 'react-router-dom';
import { Form, FormGroup, NavItem, Input, Button } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api';

let LoginForm = connect(({login}) => {return {login};})((props) => {

  function update(ev) {
    let tgt = $(ev.target);
    let data = {};
    data[tgt.attr('name')] = tgt.val();
    props.dispatch({
      type: 'UPDATE_LOGIN_FORM',
      data: data,
    });
  }

  function create_token(ev) {
    let params = {email: props.login.email, pass: props.login.pass};
    api.submit_login(params);
  }

  return <div className="navbar-text">
    <Form inline> 
      <FormGroup>
        <Input type="email" name="email" placeholder="email"
               value={props.login.email} onChange={update} />
      </FormGroup>
      <FormGroup>
        <Input type="password" name="pass" placeholder="password"
               value={props.login.pass} onChange={update} />
      </FormGroup>
      <Button onClick={create_token}>Log In</Button>
    </Form>

  </div>;
});

let Session = connect(({token}) => {return {token};})((props) => {
  return <div className="navbar-text">
    User id = { props.token.user_name }
  </div>;
});


function loggedInNavContents(props){ 
    return(
      <div>
        <ul className="navbar-nav mr-auto">
          <NavItem>
            <NavLink to="/" exact={true} activeClassName="active" className="nav-link">Feed</NavLink>
          </NavItem>
          <NavItem>
            <NavLink to="/users" href="#" className="nav-link">All Users</NavLink>
          </NavItem>
        </ul>
      </div>
      );
}

function registerNavContents(){

  return(
      <div>
        <ul className="navbar-nav mr-auto">
          <NavItem>
            <NavLink to="/createUser" exact={true} style={{marginRight: "4ex"}} activeClassName="active" className="nav-link">Register New User</NavLink>
          </NavItem>
          
        </ul>
      </div>
      );
}

function renderNavBarContents(props){
    if (props.token){
      return loggedInNavContents(props);
    }
    else{
      return registerNavContents();
    }
    
}
function Nav(props) {
  let session_info;
 
  if (props.token) {
    session_info = <Session token={props.token} />;
  }
  else {
    session_info = <LoginForm />
  }

  return (
    <nav className="navbar navbar-dark bg-dark navbar-expand">
      { renderNavBarContents(props) }
      { session_info }
    </nav>
  );
}


function state2props(state) {
  return {
    token: state.token,
  };
}

export default connect(state2props)(Nav);
