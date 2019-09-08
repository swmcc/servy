defmodule Servy.Parser do
 
  alias Servy.Conv

  @doc "Parse the request to get the METHOD and the PATH of the request."
  def parse(request) do
    [method, path, _] =
      request 
      |> String.split("\n")
      |> List.first
      |> String.split(" ") 

    %Conv{ 
       method: method, 
       path: path, 
    }
  end
end