defmodule Servy.FileHandler do
   @doc "Returns the content for a successful internal file found (200)"
   def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  @doc "Returns an error code and string for an internal file that doesn't exist (404)"
  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found!" }
  end

  @doc "Returns the an error code and string for issues on a server re: an internal file (500)"
  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}" }
  end

end