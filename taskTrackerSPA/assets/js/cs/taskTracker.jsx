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
  
  let comp;
  if(props.token){
    
       comp= <div>
                <p>  To Sign out, please reload the page </p>
                <br/>
                <TaskForm users={props.users} />
                <Feed tasks={props.tasks} users={props.users}/>
              </div>;
  }
  else{
    
     comp= <div>
        <h2> Single page Task Tracker Application </h2>
        <br/>
        <h3> If you are an Existing user, please login </h3>
        <br/>
        <h3> If you are a New User, please register yourself</h3>
        <br/>
        <h3> Happy Task Tracking !</h3>
        <br/>
      </div>;

  }


  return (
    <Router>  
      <div>
        <Nav />
        <Route path="/" exact={true} render={() =>
           <div>
                {comp}
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
