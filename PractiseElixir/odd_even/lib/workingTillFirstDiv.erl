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
  
  def subs_expr(opnds, optrs) do
    #{o1, _} = List.pop_at(opnds, 0)
    #{o2, _} = List.pop_at(opnds, 0)
    #optr = List.pop_at(optrs, 0) 
    o1 = List.first(opnds)
    opnds = tl opnds
    o2 = List.first(opnds)
    opnds = tl opnds
    optr = List.first(optrs)
    optrs = tl optrs
    IO.puts("OPTR inside subs_expr : #{o1} #{o2}")

    #optr = IO.gets("enter optr ") |> String.trim
    IO.puts("O1 #{o1}")
      IO.puts("O2 #{o2}")
    {op1, _} = Integer.parse(o1) 
    {op2, _} = Integer.parse(o2)
    
    cond do 
      optr == "/" -> IO.puts("Div #{op2 / op1}")
      true -> IO.puts("default") 
    end 
    #case {:ok, optr} do 
    #  {:ok, "+"} -> IO.puts("Plus #{op2 + op1}")
    #  {:ok, "-"} -> IO.puts("Minus #{op2 - op1}")
    #  {:ok, "/"} -> IO.puts("Div #{op2 / op1}")
    ##  {:ok, "*"} -> IO.puts("Multi #{op2 * op1}")
     # {:error} -> IO.puts("no match")
    #end
  end

  def solve do
    #op1 = IO.gets("op1: ")
    #op2 = IO.gets("op2: ")
    #optr = IO.gets("optr: ")
    #subs_expr(op1, op2, optr)
    IO.puts("Do nothing")
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

  def evaluate(lst, opnds, optrs, v_top) do
    all_optrs = [")", "+", "-", "/", "*"]
    hi_pri = ["/", "*"]
    low_pri = ["+", "-"]

    if ((length lst) == 0) do
      IO.inspect(opnds)
    else
      el = List.first(lst)
      IO.puts("First element is #{el}")
      if Enum.member?(all_optrs, el) do
        IO.puts("REACHED IF #{el}")
        #optrs = handle_operators(optrs, hi_pri, low_pri, el)
        cond do 
          Enum.member?(hi_pri, el) ->
            optrs = [el] ++ optrs 
            v_top = el
          Enum.member?(low_pri, el) ->
            IO.puts("V_top #{v_top}")
            if Enum.member?(low_pri, v_top) do
              optrs = [el] ++ optrs 
              v_top = el
            else
              # evaluate
              IO.puts("reached inside handler block as expected")
              opnds = subs_expr(opnds, optrs)
              IO.inspect("evaluated stack : #{opnds}")
              # after solving add the queued operator in to stack
              [el] ++ optrs 
          # for a closing paranethesis
          #true -> pop_elements()
            end
        end
      else
        opnds = [el] ++ opnds
        IO.puts("final")
      end

      lst = tl lst
      IO.puts("OPNDS")  
      IO.inspect(optrs)
      evaluate(lst, opnds, optrs, v_top)
    end
  end
  
  def seggregate(lst, odds, evens) do
    if ((length lst) == 0) do
      IO.puts((length lst) == 9)
      IO.puts("ODDS : #{odds}")
      IO.puts("EVENS : #{evens}")
    else 
      IO.puts("Reached here")
      el = List.first(lst)
      IO.puts(el)
      if rem(el,2)==0 do
        evens = [el] ++ evens
        IO.puts(evens)
        IO.inspect(evens)
      else
        IO.inspect(odds)
        odds = [el] ++ odds
        IO.inspect(odds)
      end
    lst = tl lst

    seggregate(lst, odds, evens)
    end
    IO.puts("----------------------------")
    IO.inspect(odds)
  end

  def main do 
    lst = [1,2,3,4,5,6,7,8,9]
    odds = []
    evens = []
    #seggregate(lst, odds, evens)
    exp = IO.gets("Enter expression ")
    #lst = String.split(exp, " ")
    lst = String.split("4 / 2 + 1", " ")
    evaluate(lst, [], [], "+")
  end

  def hello do
    :world
  end
end
