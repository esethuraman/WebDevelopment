import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function memory_init(root) {
  ReactDOM.render(<MainClass />, root);
}

class MainClass extends React.Component{
	render(){
		return(
			<div>
				<h1> Hello world </h1>
			</div>
			);
	}
}