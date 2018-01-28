import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function memory_init(root) {
  ReactDOM.render(<MainClass />, root);
}

class CardComp extends React.Component{
  constructor(props){
    super(props);
    this.state = {
      displayValue : "?",
      actualValue : this.props.value,
      card_id: this.props.card_id,
    };
  }


  updateCardState(dispVal, actVal, cardActive){
    this.setState({
                 displayValue : dispVal,
                 actualValue: actVal,
    });
  }

  freezeTheScreen(){
    for(let i=0; i<16; i++){
      $(".col-sm-3 > div > a > div > button[id="+i+"]").parent().parent().attr('isclickable','false');
    }
  }

  unfreezeTheScreen(){
    let lockStatus;
    for(let i=0; i<16; i++){
      lockStatus = $(".col-sm-3 > div > a > div > button[id="+i+"]").parent().parent().attr('islocked');
      if(lockStatus){
        $(".col-sm-3 > div > a > div > button[id="+i+"]").parent().parent().attr('isclickable','true');
      }
    }
  }

  toggleCardDisplay(){
    let clickable = $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").parent().parent().attr('isclickable');
    let locked = $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").parent().parent().attr('islocked');
    
    if((clickable == "true") && (locked == "false")){
      if(this.props.isFreshTry){
        this.props.toggleFirstFlag();

        this.props.setPrevious(this.props.value);
        this.props.setPrevId(this.props.card_id);

        $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").text(this.props.value);
        $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").parent().parent().attr('isclickable','false');
        
      }
      else{
        
        let prevGuess = this.props.previous;

        if(this.props.previous == this.props.value){

          this.props.decrRemCount();

          this.props.setPrevious("?");
          $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").parent().parent().attr('islocked','true');
          $(".col-sm-3 > div > a > div > button[id="+this.props.prevId+"]").parent().parent().attr('islocked','true');
          $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").parent().parent().attr('isclickable','false');
          $(".col-sm-3 > div > a > div > button[id="+this.props.prevId+"]").parent().parent().attr('isclickable','false');

          setTimeout(()=>{
            $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").parent().parent().css({"background" : "lightgreen"});
            $(".col-sm-3 > div > a > div > button[id="+this.props.prevId+"]").parent().parent().css({"background" : "lightgreen"});
            $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").css({"background" : "green"});
            $(".col-sm-3 > div > a > div > button[id="+this.props.prevId+"]").css({"background" : "green"});
            $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").text(this.props.value);
            },
            0);

        }
        else{
          let currentValue = this.props.value;
          let prevGuess = this.props.previous;
          $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").text(this.props.value);

          setTimeout(()=>{
            $(".col-sm-3 > div > a > div > button[id="+this.props.card_id+"]").text('?');
            $(".col-sm-3 > div > a > div > button[id="+this.props.prevId+"]").text('?');
            $(".col-sm-3 > div > a > div > button[id="+this.props.prevId+"]").parent().parent().attr('isclickable','true');
            this.unfreezeTheScreen();
            }, 1000);

            this.freezeTheScreen();

        }


      }
    this.props.toggleFirstFlag();
    this.props.updateClicksCount();
    this.props.updateScore();
    }


  }


  resetCards(){
     $('.col-sm-3 > div > a > div > button').html('?');
     $(".col-sm-3 > div > a > div > button").parent().parent().attr('isclickable','true');
     $(".col-sm-3 > div > a > div > button").parent().parent().attr('islocked','false');
     $(".col-sm-3 > div > a > div > button").parent().parent().css({"background" : "lightblue"});
     $(".col-sm-3 > div > a > div > button").css({"background" : "royalblue"});

     this.props.resetCardFields();

  }

  addButton(){
    if(this.props.isLastCard){
      return(
         <Button className="btn btn-primary btn-lg btn-block" onClick={this.resetCards.bind(this)}> RESET </Button>
        );
    }
    else{
      return(
        <p/>);
    }
  }

