defmodule Webscraper.Spec do
   

    @moduledoc """
    A struct representing a product specification.
    by Dellean santos
    """
    
    alias Webscraper.Helper
    alias Webscraper.Model
    
    @behaviour Model
    @enforce_keys [ :label, :content ]

    defstruct   label: nil,
                content: nil

    @typedoc "A signle specification" 
    @type t() :: %__MODULE__{
        label: Strint.t(),
        content: Strint.t()
    }
    
    @spec new( map() ) :: %__MODULE__{}
    @impl Model
    def new( spec_map ) when is_map(spec_map) do
        %__MODULE__{
            label:  Helper.default_value(spec_map.label, "", &is_binary/1) ,
            content: Helper.default_value(spec_map.content, "", &is_binary/1)
        }
    end
end