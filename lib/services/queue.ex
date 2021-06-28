defmodule Scrape.Queue do
    use GenServer

    @process_name :queue_process

    @impl true
    def init(init_arg) do
      {:ok, init_arg}
    end

    @impl true
    def handle_call({:add_link, event}, _sender_pid, state) do
        {:reply, :ok, [event | state] }
    end

    @impl true
    def handle_call({:get_link_list}, _sender_pid, state) do
        {:reply, state, state}
    end

    def start() do
        {:ok, pid } = GenServer.start(__MODULE__, [], name: @process_name )
        IO.puts "Starting Queue process with pid #{inspect pid} ... \n"
    end

    def add_event(event) do
        GenServer.call @process_name, {:add, event}
    end

    def get_events_list() do
        GenServer.call @process_name, {:list}
    end

end