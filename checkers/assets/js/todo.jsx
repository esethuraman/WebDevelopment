import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function todo_init(root) {
  ReactDOM.render(<Todo />, root);
}

// App state for Todo is:
//   { items: [List of TodoItem] }
//
// A TodoItem is:
//   { name: String, done: Bool }


class Todo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      items: this.getItems(),
    };
  }

  getItems(){
    let item_no = 0;
    let target_list = []
    for(; item_no < 64; item_no++){
      // console.log("Item number " + item_no);
      target_list.push(item_no);
    }
    return target_list;
  }


  getSingleCheckSquare(){
    return(
        <div className="card cclass" style={{background:"lightblue"}}>
          <button href = '#' isclickable="true" islocked="false">
            <div className="card-body">
                abc
            </div>
          </button>
        </div>
    );
  }

  getCards(){
      console.log("reached getCards ");
      return this.state.items.map((item, index) => (
        <div className="col-sm-3" key={index}>
            {this.getSingleCheckSquare()}
        </div>
        ));

  }

  render() {

    return (
      <div className="row">
          {this.getCards()}
      </div>
    );
  }
}
