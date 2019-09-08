defmodule Servy.Plugins do

  alias Servy.Conv

  @doc "Rewrites the path for wildlife"
  def rewrite_path(%Conv{path: "/wildlife"} = conv ) do
    %{ conv | path: "/wildthings"}
  end
  
  @doc "Fall through for any path that doesn't need rewritten."
  def rewrite_path(%Conv{} = conv), do: conv
  
  @doc "Tracks a status"
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "WARNING: #{path} not found!"
    conv
  end
  
  def track(%Conv{} = conv), do: conv
    
  @doc "Logs output"
  def log(%Conv{} = conv), do: IO.inspect conv
end