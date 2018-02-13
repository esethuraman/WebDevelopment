import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function init(root) {
  ReactDOM.render(<MainClass />, root);
}

class MainClass extends React.Component{
  constructor(){
	super();
	this.state = {name : "Ela", school: "Northeastern University", txtField: "" };
  }
  
  updateFields(){
	this.state.name = "Elavazhagan";
	this.setState(this);
  }
  
 displayTypings(){
	let txtId = $('txt_id');
	console.log(this.state);
	this.state.txtField = "some change has been done";
	console.log(this.state);
	this.setState(this);
 }

  render(){
	return(
	 <div> 
	   <h1> {this.state.name} </h1>
	   <h2> {this.state.school} </h2>
	   <input type="text"/>
	   <Button onClick={this.updateFields.bind(this)}> Update </Button>
	   <input type="text" id="txt_id" onChange={this.displayTypings.bind(this)}/>
	   <p> {this.state.txtField} </p>
	 </div>
	);
  }
}

