defmodule Servy.Parser do
  
  @doc "Parse the request to get the METHOD and the PATH of the request."
  def parse(request) do
    [method, path, _] =
      request 
      |> String.split("\n")
      |> List.first
      |> String.split(" ") 

    %{ method: method, 
       path: path, 
       resp_body: "",
       status: nil }
  end
end