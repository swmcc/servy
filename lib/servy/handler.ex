defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  alias Servy.Conv
  alias Servy.BearController

  @pages_path Path.expand("pages", File.cwd!)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  @doc "Transforms the request into a response."
  def handle(request) do
    request 
    |> parse
    |> rewrite_path 
    |> log
    |> route
    |> track
    |> format_response
  end

  @doc "Returns the content for GET /wildthings"
  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  @doc "Returns the content for GET /bears"
  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    BearController.index(conv)
  end

  @doc "Create a new bear"
  def route(%Conv{ method: "POST", path: "/bears" } = conv) do
    BearController.create(conv, conv.params)
  end

  @doc "Deletes a bear"
  def route(%Conv{ method: "DELETE", path: "/bears/" <> _id } = conv) do
    BearController.delete(conv, conv.params) 
  end

  @doc "Returns the content for GET /bears/new"
  def route(%Conv{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  @doc "Returns the content for GET /bears"
  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

   @doc "Returns the content for GET /about"
   def route(%Conv{ method: "GET", path: "/about" } = conv) do
       @pages_path
       |> Path.join("about.html")
       |> File.read
       |> handle_file(conv)
   end

   @doc "Returns the content for any file that has a corresponding content file in pages/"
   def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
     @pages_path
     |> Path.join(file <> ".html")
     |> File.read
     |> handle_file(conv)
   end

   @doc "Returns a 404 response"
  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "Couldn't find #{path}!"}
  end

  @doc "Formats the response into an actual HTTP/1.1 response"
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end