import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function mem_init(root, channel) {
  ReactDOM.render(<MainClass channel={channel} />, root);
}

class MainClass extends React.Component{

	constructor(props){
		super(props);
		this.channel = props.channel;
		
		this.state = {
			previous : -1,
			matchesCount: 0,
			cards_list : [],	
			clicksCount : 999999,
			score : 1160,
			sleepTraker: 0,
		};	

		this.channel.join()
           .receive("ok", this.gotView.bind(this)) 
           .receive("error", resp => { console.log("Unable to join", resp)});

	}

	gotView(view){
		
		this.setState(view.game);
		
		if(this.state.sleepTraker == 0){
 			
 			setTimeout(() => {this.channel.push("wakeFromSleep","")
						 		.receive("ok", this.gotView.bind(this))
						 		.receive("error", resp => { console.log("Unable to perform display toggle", resp)})},
					 			500);

 		
 		this.channel.push("goToSleep","")
 		.receive("ok", this.gotView.bind(this))
 		.receive("error", resp => { console.log("Unable to perform display toggle", resp)});
 		
 		}
 		
	}

	
	resetGame(){
		this.channel.push("reset", "")
		.receive("ok", this.gotView.bind(this));
	}

	
	displayCard(val){
		if(this.state.cards_list.length == 0){
			return "???";
		}
		if(this.state.cards_list[val].isShowable){
			return this.state.cards_list[val].actVal;
		}
		return "???";
	}


	printWinningStatus(){
		if(this.state.matchesCount == 8){
      		return (<h2 style={{color:"green", background:"lightgreen"}}> BINGO!!! YOU WON!!! </h2>);
    	}
    	return (<p> </p>);
	}
	


	toggleDisplay(val){
		
		//console.log("Inside toggle display intially ")
		//console.log(this.state)
		this.channel.push("toggleDisplay", val)
 		.receive("ok", this.gotView.bind(this))
 		.receive("error", resp => { console.log("Unable to perform display toggle", resp)});			
 		
 		this.gotView.bind(this)
		
 		
 		
	}

	renderCard(val, color){
		// console.log("reder card invoked...")
		// let color = "violet"
		return(
			<div className="col-sm-3" >
		        <div className="card cclass w-120 h-70" id={val} style={{margin: 10, background:color}}>
		          <button className="card-text btn btn-primary btn-lg btn-block" style={{background:color}} onClick={this.toggleDisplay.bind(this,val)}>
		            <div className="card-body">
		              <p style={{fontWeight: "bold", textAlign: "center"}}> {this.displayCard(val)} </p>
		        	</div>
	          		</button>
	        	</div>	
      		</div>
      );

	}
	

	getColorList(){
		let clist = this.state.cards_list;

      	let result = clist.map(function(card){
      		if(card.isMatched){
			return "lightgreen";
		}
			return "lightblue";
      	})

      	return result
	}

	render(){
		let colorList = this.getColorList()
		return(
			<div>			
				{this.printWinningStatus()}
				<div className="row">
						{this.renderCard(0, colorList[0])}			
						{this.renderCard(1, colorList[1])}			
						{this.renderCard(2, colorList[2])}			
						{this.renderCard(3, colorList[3])}			
						{this.renderCard(4, colorList[4])}			
						{this.renderCard(5, colorList[5])}			
						{this.renderCard(6, colorList[6])}			
						{this.renderCard(7, colorList[7])}			
						{this.renderCard(8, colorList[8])}			
						{this.renderCard(9, colorList[9])}			
						{this.renderCard(10, colorList[10])}				
						{this.renderCard(11, colorList[11])}				
						{this.renderCard(12, colorList[12])}				
						{this.renderCard(13, colorList[13])}				
						{this.renderCard(14, colorList[14])}				
						{this.renderCard(15, colorList[15])}
				</div>
				<div className = "row" style={{background:"silver"}} >
					<p className = "col-sm-6"> SCORE {this.state.score} </p>
					<p className = "col-sm-6"> CLICKS COUNT {this.state.clicksCount} </p>
				</div>
				<Button onClick={this.resetGame.bind(this)}> RESET </Button>
					
			</div>
			);
	}
}

