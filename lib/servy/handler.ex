defmodule Servy.Handler do
  def handle(request) do
    request 
    |> parse
    |> rewrite_path 
    |> log
    |> route
    |> track
    |> format_response
  end

  def rewrite_path(%{path: "/wildlife"} = conv ) do
    %{ conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

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

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Smokey, Paddington, Yogi" }
  end

  def route(%{ method: "GET", path: "/berars" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "Couldn't find #{path}!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  def log(conv), do: IO.inspect conv

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