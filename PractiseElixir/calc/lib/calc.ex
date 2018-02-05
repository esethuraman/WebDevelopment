defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

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

  def get_all_optrs() do 
    [")", "+", "-", "/", "*", "("]
  end

  def get_low_pri_optrs() do
    ["+", "-"]
  end

  def get_hi_pri_optrs() do
    ["*", "/"]
  end
  

  def get_parsed_value(val) do
    if is_binary(val) do
      String.to_integer(val)
    else
      val
    end
  end
  
  def simplify_expr(stack_map, optr, hi_pri) do
    if Enum.member?(hi_pri, stack_map.optrs |> List.first) do
      simplify_expr(stack_map)
      |> (&simplify_expr(&1, optr, hi_pri)).()
    else
      stack_map 
    end
  end

  def handler_close_parath(stack_map) do
    
    if stack_map.optrs |> List.first == "(" do
      %{stack_map | optrs: (tl stack_map.optrs)}
    else
      simplify_expr(stack_map)
      |> handler_close_parath
    end
  end

  def get_evaluated_term(stack_map, op1, op2, optr) do 
      cond do 
       optr == "/" -> push_opnd(stack_map, div(op2, op1))
       optr == "*" -> push_opnd(stack_map, (op2 * op1))
       optr == "-" -> push_opnd(stack_map, (op2 - op1))
       optr == "+" -> push_opnd(stack_map, (op2 + op1)) 
      end 
  end

  def simplify_expr(stack_map) do
    
    o1 = List.first(stack_map.opnds)
    stack_map = %{stack_map | opnds: tl stack_map.opnds}
    
    o2 = List.first(stack_map.opnds)
    stack_map = %{stack_map | opnds: tl stack_map.opnds}
        
    optr = List.first(stack_map.optrs)
    stack_map = %{stack_map | optrs: (tl stack_map.optrs)}
    
    get_evaluated_term(stack_map, get_parsed_value(o1), get_parsed_value(o2), optr) 
    
  end

  def handler_low_pri_optrs(stack_map, el, v_top) do
    cond do
     v_top == nil ->
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]

     Enum.member?(get_low_pri_optrs(), v_top) ->
      stack_map = simplify_expr(stack_map)
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]
    
     Enum.member?(get_hi_pri_optrs(), v_top) ->
      # evaluate
      stack_map = simplify_expr(stack_map, el, get_hi_pri_optrs())
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]
    end
  end
  
  def handler_hi_pri_optrs(stack_map, el, v_top) do
    
    if Enum.member?(get_hi_pri_optrs(), v_top) do
      stack_map = simplify_expr(stack_map)
      [ push_optr(stack_map, el), get_top_from_stack(stack_map) ]
    
    else  
      optrs_local = [el] ++ stack_map.optrs 
      [ %{stack_map | optrs: optrs_local} , get_top_from_stack(stack_map) ]
    end
  end 
  
  def handler_operators(stack_map, el, v_top, hi_pri, low_pri) do
    cond do 
      String.contains?(el, "(") ->
        [push_optr(stack_map, el), nil]
        
      String.contains?(el, ")") -> 
        stack_map = handler_close_parath(stack_map)
        v_top = get_top_from_stack(stack_map)
        [stack_map, v_top]

      Enum.member?(hi_pri, el) ->
        result = handler_hi_pri_optrs(stack_map, el, v_top)            
        [Enum.at(result, 0), Enum.at(result, 1)]

      Enum.member?(low_pri, el) ->
        result = handler_low_pri_optrs(stack_map, el, v_top)            
        [Enum.at(result, 0), Enum.at(result, 1)]
    end
  end 
  
  def handler_lst_elements(lst, stack_map, v_top) do
    el = List.first(lst)
  
    if Enum.member?(get_all_optrs(), el) do
        result = handler_operators(stack_map, el, v_top, get_hi_pri_optrs(), get_low_pri_optrs())
        [ Enum.at(result, 0), Enum.at(result, 1) ]

      else
        opnds_local = [el] ++ stack_map.opnds
        [ %{stack_map | opnds: opnds_local}, v_top ]         
      end
  end 
  
  def evaluate(lst, stack_map, v_top) do
    
    if ((length lst) == 0) do
      stack_map
    
    else
      result = handler_lst_elements(lst, stack_map, v_top)
      (tl lst)
      |> (&evaluate(&1, Enum.at(result, 0), Enum.at(result, 1))).()
    end
  end

  def empty_the_stack(stack) do
    if (length stack.optrs)==0 do
      List.first(stack.opnds)
    else 
      empty_the_stack(simplify_expr(stack))
    end
  end

  def process_expression(exp) do
    Regex.replace(~r/\(/, exp, "( ")
    |> (
      &Regex.replace(~r/\)/, &1, " )")).()
  end
  
  def eval(exp) do
    exp = process_expression(exp)
    
    lst = Enum.map(String.split(exp, " "), fn(x) -> String.trim(x) end) 
    lst = Enum.filter(lst, fn(x) -> String.length(x) > 0 end)
    
    result_stack = %{opnds: [], optrs: []}
    |> (&evaluate(lst, &1, nil)).()
    
    empty_the_stack(result_stack)
    |> get_parsed_value

  end

  def main() do 
    IO.gets("Enter expression ")
    |> eval
    |> IO.puts  
    main()
  end

  def hello do 
    :world
  end
end
