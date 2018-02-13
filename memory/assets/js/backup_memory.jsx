import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function init(root) {
  ReactDOM.render(<MainClass />, root);
}

class CardComp extends React.Component{
  constructor(props){
    super(props);
    this.state = { 
      displayValue : "?",
      actualValue : this.props.value,
      cardPlayable : true,
      classId: "cclass"
    };
  }

  updateCardState(dispVal, actVal, cardActive){
    this.setState({
                 displayValue : dispVal,
                 actualValue: actVal,
                 cardPlayable: cardActive,
    });
  }

  changeCardValue(isCorrectGuess){
    if(isCorrectGuess){
      $('.cclass > a:First > div:First > button:First ').html("DONE")
      //console.log($('.cclass').val());
    }
    else{
      $('.cclass > a:First > div:First > button:First ').html("?")
    }
    
  }

  toggleCardDisplay(){
    
    if(this.state.cardPlayable){
      if(this.props.isFreshTry){
        console.log("First try");
        // this.setState({displayValue : this.props.value});
        this.props.toggleFirstFlag();
       
        this.props.setPrevious(this.props.value);
          
        console.log(this.props.value);
        this.updateCardState(this.props.value, this.props.value, false);
      }
      else{
        let prevGuess = this.props.previous;
        console.log("Second try");
        if(this.props.previous == this.props.value){
          console.log("Match found");
         
          // this.updateCardState("DONE", this.props.value, false);
          this.props.decrRemCount();
         
          this.props.setPrevious("?");
         
          //this.changeCardValue(true);
          console.log("CHECK PREVIOUS ");
          console.log(prevGuess);

          this.updateCardState("DONE", this.props.value, false);
          $(".col-sm-3 > div > a > div > button:contains("+prevGuess+")").text('DONE')
        }
        else{
          let currentValue = this.props.value;
          console.log("CURRENT ");
          console.log(currentValue);
          
          this.props.setPrevious("?");
           $(".col-sm-3 > div > a > div > button:contains("+prevGuess+")").text('?')
           //this.updateCardState(this.props.value, this.props.value, true);
           $(".col-sm-3 > div > a > div > button:contains("+currentValue+")").text('M')
        }
        
        
        this.props.toggleFirstFlag();
        
      }
    
    }
      
    
  }


  resetCards(){
     $('.col-sm-3 > div > a > div > button').text('?');
  }

  addButton(){
    if(this.props.isLastCard){
      console.log("Last Card Status ");
      return(
         <Button className="btn btn-primary" onClick={this.resetCards.bind(this)}> RESET </Button>
        );
    }
    else{
      return(
        <p/>);
    }
  }

  render(){
    let classId = this.props.value;
    console.log("RESET STATUS : "+ this.props.isReset);
    if(this.props.isReset=="yes"){
        $('.col-sm-3 > div > a > div > button').text('?');
        console.log("render reset is reached ...");
      }

    return(

      <div className="col-sm-3">
        <div className="card cclass" style={{margin: 10, background:"yellow"}}>
          <a href = '#' onClick={this.toggleCardDisplay.bind(this)}>
            <div className="card-body">
              <button className="card-text" style={{padding: 20}}> {this.state.displayValue} </button>
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
      isSecondTry : false,
      previous : '?',
      remainingCount : 8,
    };
  }

  toggleisFreshTry(){
    console.log("Flag before toggle : " + this.state.isFirstTry);
    this.setState({isFirstTry : this.state.isFirstTry ? false : true});
    console.log("Flag toggled : " + this.state.isFirstTry);
  }

  setPrevious(a){
    console.log("BEFORE " + this.state.previous);
    this.setState({previous : a});
    console.log(this.state);
  }

  decrementRemainingCount(){
    this.setState({remainingCount : this.state.remainingCount-1});
    if(this.state.remainingCount <= 1){
      console.log("Match Won. BINGO !");
    }
    console.log("remaining count : "+ this.state.remainingCount);
  }

  resetCards(){
  console.log("reached resetCards()");
  let memoryFields = ['r'];
    return(
     <CardComp value={memoryFields[15]} isFreshTry={true} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[0])} previous='?' decrRemCount={() => this.decrementRemainingCount()} isReset="yes" />
    
    );
    
  }

  render(){
  let memoryFields = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H','A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  return(
    <div className="row">
      <CardComp value={memoryFields[0]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[0])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[1]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[1])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[2]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[2])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[3]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[3])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[4]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[4])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[5]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[5])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[6]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[6])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[7]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[7])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[8]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[8])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[9]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[9])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[10]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[10])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[11]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[11])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[12]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[12])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[13]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[13])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[14]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[14])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={false} />
      <CardComp value={memoryFields[15]} isFreshTry={this.state.isFirstTry} toggleFirstFlag={() => this.toggleisFreshTry()} 
        setPrevious = {() => this.setPrevious(memoryFields[15])} previous={this.state.previous} decrRemCount={() => this.decrementRemainingCount()} isLastCard={true} />
    </div>
  );
  }
}

 
