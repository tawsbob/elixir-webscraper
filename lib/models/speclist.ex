defmodule Webscraper.Speclist do

    @moduledoc """
    A struct representing a product specification list.
    by Dellean santos
    """
    alias Webscraper.Helper
    alias Webscraper.Model

    @behaviour Model
    @enforce_keys [ :title, :specs ]
    
    defstruct   title: "",
                specs: []

    @type t :: %__MODULE__{
        title: String.t(),
        specs: list(%Webscraper.Spec{})
    }
    
    @impl Model
    @spec new( map() ) :: %__MODULE__{}
    def new( speclist_map ) when is_map(speclist_map) do

        %__MODULE__{
            title: Helper.default_value(speclist_map.title, "", &is_binary/1),
            specs: Helper.default_value(speclist_map.specs, [], &is_list/1),
        }

    end

end