defmodule OddEven do
  @moduledoc """
  Documentation for OddEven.
  """

  @doc """
  Hello world.

  ## Examples

      iex> OddEven.hello
      :world

  """
  def get_parsed_value(val) do
    if is_binary(val) do
      String.to_integer(val)
    else
      val
    end
  end
  
  def subs_expr(stack_map) do
    
    IO.inspect("inpection in subs_expr:")
    IO.inspect(stack_map)
    opnds_local = stack_map.opnds
    IO.inspect("opnds_local")
    IO.inspect(opnds_local)

    o1 = List.first(opnds_local)
    stack_map = %{stack_map | opnds: tl opnds_local}
    opnds_local = stack_map.opnds
    IO.inspect("stack after first pop")
    IO.inspect(stack_map)
    
    o2 = List.first(stack_map.opnds)
    stack_map = %{stack_map | opnds: tl opnds_local}
    IO.inspect("stack after second pop")
    IO.inspect(stack_map)
        
    optr = List.first(stack_map.optrs)
    optrs_local = stack_map.optrs
    stack_map = %{stack_map | optrs: (tl optrs_local)}
    
    

    #optr = IO.gets("enter optr ") |> String.trim
    #IO.puts("O1 #{o1}")
    #IO.puts("O2 #{o2}")
    IO.inspect("CHECK " )
    IO.inspect(o1)
    IO.inspect(o2)
    op1 = get_parsed_value(o1)
    op2 = get_parsed_value(o2)
    IO.puts("CEHCKE FOR OTHERS")
    IO.inspect("#{op1} #{op2} #{optr}")
    #IO.puts("OPTR inside subs_expr : #{o1} #{o2}")
    val = (op2 + op1)
    IO.inspect(val)
    cond do 
     optr == "/" -> stack_map = push_opnd(stack_map, div(op2, op1))
     optr == "*" -> stack_map = push_opnd(stack_map, (op2 * op1))
     optr == "-" -> stack_map = push_opnd(stack_map, (op2 - op1))
     optr == "+" -> stack_map = push_opnd(stack_map, (op2 + op1))
     #IO.puts("Div #{op2 / op1}")
     true -> IO.puts("default") 
    end 
    IO.puts("AFTER PUSHING ")
    IO.inspect(stack_map)

    stack_map
    
  end

  def push_opnd(stack_map, el) do
    IO.inspect("Element before pushing in to stack :")
    IO.inspect(el)
    updated_opnds = [to_string(el)] ++ stack_map.opnds
    %{stack_map | "opnds": updated_opnds}
  end

  def push_optr(stack_map, el) do
    updated_optrs = [el] ++ stack_map.optrs
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
      IO.inspect("first in stack : ")
      f
    end
    
  end

  def evaluate(lst, stack_map, v_top) do
    all_optrs = [")", "+", "-", "/", "*"]
    hi_pri = ["/", "*"]
    low_pri = ["+", "-"]

    if ((length lst) == 0) do
      IO.puts("finally ")
      IO.inspect(stack_map)
    else
      #IO.puts("foremost opnds : " )
      #IO.inspect(stack_map.opnds)
      el = List.first(lst)
      IO.puts("First element is #{el}")
      if Enum.member?(all_optrs, el) do
        #IO.puts("REACHED IF #{el}")
        #optrs = handle_operators(optrs, hi_pri, low_pri, el)
        cond do 
          Enum.member?(hi_pri, el) ->
            optrs_local = [el] ++ stack_map.optrs 
            stack_map = %{stack_map | optrs: optrs_local}
            v_top = el
          Enum.member?(low_pri, el) ->
            #IO.puts("V_top #{v_top}")
            cond do
             v_top == nil ->
              stack_map = push_optr(stack_map, el)

             Enum.member?(low_pri, v_top) ->
              optrs_local = [el] ++ stack_map.optrs 
              stack_map = %{stack_map | optrs: optrs_local}
              v_top = el
            
              Enum.member?(hi_pri, v_top) ->
                # evaluate
                #IO.puts("reached inside handler block as expected")
                #opnds = subs_expr(opnds, optrs)
                stack_map = subs_expr(stack_map)
                v_top = get_top_from_stack(stack_map)

                #IO.inspect("evaluated stack")
                #IO.inspect(stack_map)
                opnds_local = stack_map.opnds
                
                # callig function without decrementing the list coz i dint push oprtr yet
                evaluate(lst, stack_map, v_top)
                #IO.inspect(opnds_local)
                
                # after solving add the queued operator in to stack
                #stack_map =  push_optr(stack_map.optrs, el)
                
                # for a closing paranethesis
                #true -> pop_elements()
            end
        end
      else
        opnds_local = [el] ++ stack_map.opnds
        stack_map = %{stack_map | opnds: opnds_local}
        
        #IO.puts("final")
      end

      lst = tl lst
      IO.puts("OPNDS")  
      IO.inspect(stack_map.optrs)
      evaluate(lst, stack_map, v_top)
    end
  end

  def empty_the_stack(stack) do
    optrs_local = stack.optrs
    opnds_local = stack.opnds
    
    if (length optrs_local)==0 do
      List.first(opnds_local)
    else 
      empty_the_stack(subs_expr(stack))
    end
  end

  def main do 
    lst = [1,2,3,4,5,6,7,8,9]
    odds = []
    evens = []
    #seggregate(lst, odds, evens)
    exp = IO.gets("Enter expression ")
    #lst = String.split(exp, " ")
    lst = String.split("4 + 3 * 4 + 3 * 5", " ")
    opnds_lst = []
    optrs_lst = []
    stack_map = %{opnds: optrs_lst, optrs: optrs_lst}
    result_stack = evaluate(lst, stack_map, "+")
    IO.puts("RESULT "   )
    IO.inspect(result_stack)
    empty_the_stack(result_stack)
  end

  
end
