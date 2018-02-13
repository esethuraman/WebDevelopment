import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function mem_init(root) {
  ReactDOM.render(<MainClass />, root);
}

class MainClass extends React.Component{

	render(){
		return(
			<div>
				<h1> memory game </h1>
			</div>
		);
	}
}