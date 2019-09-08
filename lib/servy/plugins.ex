defmodule Servy.Plugins do
  @doc "Rewrites the path for wildlife"
  def rewrite_path(%{path: "/wildlife"} = conv ) do
    %{ conv | path: "/wildthings"}
  end
  
  @doc "Fall through for any path that doesn't need rewritten."
  def rewrite_path(conv), do: conv
  
  @doc "Tracks a status"
  def track(%{status: 404, path: path} = conv) do
    IO.puts "WARNING: #{path} not found!"
    conv
  end
  
  def track(conv), do: conv
    
  @doc "Logs output"
  def log(conv), do: IO.inspect conv
end