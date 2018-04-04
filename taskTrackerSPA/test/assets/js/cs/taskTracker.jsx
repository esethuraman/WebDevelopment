import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';

import Nav from './nav';
import Feed from './feed';
import Users from './users';
import TaskForm from './task_form';
import RegisterForm from './register_form';

import { Provider, connect } from 'react-redux';

export default function taskTracker_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <TaskTracker state={store.getState()}/>
    </Provider>,
    document.getElementById('root'),
  );
}

let TaskTracker = connect((state) => state)((props) => {
  
  function createUserPage(){
    return (
    <div style={{padding: "4ex"}}>
        <h2>Create New</h2>

        <FormGroup>
          <Label for="Task Title">Task Title</Label>
          <Input type="textarea" name="name"  value={props.form.name} onChange={update}/>
        </FormGroup>

        <FormGroup>
          <Label for="assigned_to"> Assign To</Label>
          <Input type="select" name="assigned_to"  value={props.form.assigned_to} onChange={update}>
            { users }
          </Input>
        </FormGroup>
      </div>
    );
  }
    
  return (
    <Router>  
      <div>
        <Nav />
        <Route path="/" exact={true} render={() =>
          <div>
            <TaskForm users={props.users} />
            <Feed tasks={props.tasks} />
          </div>
        } />

        <Route path="/createUser" render={(props) => 
          <RegisterForm />
        } />

        <Route path="/users" exact={true} render={() =>
          <Users users={props.users} />
        } />         

        <Route path="/users/:user_id" render={({match}) =>
          <Feed tasks={_.filter(props.tasks, (pp) =>
            match.params.user_id == pp.user.id )
          } />
        } />
      
      </div>
    </Router>
  );
});
