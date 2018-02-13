import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function tictac_init(root) {
  ReactDOM.render(<Game />, root);
}


// for components that are very simple, declare them as functional components.
// pass props as an argument. so no more this.props. use props instead
function Square(props){
    return (
      <button className="square" onClick={this.props.onClick()}>
        {props.val}
      </button>
    );
}

class Board extends React.Component {
  constructor(props){
	super(props);
	this.state = { squares : [null, null, null, null, null, null, null, null, null],
			xNext : true };

  }

  handleClick(i){
	let tmp = this.state.squares.slice();
	tmp[i] = this.state.xNext ? 'X' : 'O';
	this.setState({squares : tmp,
			xNext : !this.state.xNext, });
  }

  renderSquare(i) {
    return <
	Square val={this.state.squares[i]}
	 onClick={() => this.handleClick(i)}
	/>;
  }

  render() {
    let nextPlayer = this.state.xNext ? 'X' : 'O' ;
    let status = "Next Player : " + nextPlayer;
    return (
      <div>
        <div className="status">{status}</div>
        <div className="board-row">
          {this.renderSquare(0)}
          {this.renderSquare(1)}
          {this.renderSquare(2)}
        </div>
        <div className="board-row">
          {this.renderSquare(3)}
          {this.renderSquare(4)}
          {this.renderSquare(5)}
        </div>
        <div className="board-row">
          {this.renderSquare(6)}
          {this.renderSquare(7)}
          {this.renderSquare(8)}
        </div>
      </div>
    );
  }
}

class Game extends React.Component {
  render() {
    return (
      <div className="game">
        <div className="game-board">
          <Board />
        </div>
        <div className="game-info">
          <div>{/* status */}</div>
          <ol>{/* TODO */}</ol>
        </div>
      </div>
    );
  }
}

