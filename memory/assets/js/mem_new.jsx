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
		//console.log("new view ", view);
		this.setState(view.game);
		// console.log("GOT STATED ...." , view.game)
	}

    //resetGame(){
	// 	this.setState({
	// 		previous : -1,
	// 		cards_list : this.getCardsList(),
	// 		matchesCount: 0,
	// 		clicksCount : 0,
	// 		score : 1160,
	// 	});

	// 	for(var cardId=0; cardId<16; cardId++){
	// 		// $(".col-sm-3 > div[id="+cardId+"]").css({"background": "lightblue"});
	// 		$(".col-sm-3 > div[id="+cardId+"] > button").css({"background":"lightblue"})
	// 	}
	// }
	
	resetGame(){
		this.channel.push("reset", "")
		.receive("ok", this.gotView.bind(this));
	}

	permuteArray() {
	    let arr = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D','E', 'E', 'F', 'F', 'G', 'G', 'H', 'H'];
	    let i = arr.length - 1;
	    // for (; i > 0; i--) {
	    //   const j = Math.floor(Math.random() * (i + 1));
	    //   const tmp = arr[i];
	    //   arr[i] = arr[j];
	    //   arr[j] = tmp;
	    // }
	    return arr;
  	}

	getCardsList(){
		let cardsList = [];
		let arr = this.permuteArray();
		for(var i=0; i<16; i++){
			let tmpMap = {id: i, actVal: arr[i], isShowable: false, isClickable: true};
			cardsList[i] = tmpMap;
		}
		console.log("cards being gotten from REACT JS")
		return cardsList;
	}

	displayCard(val){
		//console.log("DISPLLAYAYYYY")
		//console.log(this.state.cards_list)
		if(this.state.cards_list.length == 0){
			return "???";
		}
		if(this.state.cards_list[val].isShowable){
			return this.state.cards_list[val].actVal;
		}
		return "???";
	}

	setPrevious(val){
		this.setState({previous : val});
	}

	getPreviousId(){
		return this.state.previous;;
	}

	getValueForCard(cardId){

		return this.state.cards_list[cardId].actVal;
	}

	isEquivalentCard(val){
		return (this.getValueForCard(this.getPreviousId()) == this.getValueForCard(val));
	}

	// updateScore(){
	// 	console.log("I SHOULD NOT HAVE BEEN CALLED....");
	// 	this.channel.push("updateScore", "")
 // 		.receive("ok", this.gotView.bind(this))
 // 		.receive("error", resp => { console.log("Unable to join in update score", resp)});	
	// }
	// updateScore(){
	// 	console.log("update scores function");
	// 	let updatedScore = this.state.score - 10;
	// 	this.setState({score : updatedScore});
	// }
 
 	// incrementClicksCount(){
 	// 	console.log("I SHOULD NOT HAVE BEEN CALLED....");
 	// 	this.channel.push("reset", "")
		// .receive("ok", this.gotView.bind(this));
 	// 	this.channel.push("incrementClicksCount", "")
 	// 	.receive("ok", this.gotView.bind(this))
 	// 	.receive("error", resp => { console.log("Unable to join in incrementClicksCount", resp)});	
 	// }
	 // incrementClicksCount(){
	 // 	let count = this.state.clicksCount + 1;
	 // 	console.log("Count incremented " + this.state.clicksCount);
	 // 	this.setState({clicksCount : count});
	 // }

	updatedMatchesCount(){
		let count = this.state.matchesCount + 1;
		this.setState({matchesCount : count});
	}

	falsifyClickable(x){
		x.isClickable = false;
		return x;
	}

	freezeScreen(){
		let cardsList = this.state.cards_list;
		cardsList.map(this.falsifyClickable);
	}

	unfreezeCard(currentCard){
		// only unfreeze cards that are not yet matched
		if(!currentCard.isShowable){
			currentCard.isClickable = true;
		}
		return currentCard;
	}

	unfreezeScreen(){
		let cards_list = this.state.cards_list;
		cards_list.map(this.unfreezeCard);
	}

	updateCardColor(cardId, color){
		console.log("color update");
		console.log(cardId +" ==> " + "\""+color+"\"");
		$(".col-sm-3 > div[id="+cardId+"] > button").css({"background":color});
	}

	printWinningStatus(){
		if(this.state.matchesCount == 8){
      		return (<h2 style={{color:"green", background:"lightgreen"}}> BINGO!!! YOU WON!!! </h2>);
    	}
    	return (<p> </p>);
	}

	handlerEquivalentCards(updatedCardsList, val){
		setTimeout(() => {this.unfreezeScreen() }, 500);
		this.updateCardColor(val, "green");
		this.updateCardColor(this.getPreviousId(), "green");
		this.updatedMatchesCount();
		this.setPrevious(-1);
		this.freezeScreen();
	}

	handlerNonEquivalentCards(updatedCardsList, val){
		setTimeout(() =>
			{
				updatedCardsList[val].isShowable = false;
				updatedCardsList[val].isClickable = true;
				updatedCardsList[this.getPreviousId()].isClickable = true;
				updatedCardsList[this.getPreviousId()].isShowable = false;
				this.setPrevious(-1);
				this.unfreezeScreen();
				this.setState({cards_list : updatedCardsList});	
			}
			,1000);
		this.freezeScreen();
		this.setState({cards_list : updatedCardsList});
	}

	handlerSecondCardClick(val){
		var updatedCardsList = this.state.cards_list; 	
		if(this.isEquivalentCard(val)){
			this.handlerEquivalentCards(updatedCardsList, val);
		}
		else{
			this.handlerNonEquivalentCards(updatedCardsList, val);
		}
	}


	toggleDisplay(val){
		
		this.channel.push("toggleDisplay", val)
 		.receive("ok", this.gotView.bind(this))
 		.receive("error", resp => { console.log("Unable to perform display toggle", resp)});			
 		console.log("SLEEP TRACKER ", this.state.sleepTraker)
 		// nsole.log("SLEEEP NEEDED")
 		console.log(this.state)
 		// console.log(this.state.sleepTraker == 1)
 		if(this.state.sleepTraker == 1){
 			
 			setTimeout(() => {this.channel.push("wakeFromSleep",val)
						 		.receive("ok", this.gotView.bind(this))
						 		.receive("error", resp => { console.log("Unable to perform display toggle", resp)})},
					 			1000);

 		//console.log("inside sleep tracker 1")
 		this.channel.push("goToSleep","")
 		.receive("ok", this.gotView.bind(this))
 		.receive("error", resp => { console.log("Unable to perform display toggle", resp)});

 		}
 		else{
 		//	console.log("na probs . all set")
 		}

	}

	renderCard(val){
		// console.log("reder card invoked...")
		return(
			<div className="col-sm-3" >
		        <div className="card cclass w-120 h-70" id={val} style={{margin: 10, background:"lightblue"}}>
		          <button className="card-text btn btn-primary btn-lg btn-block" onClick={this.toggleDisplay.bind(this,val)}>
		            <div className="card-body">
		              <p style={{fontWeight: "bold", textAlign: "center"}}> {this.displayCard(val)} </p>
		        	</div>
	          		</button>
	        	</div>	
      		</div>
      );

	}
	
	render(){
		// console.log("display card react js CALLED")
		
		return(
			<div>			
				{this.printWinningStatus()}
				<div className="row">
						{this.renderCard(0)}				
						{this.renderCard(1)}				
						{this.renderCard(2)}				
						{this.renderCard(3)}				
						{this.renderCard(4)}				
						{this.renderCard(5)}				
						{this.renderCard(6)}				
						{this.renderCard(7)}				
						{this.renderCard(8)}				
						{this.renderCard(9)}				
						{this.renderCard(10)}				
						{this.renderCard(11)}				
						{this.renderCard(12)}				
						{this.renderCard(13)}				
						{this.renderCard(14)}				
						{this.renderCard(15)}
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

