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
  
  def pop_elements() do
    IO.puts("TODO")
  end

  def get_top_from_stack(stack) do
    if (length stack.optrs)==0 do
      nil
    else
      List.first(stack.optrs)
    end
  end

  def evaluate(lst, stack_map, v_top) do
    IO.inspect(stack_map)
    IO.inspect(v_top)
    all_optrs = [")", "+", "-", "/", "*", "("]
    hi_pri = ["/", "*"]
    low_pri = ["+", "-"]

    if ((length lst) == 0) do
      stack_map
    
    else
      el = List.first(lst)

      if Enum.member?(all_optrs, el) do
        cond do 
          String.contains?(el, "(") ->
            stack_map = push_optr(stack_map, el)
            v_top = nil

          String.contains?(el, ")") -> 
            stack_map = handler_close_parath(stack_map)
            v_top = get_top_from_stack(stack_map)

          Enum.member?(hi_pri, el) ->
            if Enum.member?(hi_pri, v_top) do
              stack_map = subs_expr(stack_map)
              stack_map =  push_optr(stack_map, el)
              v_top = get_top_from_stack(stack_map)
            else  
              optrs_local = [el] ++ stack_map.optrs 
              stack_map = %{stack_map | optrs: optrs_local}
              v_top = get_top_from_stack(stack_map)
            end

          Enum.member?(low_pri, el) ->
            cond do
             v_top == nil ->
              stack_map = push_optr(stack_map, el)
              v_top = get_top_from_stack(stack_map)

             Enum.member?(low_pri, v_top) ->
              stack_map = subs_expr(stack_map)
              stack_map =  push_optr(stack_map, el)
              v_top = get_top_from_stack(stack_map)
            
              Enum.member?(hi_pri, v_top) ->
                # evaluate
                stack_map = subs_expr(stack_map, el, hi_pri)
                ##v_top = get_top_from_stack(stack_map)

                #opnds_local = stack_map.opnds
                stack_map =  push_optr(stack_map, el)
                v_top = get_top_from_stack(stack_map)    
            end            
        end

      else
        opnds_local = [el] ++ stack_map.opnds
        stack_map = %{stack_map | opnds: opnds_local}
             
      end

      lst = tl lst
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
    
    #IO.puts("AT THE END..")
    IO.puts(empty_the_stack(result_stack))
    main()
  end

  def hello do 
    :world
  end
end
