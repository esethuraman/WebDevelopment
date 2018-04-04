import React from 'react';
import Task from './task';

export default function Feed(params) {
  console.log("inside feed");
  console.log(params.tasks);
  let tasks = _.map(params.tasks, (pp) => <Task key={pp.id} task={pp} />);
  return <div>
    { tasks }
  </div>;
}