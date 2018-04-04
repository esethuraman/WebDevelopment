import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';

import Nav from './nav';
import Feed from './feed';
import Users from './users';
import TaskForm from './task_form';
import RegisterForm from './register_form';

import { Provider } from 'react-redux';

export default function taskTracker_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <TaskTracker />
    </Provider>,
    document.getElementById('root'),
  );
}

class TaskTracker extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      tasks: [],
      users: [],
    };

    this.request_tasks();
    this.request_users();
  }

  request_tasks() {
    $.ajax("/api/v1/tasks", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        this.setState(_.extend(this.state, { tasks: resp.data }));
      },
    });
  }

  request_users() {
    $.ajax("/api/v1/users", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        this.setState(_.extend(this.state, { users: resp.data }));
      },
    });
  }

  display_home_page(){
    console.log("================>");
    console.log(this.state.token);
    return(
      <div>
        <TaskForm users={this.state.users} />
        <Feed tasks={this.state.tasks} />
      </div>);
  }

  createUserPage(){
    return (
    <div style={{padding: "4ex"}}>
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
      </div>
    );
  }

  render() {
    
    return (
      <Router>  
        <div>
          <Nav />
          <Route path="/" exact={true} render={() =>
            this.display_home_page()
          } />

          <Route path="/createUser" render={(params) => 
            <RegisterForm />
          } />

          <Route path="/users" exact={true} render={() =>
            <Users users={this.state.users} />
          } />         

          <Route path="/users/:user_id" render={({match}) =>
            <Feed tasks={_.filter(this.state.tasks, (pp) =>
              match.params.user_id == pp.user.id )
            } />

          } />
        </div>
      </Router>
    );
  }
}
