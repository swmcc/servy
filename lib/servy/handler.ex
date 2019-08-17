defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  @pages_path Path.expand("../../pages/", __DIR__)

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

  @doc "Rewrites the path for wildlife"
  def rewrite_path(%{path: "/wildlife"} = conv ) do
    %{ conv | path: "/wildthings"}
  end

  @doc "Fall through for any path that doesn't need rewritten."
  def rewrite_path(conv), do: conv

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

  @doc "Returns the content for GET /wildthings"
  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  @doc "Returns the content for GET /bears"
  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Smokey, Paddington, Yogi" }
  end

  @doc "Returns the content for GET /bears/new"
  def route(%{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  @doc "Returns the content for GET /bears"
  def route(%{ method: "GET", path: "/bears" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

   @doc "Returns the content for GET /about"
   def route(%{ method: "GET", path: "/about" } = conv) do
       @pages_path
       |> Path.join("about.html")
       |> File.read
       |> handle_file(conv)
   end

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

   @doc "Returns the content for any file that has a corresponding content file in pages/"
   def route(%{method: "GET", path: "/pages/" <> file} = conv) do
     @pages_path
     |> Path.join(file <> ".html")
     |> File.read
     |> handle_file(conv)
   end

  @doc "Returns a 404 response"
  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "Couldn't find #{path}!"}
  end

  @doc "Formats the response into an actual HTTP/1.1 response"
  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  @doc "Logs output"
  def log(conv), do: IO.inspect conv
 
  @doc "Tracks a status"
  def track(%{status: 404, path: path} = conv) do
    IO.puts "WARNING: #{path} not found!"
    conv
  end

  def track(conv), do: conv

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response