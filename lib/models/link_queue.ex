defmodule Webscraper.LinkQueue do
    
    alias Webscraper.Helper

    @enforce_keys [ :url, :provider_name ]

    defstruct   url: "",
                provider_name: "",
                status: :pending

    @type t :: %__MODULE__{
        url: String.t(),
        provider_name: String.t(),
        status: atom(),
    }

    @doc """
    new/1 create a new Link Queue Struck

    ## Parameters
    - link_queue_map: a map of key value

    ## link_queue_map keys
    - url: String,
    - provider_name: String
    - status: Atom => :pending | :done

    """
    @spec new( map() ) :: %__MODULE__{}
    def new( link_queue_map ) when is_map(link_queue_map) do

        %__MODULE__{
            url: Helper.default_value_map(link_queue_map, :url,  &is_binary/1, ""),
            provider_name: Helper.default_value_map(link_queue_map, :provider_name,  &is_binary/1, ""),
            status: Helper.default_value_map(link_queue_map, :status,  &is_atom/1, :pending )
        }

    end

end