import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function incr_init(root) {
  ReactDOM.render(<MainClass />, root);
}

class MainClass extends React.Component{
  constructor(){
        super();
        this.state = {original:10, outList:[1,2,3], firstVal:"First", firstList:[1,2,3]};
  }

 updateList(){
	let tmpList = this.state.outList.slice();
	console.log(tmpList);
	tmpList.push(this.state.original);
	this.state.outList = tmpList;
	this.setState({outList : tmpList});
	console.log(this.state);
 }

 incrementValue(){
	console.log(this.state);
	this.state.original = this.state.original+1;
	this.updateList.bind(this);
	this.setState(this);
	
 }
 render(){
	let printableList = _.map(this.state.outList, (item) =>
					{return <p> The number is {item} </p>});
	return(
		<div>
			<h2> {this.state.original} </h2>
			<h3> {this.state.firstVal} </h3>
			<ul> {this.state.firstList} </ul>
			<Button onClick={this.incrementValue.bind(this)} > Increment </Button>
			<ul> {printableList}</ul>
			<p> Bottom of the page </p>
			<div className = "col-md-6"> ColMD6 </div>
		</div>
	)
 };
}
