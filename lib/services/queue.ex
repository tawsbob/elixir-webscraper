defmodule Webscraper.Queue do
    use GenServer

    alias Webscraper.LinkQueue
    alias Webscraper.Helper

    @process_name :queue_process

    @impl GenServer
    def init(init_arg) do
      {:ok, init_arg}
    end

    @impl GenServer
    def handle_call({:add_link, links}, _sender_pid, state) do

        new_links = links
            |> Helper.plain_links_to_model
            |> Helper.filter_duplicated_link( state )
        
        new_state = state ++ new_links

        {:reply, :ok, new_state}
    end

    
    @impl GenServer
    def handle_call({:get_random_link}, _sender_pid, state) do

        link = Enum.find(
            state,
            fn %LinkQueue{ status: status } ->
                status == :pending
            end 
        ) 

        {:reply, link, state}
    end

    @impl GenServer
    def handle_call({:get_link_list}, _sender_pid, state) do
        {:reply, state, state}
    end



    def start() do
        {:ok, pid } = GenServer.start(__MODULE__, [], name: @process_name )
        IO.puts "Starting Queue process with pid #{inspect pid} ... \n"
    end

    # client functions
    def add_link(lks) do
        GenServer.call @process_name, {:add_link, lks}
    end

    def get_link_list() do
        GenServer.call @process_name, {:get_link_list}
    end

    def get_random_link() do
        GenServer.call @process_name, {:get_random_link}
    end
    
    # generic functions

end