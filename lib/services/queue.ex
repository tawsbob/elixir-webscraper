defmodule Webscraper.Queue do
    use GenServer

    alias Webscraper.LinkQueue
    alias Webscraper.Helper

    @process_name :queue_process

    @impl GenServer
    def init(init_arg) do
      {:ok, init_arg}
    end

    #remember to use binary_to_term to save state on file

    @impl GenServer
    def handle_call({:add_link, links}, _sender_pid, state) when is_list(links) do

        IO.puts "adding new links on queue... \n"

        new_links = links
            |> Helper.plain_links_to_model
            |> Helper.filter_duplicated_link( state )
        
        new_state = state ++ new_links

        {:reply, :ok, new_state}
    end

    
    @impl GenServer
    def handle_call({:get_random_link}, _sender_pid, state) do

        IO.puts "get one link from queue ... \n"

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

    @impl GenServer
    def handle_call({:remove_link, link}, _sender_pid, state) do

        IO.puts "Mark as done #{link} ... \n"

        new_state = Enum.map(
            state,
            fn  queue_link ->

                if queue_link.url == link do
                    %LinkQueue{queue_link | status: :done }
                else 
                    queue_link
                end
            end
        )
        {:reply, :ok, new_state}
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