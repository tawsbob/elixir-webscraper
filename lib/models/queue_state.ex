defmodule Webscraper.QueueState do
    
    alias Webscraper.Model
    alias Webscraper.Helper
    alias Webscraper.LinkQueue
    
    @behaviour Model
    @enforce_keys [ :queue, :length ]

    defstruct   queue: [],
                length: 0

    @type t :: %__MODULE__{
        queue: [%LinkQueue{}],
        length: Interger.t(),
    }

    @doc """
    new/1 create a new Queue State Struck

    ## Parameters
    - queue_state_map: a map of key value

    ## link_queue_map keys
    - queue: List,
    - length: Int

    """
    @impl Model
    @spec new( map() ) :: %__MODULE__{}
    def new( queue_state_map ) when is_map(queue_state_map) do
        %__MODULE__{
            queue: Helper.default_value_map(queue_state_map, :queue,  &is_list/1, []),
            length: Helper.default_value_map(queue_state_map, :length,  &is_integer/1, 0),
        }

    end

end