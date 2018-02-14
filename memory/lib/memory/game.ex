defmodule Memory.Game do
  def new do
    %{
    previous: -1,
		matchesCount: 0,
		cards_list: getCardsList(),
		clicksCount: 0,
		score: 1600,
		sleepTraker: 1,
    }
  end

  def getCardsList(arr, lst, cardId) do
  	if cardId < 16 do
  		lst = lst ++ [%{id: cardId, actVal: Enum.at(arr, cardId), isShowable: false, isClickable: true, isMatched: false}]
  		getCardsList(arr, lst, cardId+1 )
  	else
  		lst
  	end
  end

  def getCardsList() do
    arr = ~w[A B C D E F G H A B C D E F G H] |> Enum.shuffle
  	lst = []
  	getCardsList(arr, lst, 0)
  end

  def client_view(game) do
  	%{
  		previous: game.previous,
		matchesCount: game.matchesCount,
		cards_list: game.cards_list,
		clicksCount: game.clicksCount,
		score: game.score,
		sleepTraker: game.sleepTraker,
  	}
  end

  def incrementClicksCount(game) do
	%{
  		previous: game.previous,	
		matchesCount: game.matchesCount,
		cards_list: game.cards_list,
		clicksCount: game.clicksCount+1,
		score: game.score,
		sleepTraker: 0,
  	}  
  end


  def get_parsed_value(val) do
    if is_binary(val) do
      String.to_integer(val)
    else
    	if(val == %{}) do
    		String.to_integer("0")
    	else
      		val
      	end
    end
  end

  

  def goToSleep(game) do 

  	 lst = game.cards_list
 	 updatedCardsList = Enum.map(lst, 
   fn(x) -> %{actVal: x.actVal, id: x.id, isClickable: false, isShowable: x.isShowable, isMatched: x.isMatched} end)

  	getCardsUpdatedGame(game, updatedCardsList)
  end

  def wakeFromSleep(game) do
    updatedCardsList = Enum.map(game.cards_list,
      fn(x) -> 
        if x.isMatched do
          x
        else
          %{actVal: x.actVal, id: x.id, isClickable: true, isShowable: false, isMatched: x.isMatched}
        end end)
      %{
        previous: -1,
        matchesCount: game.matchesCount,
        cards_list: updatedCardsList,
        clicksCount: game.clicksCount,
        score: game.score,
        sleepTraker: 1,
      } 

  end

  def wakeFromSleepDEL(game, cardId) do
  	 lst = game.cards_list
     cardId = get_parsed_value(cardId)
     previousId = get_parsed_value(game.previous)
    
 	  updatedCardsList = Enum.map(lst, 
 	     fn(x) ->
        current = (get_parsed_value(x.id))
 	     	if (x.isShowable and ((current != cardId) and (current != previousId))) do
 	     		 %{actVal: x.actVal, id: x.id, isClickable: false, isShowable: true, isMatched: false}
 	     	 else
 	     		 %{actVal: x.actVal, id: x.id, isClickable: true, isShowable: false, isMatched: false} 
 	 	    end 
 	 	end)

  	%{
        previous: -1,
      matchesCount: game.matchesCount,
      cards_list: updatedCardsList,
      clicksCount: game.clicksCount,
      score: game.score,
      sleepTraker: 1,
      } 
  end
	
  def getCardsUpdatedGame(game, updatedCardsList) do
  		%{
	  		previous: game.previous,
			matchesCount: game.matchesCount,
			cards_list: updatedCardsList,
			clicksCount: game.clicksCount,
			score: game.score,
			sleepTraker: game.sleepTraker,
  		} 
  end

  def handlerToggleDisplay(game, cardId) do
  	
  	if cardId == %{} do
  		cardId = "0"
  	end
  	updatedCardsList = game.cards_list;
  	if(Enum.at(updatedCardsList, get_parsed_value(cardId)).isClickable) do
  		
	    %{
	  		previous: game.previous,
			matchesCount: game.matchesCount,
			cards_list: game.cards_list,
			clicksCount: game.clicksCount+1,
			score: game.score-10,
			sleepTraker: 1,
  		}  
  	else
  		IO.puts("IT IS UNCLICKABLE")
  	end
  end

   def handlerEquivalentCards(game, updatedCardsList, cardId) do
   		
      cardId = get_parsed_value(cardId)
      previousId = get_parsed_value(game.previous)
   		updatedCardsList = Enum.map(updatedCardsList, 
  		fn(x) -> if (x.id==cardId) or (x.id==previousId) do 
  		%{id: cardId, actVal: x.actVal, isShowable: true, isClickable: false, isMatched: true} else x end end)

		%{
	  		previous: -1,
			matchesCount: game.matchesCount+1,
			cards_list: updatedCardsList,
			clicksCount: game.clicksCount+1,
			score: game.score-10,
			sleepTraker: 1,
  		} 
	end
	
	def handlerNonEquivalentCards(game, updatedCardsList, cardId) do 
		updatedCardsList = Enum.map(game.cards_list, 
	  		fn(x) -> if get_parsed_value(x.id)==cardId do 
	  			%{id: x.id, actVal: x.actVal, isShowable: true, isClickable: false, isMatched: x.isMatched} else x end end)
		%{	
	  		previous: -1,
			matchesCount: game.matchesCount,
			cards_list: updatedCardsList,
			clicksCount: game.clicksCount+1,
			score: game.score-10,
			sleepTraker: 0,
  		} 
	end


  def isEquivalentCard(game, updatedCardsList, cardId) do
  	
  	if cardId == %{} do
  		cardId = "0"
  	end
  	
  	Enum.at(updatedCardsList, get_parsed_value(cardId)).actVal == Enum.at(updatedCardsList, get_parsed_value(game.previous)).actVal
  end

  def handlerSecondCardClick(game, cardId) do
  	updatedCardsList = game.cards_list
  	if isEquivalentCard(game, updatedCardsList, cardId) do
  		handlerEquivalentCards(game, updatedCardsList, cardId)
  	else
  		handlerNonEquivalentCards(game, updatedCardsList, cardId)
  	end
  end


  def toggleDisplay(game, cardId) do
  	if Enum.at(game.cards_list, get_parsed_value(cardId)).isClickable == true do
	  	cardId = get_parsed_value(cardId)	
	  	updatedCardsList = Enum.map(game.cards_list, 
	  		fn(x) -> if get_parsed_value(x.id)==cardId do 
	  			%{id: cardId, actVal: 
          Enum.at(game.cards_list,cardId).actVal, isShowable: true, isClickable: false, isMatched: x.isMatched} else x end end)

	  	if game.previous == -1 do
	  		
  			game = %{
  		  		previous: get_parsed_value(cardId),
  				matchesCount: game.matchesCount,
  				cards_list: updatedCardsList,
  				clicksCount: game.clicksCount+1,
  				score: game.score-10,
  				sleepTraker: 1,
  	  		}
        game
	  	else
	  		game = handlerSecondCardClick(game, cardId)
        game
	  	end
	else
	  		game
	end
  end

  def getGameState(game) do 
    game
  end

  def reset_view(game) do
  	new()
  end

end