  render(){

    return(

      <div className="col-sm-3">
        <div className="card cclass" style={{margin: 10, background:"lightblue"}}>
          <a href = '#' isclickable="true" islocked="false" onClick={this.toggleCardDisplay.bind(this)}>
            <div className="card-body">
              <button id={this.props.card_id} className="card-text btn btn-primary btn-lg btn-block"
               style={{padding: 20}}> {this.state.displayValue} </button>
            </div>
          </a>
        </div>
        <div> {this.addButton()} </div>
      </div>
    );
  }
}
class MainClass extends React.Component{

  constructor(props){
    super(props);
    this.state = {
      isFirstTry : true,
      prevId: 0,
      previous : '?',
      remainingCount : 8,
      score: 1000,
      clicksCount: 0,
      isShuffleNeeded : true,
      memoryFields : this.permuteArray(),
    };
  }

  permuteArray() {
    let arr = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D','E', 'E', 'F', 'F', 'G', 'G', 'H', 'H'];
    let i = arr.length - 1;
    for (; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
    }
    return arr;
  }

  toggleisFreshTry(){
    this.setState({isFirstTry : this.state.isFirstTry ? false : true});
  }

  setPrevious(a){
    this.setState({previous : a});
   
}

  decrementRemainingCount(){
    this.setState({remainingCount : this.state.remainingCount-1});
    if(this.state.remainingCount <= 1){
    }
   
  }

  updateScore(){
      let updatedScore = this.state.score - 5;
      this.setState({score: updatedScore});
  }

  updateClicksCount(){
    let clicks = this.state.clicksCount+1;
    this.setState({clicksCount: clicks});
  }

  resetCards(){
  
  let memoryFields = ['r'];
    return(
     <CardComp value={memoryFields[15]} isFreshTry={true} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(memoryFields[0])} previous='?' decrRemCount={() => this.decrementRemainingCount()} isReset="yes" />

    );

  }

  setPrevId(i){
    this.setState({prevId : i});
  }

  resetGame(){
    this.setState({
      isFirstTry : true,
      prevId: 0,
      previous : '?',
      remainingCount : 8,
      score: 1000,
      clicksCount: 0,
      isShuffleNeeded : true,
      memoryFields : this.permuteArray(),
    });
  }

  winningStatus(){
    if(this.state.remainingCount == 0){
      return (<h2 style={{color:"green", background:"lightgreen"}}> BINGO!!! YOU WON!!! </h2>);
    }
  }
  
  render(){
  
  return(

    <div className="row" style={{background:"lightred"}}>

      <div className = "col-sm-12"> {this.winningStatus()} </div>
      <CardComp value={this.state.memoryFields[0]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[0])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={0}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(0)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[1]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[1])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={1}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(1)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[2]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[2])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={2}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(2)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[3]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[3])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={3}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(3)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[4]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[4])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={4}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(4)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[5]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[5])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={5}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(5)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[6]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[6])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={6}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(6)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[7]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[7])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={7}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(7)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[8]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[8])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={8}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(8)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[9]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[9])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={9}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(9)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[10]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[10])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={10}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(10)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[11]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[11])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={11}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(11)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[12]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[12])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={12}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(12)} resetCardFields= {()=> this.resetGame()}/>
      <CardComp value={this.state.memoryFields[13]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[13])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={13}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(13)} resetCardFields= {()=> this.resetGame()}/>
        <CardComp value={this.state.memoryFields[14]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[14])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={14}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(14)} resetCardFields= {()=> this.setState({memoryFields : []})}/>
      <CardComp value={this.state.memoryFields[15]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()}
        setPrevious = {() => this.setPrevious(this.state.memoryFields[15])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={true}
        updateClicksCount={()=> this.updateClicksCount()} updateScore={()=>this.updateScore()} card_id={15}
        prevId = {this.state.prevId} setPrevId={()=> this.setPrevId(15)} resetCardFields= {()=> this.resetGame()}/>
      
      <div style={{background:"silver"}}>
        <div> <h3 className="col-sm-12"> SCORE: {this.state.score} </h3></div>
        <div> <h3 className="col-sm-12"> NUMBER OF CLICKS: {this.state.clicksCount} </h3> </div>
      </div>
    </div>

      );
}
}



