import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

/*
 *  state layout:
 *  {
 *   posts: [... Posts ...],
 *   users: [... Users ...],
 *   form: {
 *     user_id: null,
 *     body: "",
 *   }
 * }
 *
 * */

function tasks(state = [], action) {
  switch (action.type) {
  case 'TASKS_LIST':
    return [...action.posts];
  case 'ADD_TASK':
    return [action.post, ...state];
  default:
    return state;
  }
}

function users(state = [], action) {
  switch (action.type) {
  case 'USERS_LIST':
    return [...action.users];
  case 'ADD_USER':
    return [action.user, ...state];
  default:
    return state;
  }
}

let empty_form = {
  body: "",
  user_id: "",
  description: "",
  assigned_to: "",
  minutes_worked: 0,
  completed: false,
  name: "",
  token: "",
};

function getClearedForm(state){
  let updated_dict = {body: "",
  description: "",
  user_id: state.user_id,
  assigned_to: "",
  minutes_worked: 0,
  completed: false,
  name: "",
  token: state.token};

  return updated_dict;

}

function form(state = empty_form, action) {
  switch (action.type) {
    case 'UPDATE_FORM':
      return Object.assign({}, state, action.data);
    case 'CLEAR_FORM':
      // return Object.assign({}, empty_form, action.token);
      // return empty_form;
      let updatedState = getClearedForm(state);
      return updatedState
      
    case 'SET_TOKEN':
      return Object.assign({}, state, action.token);
    default:
      return state;
  }
}

function token(state = null, action) {
  switch (action.type) {
    case 'SET_TOKEN':
      return action.token;
    default:
      return state;
  }
}

let empty_login = {
  name: "",
  pass: "",
};

function login(state = empty_login, action) {
  switch (action.type) {
    case 'UPDATE_LOGIN_FORM':
      return Object.assign({}, state, action.data);
    default:
      return state;
  }
}



function root_reducer(state0, action) {
  // console.log("reducer", action);
  // {posts, users, form} is ES6 shorthand for
  // {posts: posts, users: users, form: form}
  // console.log("state1", state1);
  let reducer = combineReducers({tasks, users, form, token, login});
  let state1 = reducer(state0, action); 
  return deepFreeze(state1);
};

let store = createStore(root_reducer);
export default store;
