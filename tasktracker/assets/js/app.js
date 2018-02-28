// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function createNewTimeBlock(todo_id) {
  let current_time = new Date();
  let text = JSON.stringify({
    timer: {
        start_time: current_time,
        todo_id: todo_id
      },
  });

  $.ajax(timer_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log(resp); },
    error: (resp) => { console.log(resp); },
  });
}

function onNewTimeBlockClick(ev){
  let btn = $(ev.target);
  let todo_id = btn.data('todo-id');
  createNewTimeBlock(todo_id);
}

function updateStartTime(todo_id, timer_id, end_time){
  let current_time = new Date();
  let text = JSON.stringify({
    timer: {
        id: timer_id,
        start_time: current_time,
        end_time: end_time,
        todo_id: todo_id
      },
  });

  $.ajax(timer_path+"/"+timer_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log(resp); },
    error: (resp) => { console.log(resp); },
  });
}


function onUpdateStartTimeClick(ev){
  let btn = $(ev.target);
  let todo_id = btn.data('todo-id');
  let timer_id = btn.data('timer-id');
  let end_time = btn.data('end-time');
  updateStartTime(todo_id, timer_id, end_time);
}


function updateEndTime(todo_id, timer_id, start_time){
  let current_time = new Date();
  let text = JSON.stringify({
    timer: {
        id: timer_id,
        start_time: start_time,
        end_time: current_time,
        todo_id: todo_id
      },
  });

  $.ajax(timer_path+"/"+timer_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { console.log(resp); },
    error: (resp) => { console.log(resp); },
  });
}

function onUpdateEndTimeClick(ev){
  let btn = $(ev.target);
  let todo_id = btn.data('todo-id');
  let timer_id = btn.data('timer-id');
  let start_time = btn.data('start-time');
  updateStartTime(todo_id, timer_id, start_time);
}

function onDeleteClick(ev){

  let btn = $(ev.target);
  let timer_id = btn.data('timer-id');

  $.ajax(timer_path + "/" + timer_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: (resp) => { console.log(resp); },
    error: (resp) => { console.log(resp); },
  });
}

function init(){
  console.log("Hello from init");

  $('.newtimeblock').click(onNewTimeBlockClick)
  $('.updateStartTime').click(onUpdateStartTimeClick)
  $('.updateEndTime').click(onUpdateEndTimeClick)
  console.log("Hello1");
  $('.deleteTimeBlock').click(onDeleteClick)
}


$(init);
