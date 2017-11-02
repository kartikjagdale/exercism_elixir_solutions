defmodule SecretHandshake do
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
    case Integer.to_string(code, 2) do
      code_string when byte_size(code_string) > 5 ->
        []
      code_string ->
        code_list = standardize(code_string)
        command_list = ["wink", "double blink", "close your eyes", "jump", :reverse]
        execute(code_list, command_list, [])
    end
  end

  defp standardize(code) do
    prefix = 5 - String.length(code)
    code = String.duplicate("0", prefix) <> code

    code
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reverse()
  end

  def execute([1], [_command], result) do
    Enum.reverse(result)
  end

  def execute([0], [_command], result) do
    result
  end

  def execute([1 | codes], [command | commands], result) do
    execute(codes, commands, result ++ [command])
  end

  def execute([0 | codes], [_command | commands], result) do
    execute(codes, commands, result)
  end
end

