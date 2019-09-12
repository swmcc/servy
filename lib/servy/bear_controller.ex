defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearView

  @doc "The index for bears"
  def index(conv) do
    bears = 
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
    
    %{ conv | status: 200, resp_body: BearView.index(bears)}  
  end

  @doc "Shows a specific bear"
  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: BearView.show(bear)}  
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