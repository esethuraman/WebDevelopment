import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function logic_init(root) {
  ReactDOM.render(<MainClass />, root);
}

class MainClass extends React.Component{
  constructor(){
        super();
	this.state = { nos : [1,3,4,6,9], guess: '', isCorrect : ''};
  }

 verify(){
	console.log(this.state.nos);
	let input = $(guess_inp);
	this.state.guess = parseInt(input.val());
	console.log(this.state.guess)
	if(this.state.nos.includes(this.state.guess)){
		this.state.isCorrect='Yes';
	}
	else{
		this.state.isCorrect='No';
	}
	this.setState(this);
 }
 render(){
	return(
	  <div>
		<input type='text' id="guess_inp"/>
		<Button onClick={this.verify.bind(this)}> Guess </Button>	
		<p> Correcctly Guessed? {this.state.isCorrect} </p>
	  </div>
	)
 };
}
