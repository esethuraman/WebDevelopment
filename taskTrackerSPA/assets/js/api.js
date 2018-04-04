import store from './store';

class TheServer {
  request_tasks() {
    $.ajax("/api/v1/tasks", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'TASKS_LIST',
          posts: resp.data,
        });
      },
    });
  }

  delete_task(taskData){
    console.log(taskData);
    let taskId = taskData.id;
    console.log("URL TO DELETE ")
    let url = "/api/v1/tasks/"+taskId;
    console.log("/api/v1/tasks/"+taskId);
    $.ajax(url, {
      method: "delete",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        
      },
      error: (resp) => {
    
      },
    });
  }

  request_users() {
    $.ajax("/api/v1/users", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'USERS_LIST',
          users: resp.data,
        });
      },
    });
  }

  submit_task(data) {
    $.ajax("/api/v1/tasks", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({token: data.token, task: data }),
      success: (resp) => {
        console.log("sucessfully submitted the task ...");
        console.log(resp)
        store.dispatch({
          type: 'ADD_TASK',
          task: resp.data,
        });
        this.request_tasks();
      },
      error: (resp) => {
        console.log("ERRROORRRR IN SUBMITTING TASK ... ");
        console.log(data);
        console.log(resp);
      },
    });
  }

  submit_user(data) {
    $.ajax("/api/v1/users", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({token: data.token, user: data }),
      success: (resp) => {
        console.log("sucessfully submitted the user ...");
        store.dispatch({
          type: 'ADD_USER',
          user: resp.data,
        });
      },
      error: (resp) => {
        console.log("ERRROORRRR IN SUBMITTING USER ... ");
        console.log(data);
        console.log(resp);
      },
    });
  }

  submit_login(data) {
    $.ajax("/api/v1/token", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(data),
      success: (resp) => {
        store.dispatch({
          type: 'SET_TOKEN',
          token: resp,
        });
      },
      error: (resp) => {
        console.log("ERRROORRRR IN LOGGIN IN USER ... ");
        // console.log(token);
        console.log(resp);
      },
    });
  }
}

export default new TheServer();
