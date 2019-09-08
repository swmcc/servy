defmodule Servy.Conv do
  defstruct method: "", 
            path: "",
            params: %{}, 
            headers: %{},
            resp_body: "", 
            status: nil

  @doc "Returns the full status for a HTTP response"
  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

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