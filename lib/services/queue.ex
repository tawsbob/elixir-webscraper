defmodule Webscraper.Queue do
    use GenServer

    alias Webscraper.QueueState
    alias Webscraper.LinkQueue
    alias Webscraper.Helper

    ##salvar o estado da fila em um arquivo
    ##tentar colocar isso em um redis
    @process_name :queue_process

    @impl GenServer
    def init(init_arg) do
        {:ok, init_arg}
    end

    def start() do
        {:ok, pid } = GenServer.start(__MODULE__, create_new_state([]), name: @process_name )
        IO.puts "Starting Queue process with pid #{inspect pid} ... \n"
        pid
    end

    #remember to use binary_to_term to save state on file

    @impl GenServer
    def handle_call({:add_link, links}, _sender_pid, state) when is_list(links) do

        IO.puts "adding new links on queue... \n"

        new_links = links
            |> plain_links_to_model
            |> filter_duplicated_link( state.queue )
        
        new_queue = state.queue ++ new_links

        {:reply, :ok, create_new_state(new_queue) }
    end

    
    @impl GenServer
    def handle_call({:get_random_link}, _sender_pid, state) do

        IO.puts "get one link from queue ... \n"

        link = Enum.find(
            state.queue,
            fn %LinkQueue{ status: status } ->
                status == :pending
            end 
        ) 

        {:reply, link, state }
    end

    @impl GenServer
    def handle_call({:get_link_list}, _sender_pid, state) do
        {:reply, state.queue, state}
    end

    @impl GenServer
    def handle_call({:remove_link, link}, _sender_pid, state) do

        IO.puts "Mark as done #{link} ... \n"

        new_queue = Enum.map(
            state.queue,
            fn  queue_link ->
                if queue_link.url == link do
                    %LinkQueue{queue_link | status: :done }
                else 
                    queue_link
                end
            end
        )
        {:reply, :ok, create_new_state(new_queue) }
    end

    #generic function
   #QUEUE HELPERS

     @doc """
    
    # plain_links_to_model/1
    
    return a list of LinkQueue Struct with status pending
    
    ## Parameters
        - lks: list of links as turple { url, provider_name }
    """

    @spec plain_links_to_model( list() ) :: list(%LinkQueue{})
    def plain_links_to_model(lks) when is_list(lks) do
        Enum.map(
            lks,
            fn { url, provider_name } -> 
                LinkQueue.new(%{ url: url, provider_name: provider_name }) 
            end
        )
    end

     @doc """
    
    # filter_duplicated_link/2
    
    return a list of LinkQueue Struct of new items in list_links_to_check
    
    ## Parameters
        - list_links: list of links as LinkQueue Struct
        - list_links_to_check: list of links as LinkQueue Struct
    """
    #Think way to rever that quadratic function into a linerar
    def filter_duplicated_link(list_links, list_links_to_check) when is_list(list_links) and is_list(list_links_to_check) do
        
        Enum.filter(
            list_links,
            fn lnk ->
                %LinkQueue{ url: url } = lnk
                !check_if_lnk_in_list?( url,  list_links_to_check)
            end
        )
    end

    def check_if_lnk_in_list?(check_url, check_list) when is_binary(check_url) and is_list(check_list) do
        
        Enum.any?(
            check_list,
            fn %LinkQueue{ url: url } ->
                check_url === url
            end
        )
    end

    # client functions
    def add_link(lks) when is_list(lks) do
        GenServer.call @process_name, {:add_link, lks}
    end

    def get_link_list() do
        GenServer.call @process_name, {:get_link_list}
    end

    def get_random_link() do
        GenServer.call @process_name, {:get_random_link}
    end

    def remove_link(link) do
        GenServer.call @process_name, {:remove_link, link}
    end
    
    def create_new_state(queue_list) when is_list(queue_list) do
        QueueState.new(%{
            queue: queue_list,
            length: length(queue_list)
        })
    end

    # generic functions

end