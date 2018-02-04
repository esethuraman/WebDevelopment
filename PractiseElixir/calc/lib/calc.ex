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
      optrs_local = stack_map.optrs
      optrs_local = tl optrs_local
      %{stack_map | optrs: optrs_local}
    else
      stack_map = subs_expr(stack_map)
      handler_close_parath(stack_map)
    end
  end

  def get_evaluated_term(stack_map, op1, op2, optr) do 
      cond do 
       optr == "/" -> push_opnd(stack_map, div(op2, op1))
       optr == "*" -> push_opnd(stack_map, (op2 * op1))
       optr == "-" -> push_opnd(stack_map, (op2 - op1))
       optr == "+" -> push_opnd(stack_map, (op2 + op1))
       true -> IO.puts("default") 
      end 
  end

  def subs_expr(stack_map) do
    
    opnds_local = stack_map.opnds
    
    o1 = List.first(opnds_local)
    stack_map = %{stack_map | opnds: tl opnds_local}
    opnds_local = stack_map.opnds
    
    o2 = List.first(stack_map.opnds)
    stack_map = %{stack_map | opnds: tl opnds_local}
        
    optr = List.first(stack_map.optrs)
    optrs_local = stack_map.optrs
    stack_map = %{stack_map | optrs: (tl optrs_local)}
    
    op1 = get_parsed_value(o1)
    op2 = get_parsed_value(o2)
    
    get_evaluated_term(stack_map, op1, op2, optr) 
    
  end

  def push_opnd(stack_map, el) do
    updated_opnds = [to_string(el)] ++ stack_map.opnds
    %{stack_map | "opnds": updated_opnds}
  end

  def push_optr(stack_map, el) do
      updated_optrs = [to_string(el)] ++ stack_map.optrs
      %{stack_map | optrs: updated_optrs}
  end

  def get_top_from_stack(stack) do
    if (length stack.optrs)==0 do
      nil
    else
      List.first(stack.optrs)
    end
  end

  def get_low_pri_optrs() do
    ["+", "-"]
  end

  def get_hi_pri_optrs() do
    ["*", "/"]
  end
  
  def handler_low_pri_optrs(stack_map, el, v_top) do
    cond do
     v_top == nil ->
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]

     Enum.member?(get_low_pri_optrs, v_top) ->
      stack_map = subs_expr(stack_map)
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]
    
     Enum.member?(get_hi_pri_optrs, v_top) ->
      # evaluate
      stack_map = subs_expr(stack_map, el, get_hi_pri_optrs)
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]
    end
  end
  
  def handler_hi_pri_optrs(stack_map, el, v_top) do
    
    if Enum.member?(get_hi_pri_optrs, v_top) do
      stack_map = subs_expr(stack_map)
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]
    
    else  
      optrs_local = [el] ++ stack_map.optrs 
      [ %{stack_map | optrs: optrs_local} , get_top_from_stack(stack_map) ]
    end
  end 
  
  def handler_operators(stack_map, el, v_top, hi_pri, low_pri) do
    cond do 
      String.contains?(el, "(") ->
        stack_map = push_optr(stack_map, el)
        v_top = nil

      String.contains?(el, ")") -> 
        stack_map = handler_close_parath(stack_map)
        v_top = get_top_from_stack(stack_map)

      Enum.member?(hi_pri, el) ->
        result = handler_hi_pri_optrs(stack_map, el, v_top)            
        stack_map = Enum.at(result, 0)
        v_top = Enum.at(result, 1)

      Enum.member?(low_pri, el) ->
        result = handler_low_pri_optrs(stack_map, el, v_top)            
        stack_map = Enum.at(result, 0)
        v_top = Enum.at(result, 1)
    end
    [stack_map, v_top]
  end 
  
  def get_all_optrs() do 
    [")", "+", "-", "/", "*", "("]
  end
  
  def handler_lst_elements(lst, stack_map, v_top) do
    el = List.first(lst)
  
    if Enum.member?(get_all_optrs(), el) do
        result = handler_operators(stack_map, el, v_top, get_hi_pri_optrs, get_low_pri_optrs)
        stack_map = Enum.at(result, 0)
        v_top = Enum.at(result, 1)

      else
        opnds_local = [el] ++ stack_map.opnds
        stack_map = %{stack_map | opnds: opnds_local}         
      end
      [stack_map, v_top]
  end 
  
  def evaluate(lst, stack_map, v_top) do
    IO.inspect(stack_map)
    IO.inspect(v_top)

    if ((length lst) == 0) do
      stack_map
    
    else
      el = List.first(lst)
      result = handler_lst_elements(lst, stack_map, v_top)
      stack_map = Enum.at(result, 0)
      v_top = Enum.at(result, 1)
      
      lst = tl lst
      evaluate(lst, stack_map, v_top)
    end
  end

  def empty_the_stack(stack) do
    if (length stack.optrs)==0 do
      List.first(stack.opnds)
    else 
      empty_the_stack(subs_expr(stack))
    end
  end

  def process_expression(exp) do
    
    exp = Regex.replace(~r/\(/, exp, "( ")
    Regex.replace(~r/\)/, exp, " )")
  end
  
  def main() do 
    
    exp = IO.gets("Enter expression ")
    |> process_expression
    
    lst = Enum.map(String.split(exp, " "), fn(x) -> String.trim(x) end) 
    lst = Enum.filter(lst, fn(x) -> String.length(x) > 0 end)
    
    stack_map = %{opnds: [], optrs: []}
    result_stack = evaluate(lst, stack_map, nil)
 
    IO.puts(empty_the_stack(result_stack))
    main()
  end

  def hello do 
    :world
  end
end
