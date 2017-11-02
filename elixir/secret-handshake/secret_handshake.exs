defmodule SecretHandshake do
  use Bitwise
  @items [{ "wink", 1 }, { "double blink", 2 }, { "close your eyes", 4 }, { "jump", 8 }]
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    Enum.map(@items, fn({cmd, value}) -> 
      code_generator(cmd, value, code, []) 
    end) |> List.flatten |> check_for_sixteen(code)
  end

  defp code_generator(cmd, value, code, result) do
    case matcher(value, code) do
      true -> [cmd | result]
      _    ->    result
    end
  end


  defp matcher(value, code) do
    (value &&& code) === value
  end

  defp check_for_sixteen(list, code) do
    case matcher(16, code) do
      true -> Enum.reverse(list)
      _ -> list
    end
  end
end

