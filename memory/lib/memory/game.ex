defmodule Memory.Game do
  def new do
    %{
    previous: -1,
		matchesCount: 0,
		cards_list: getCardsList(),
		clicksCount: 87686,
		score: 765,
		sleepTraker: 1,
    }
  end

  def getCardsList(lst, cardId) do
  	arr = ["A", "B", "C", "D", "E", "F", "G", "H","A", "B", "C", "D", "E", "F", "G", "H"]
  	if cardId < 16 do
  		lst = lst ++ [%{id: cardId, actVal: Enum.at(arr, cardId), isShowable: false, isClickable: true}]
  		getCardsList(lst, cardId+1 )
  	else
  		lst
  	end
  end

  def getCardsList() do 
  	lst = []
  	getCardsList(lst, 0)
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
 	 updatedCardsList = Enum.map(lst, fn(x) -> %{actVal: x.actVal, id: x.id, isClickable: false, isShowable: x.isShowable} end)
 	 IO.puts("GOING TO SLEEP")
  	 #IO.inspect(updatedCardsList)
  	getCardsUpdatedGame(game, updatedCardsList)
  end

  def wakeFromSleep(game, cardId) do
  	 lst = game.cards_list
     cardId = get_parsed_value(cardId)
     previousId = get_parsed_value(game.previous)
     IO.inspect("PREVIOUSSSS ID")
     IO.inspect(previousId)
 	  updatedCardsList = Enum.map(lst, 
 	     fn(x) ->
 	     	cond do 
 	     	 x.isShowable and ((get_parsed_value(x.id) != cardId) or (get_parsed_value(x.id) != previousId)) ->
 	     		 %{actVal: x.actVal, id: x.id, isClickable: true, isShowable: x.isShowable}
 	     	 true ->
 	     		 %{actVal: x.actVal, id: x.id, isClickable: true, isShowable: false} 
 	 	    end 
 	 	end)

 	 IO.puts("WAKING from SLEEP")
  	 IO.inspect(updatedCardsList)
  	%{
        previous: game.previous,
      matchesCount: game.matchesCount,
      cards_list: updatedCardsList,
      clicksCount: game.clicksCount,
      score: game.score,
      sleepTraker: 0,
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
  	#IO.inspect("Inside handlerToggleDisplay : ")
  	#IO.inspect(cardId)
  	if cardId == %{} do
  		cardId = "0"
  	end
  	#IO.inspect(cardId)
  	updatedCardsList = game.cards_list;
  	#IO.inspect(updatedCardsList)
  	if(Enum.at(updatedCardsList, get_parsed_value(cardId)).isClickable) do
  		
	    %{
	  		previous: game.previous,
			matchesCount: game.matchesCount,
			cards_list: game.cards_list,
			clicksCount: game.clicksCount+1,
			score: game.score-10,
			sleepTraker: 0,
  		}  
  	else
  		IO.puts("IT IS UNCLICKABLE")
  	end
  end

   def handlerEquivalentCards(game, updatedCardsList, cardId) do
   		#IO.inspect("Woah equal cards...")
   		updatedCardsList = Enum.map(updatedCardsList, 
  		fn(x) -> if (x.id==cardId) do 
  		%{id: cardId, actVal: Enum.at(game.cards_list, cardId).actVal, isShowable: true, isClickable: false} else x end end)

		%{
	  		previous: -1,
			matchesCount: game.matchesCount+1,
			cards_list: updatedCardsList,
			clicksCount: game.clicksCount+1,
			score: game.score-10,
			sleepTraker: 0,
  		} 
	end
	
	def handlerNonEquivalentCards(game, updatedCardsList, cardId) do 
		updatedCardsList = Enum.map(game.cards_list, 
	  		fn(x) -> if get_parsed_value(x.id)==cardId do 
	  			%{id: cardId, actVal: Enum.at(game.cards_list,cardId).actVal, isShowable: true, isClickable: false} else x end end)
		%{	
	  		previous: -1,
			matchesCount: game.matchesCount,
			cards_list: updatedCardsList,
			clicksCount: game.clicksCount+1,
			score: game.score-10,
			sleepTraker: 1,
  		} 
	end


  def isEquivalentCard(game, updatedCardsList, cardId) do
  	#IO.puts("updatedCardsList ... ")
  	#IO.inspect(cardId)
  	#IO.inspect(game.previous)
  	if cardId == %{} do
  		cardId = "0"
  	end
  	IO.puts(Enum.at(updatedCardsList, 
  		get_parsed_value(cardId)).actVal == Enum.at(updatedCardsList, get_parsed_value(game.previous)).actVal)
  	Enum.at(updatedCardsList, get_parsed_value(cardId)).actVal == Enum.at(updatedCardsList, get_parsed_value(game.previous)).actVal
  end

  def handlerSecondCardClick(game, cardId) do
  	#IO.inspect("second card clickedddd..")
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
	  			%{id: cardId, actVal: Enum.at(game.cards_list,cardId).actVal, isShowable: true, isClickable: false} else x end end)

	  	if game.previous == -1 do
	  		IO.inspect("Entered this toggle display first case ");
	  		  		#IO.inspect("")
			#IO.inspect(updatedCardsList)
			game = %{
		  		previous: get_parsed_value(cardId),
				matchesCount: game.matchesCount,
				cards_list: updatedCardsList,
				clicksCount: game.clicksCount+1,
				score: game.score-10,
				sleepTraker: 0,
	  		}
        IO.inspect(game)
        game
	  	else
        IO.puts("SECOND CLICKKKK")
	  		game = handlerSecondCardClick(game, cardId)
        IO.inspect(game)
        game
	  	end
	else
			IO.puts("NON clockale")
	  		game
	end
  end

  def getCards(game, cardId) do
  	#IO.inspect("Inside Elixir get card")
  	#IO.inspect(cardId)
  	game.cards_list
  end
  
  def displayCard(game, cardId) do
  	#IO.inspect("REACHED ELIXIR BLOCK FOR CARD DISPLAY " );
  	#IO.inspect(cardId);
  	"CCC"
 	new()
  end

  def reset_view(game) do
  	new()
  end

end