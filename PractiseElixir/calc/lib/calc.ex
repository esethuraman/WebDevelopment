defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Calc.hello
      :world

  """
  def get_parsed_value(val) do
    if is_binary(val) do
      String.to_integer(val)
    else
      val
    end
  end
  
  def subs_expr(stack_map, optr, hi_pri) do
    top = stack_map.optrs |> List.first
    if Enum.member?(hi_pri, top) do
      stack_map =  subs_expr(stack_map)
      subs_expr(stack_map, optr, hi_pri)
    else
      stack_map 
    end
  end

  def handler_close_parath(stack_map) do
    top = stack_map.optrs |> List.first
    if top == "(" do
      IO.inspect(" inside open paranethesis ")
      IO.inspect(" stack before removal : ")
      IO.inspect(stack_map)
      optrs_local = stack_map.optrs
      optrs_local = tl optrs_local
      stack_map = %{stack_map | optrs: optrs_local}
      IO.inspect(" stack after removal : ")
      IO.inspect(stack_map)

    else
      IO.puts("debug ---->")
      IO.inspect(stack_map)
      stack_map = subs_expr(stack_map)
      handler_close_parath(stack_map)
    end
  end

  def subs_expr(stack_map) do
    
    #IO.inspect("inpection in subs_expr:")
    #IO.inspect(stack_map)
    opnds_local = stack_map.opnds
    #IO.inspect("opnds_local")
    #IO.inspect(opnds_local)

    o1 = List.first(opnds_local)
    stack_map = %{stack_map | opnds: tl opnds_local}
    opnds_local = stack_map.opnds
    #IO.inspect("stack after first pop")
    #IO.inspect(stack_map)
    
    o2 = List.first(stack_map.opnds)
    stack_map = %{stack_map | opnds: tl opnds_local}
    #IO.inspect("stack after second pop")
    #IO.inspect(stack_map)
        
    optr = List.first(stack_map.optrs)
    optrs_local = stack_map.optrs
    stack_map = %{stack_map | optrs: (tl optrs_local)}
    
    

    #optr = IO.gets("enter optr ") |> String.trim
    op1 = get_parsed_value(o1)
    op2 = get_parsed_value(o2)
    val = (op2 + op1)
    
    cond do 
     optr == "/" -> stack_map = push_opnd(stack_map, div(op2, op1))
     optr == "*" -> stack_map = push_opnd(stack_map, (op2 * op1))
     optr == "-" -> stack_map = push_opnd(stack_map, (op2 - op1))
     optr == "+" -> stack_map = push_opnd(stack_map, (op2 + op1))
     true -> IO.puts("default") 
    end 
    IO.puts("AFTER PUSHING ")
    #IO.inspect(stack_map)

    stack_map
    
  end

  def push_opnd(stack_map, el) do
    updated_opnds = [to_string(el)] ++ stack_map.opnds
    %{stack_map | "opnds": updated_opnds}
  end

  def push_optr(stack_map, el) do
    IO.inspect("inside push optr ")
    IO.inspect(stack_map)
    IO.inspect(el)
    updated_optrs = [to_string(el)] ++ stack_map.optrs
    %{stack_map | optrs: updated_optrs}
  end

  
  def pop_elements() do
    IO.puts("TODO")
  end

  def handle_operators(optrs,hi_pri, low_pri, el) do
    v_top = "_"
    cond do 
      Enum.member?(hi_pri, el) ->
        [el] ++ optrs 
        v_top = el
      Enum.member?(low_pri, el) ->
        if Enum.member?(low_pri, v_top) do
          [el] ++ optrs 
          v_top = el
        else
          # evaluate
          [el] ++ optrs 
      
        end
    end
  end

  def get_top_from_stack(stack) do
    optrs_local = stack.optrs
    if (length optrs_local)==0 do
      nil
    else
      f = List.first(optrs_local)
      f
    end
    
  end

  def evaluate(lst, stack_map, v_top) do
    all_optrs = [")", "+", "-", "/", "*", "("]
    hi_pri = ["/", "*"]
    low_pri = ["+", "-"]

    if ((length lst) == 0) do
      IO.puts("finally ")
      IO.inspect(stack_map)
      #evaluate([], stack_map, v_top)
      stack_map
    
    else
      #IO.inspect("Start of the evaluation ")
      ##IO.inspect(v_top)
      #IO.inspect(stack_map)
      
      #IO.inspect("List and its contents ")
      #IO.inspect(lst)
      #IO.inspect(el)     
      el = List.first(lst)
      if Enum.member?(all_optrs, el) do
        #IO.inspect("Successfully entered where it has to")
        #optrs = handle_operators(optrs, hi_pri, low_pri, el)
        cond do 
          String.contains?(el, "(") ->
            #IO.puts("at least reached here")
            stack_map = push_optr(stack_map, el)
            v_top = nil

          String.contains?(el, ")") -> 
            #IO.puts("reached close parantheses section too ")
            stack_map = handler_close_parath(stack_map)

          Enum.member?(hi_pri, el) ->
            if Enum.member?(hi_pri, v_top) do
              stack_map = subs_expr(stack_map)
              v_top = get_top_from_stack(stack_map)
            else  
              optrs_local = [el] ++ stack_map.optrs 
              stack_map = %{stack_map | optrs: optrs_local}
              v_top = el
            end

          Enum.member?(low_pri, el) ->
            cond do
             v_top == nil ->
              stack_map = push_optr(stack_map, el)
              v_top = get_top_from_stack(stack_map)

             Enum.member?(low_pri, v_top) ->
              stack_map = subs_expr(stack_map)
              stack_map =  push_optr(stack_map, el)
              #optrs_local = [el] ++ stack_map.optrs 
              #stack_map = %{stack_map | optrs: optrs_local}
              v_top = get_top_from_stack(stack_map)
            
              Enum.member?(hi_pri, v_top) ->
                # evaluate
                stack_map = subs_expr(stack_map, el, hi_pri)
                v_top = get_top_from_stack(stack_map)

                opnds_local = stack_map.opnds
                
                # calling function without decrementing the list coz i dint push oprtr yet
                # evaluate(lst, stack_map, v_top)
                
                # after solving add the queued operator in to stack
                #IO.puts("lemme see the ele :")
                #IO.inspect(stack_map)
                stack_map =  push_optr(stack_map, el)
                v_top = get_top_from_stack(stack_map)

                # for a closing paranethesis
                #true -> pop_elements()

            end
            
        end

      else
        IO.puts("reached here instead ")
        opnds_local = [el] ++ stack_map.opnds
        stack_map = %{stack_map | opnds: opnds_local}
        
        #IO.puts("final")
      
         
      end
      lst = tl lst
      IO.puts("Reached end OPTRS")  
      IO.inspect(stack_map.optrs)
      evaluate(lst, stack_map, v_top)
    end
  end

  def empty_the_stack(stack) do
    optrs_local = stack.optrs
    opnds_local = stack.opnds
    IO.inspect("Inside empty_the_stack fn ")
    IO.inspect(optrs_local)
    IO.inspect(opnds_local)

    if (length optrs_local)==0 do
      List.first(opnds_local)
    else 
      empty_the_stack(subs_expr(stack))
    end
  end

  def main do 
    IO.puts("YOU CAN DO ")
    lst = [1,2,3,4,5,6,7,8,9]
    odds = []
    evens = []
    #seggregate(lst, odds, evens)
    exp = IO.gets("Enter expression ")
    lst = Enum.map(String.split(exp, " "), fn(x) -> String.trim(x) end) 
    #lst = String.split("4 + 3 * 4 - 3 * 5", " ")
    opnds_lst = []
    optrs_lst = []
    stack_map = %{opnds: optrs_lst, optrs: optrs_lst}
    result_stack = evaluate(lst, stack_map, nil)
    IO.puts("RESULT "   )
    IO.inspect(result_stack)
    empty_the_stack(result_stack)
  end

  
end
