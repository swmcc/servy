defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>" 
  end

  @doc "The index for bears"
  def index(conv) do
    items = 
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  @doc "Shows a specific bear"
  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}" }
  end

  @doc "Shows the success page for creating a bear"
  def create(conv, %{"name" => name, "type" => type}) do 
    %{ conv | status: 201,
              resp_body: "Created a #{type} bear named #{name}!" }
  end

  @doc "Deletes a bear instance"
  def delete(conv, _params) do
    %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!" }
  end
end