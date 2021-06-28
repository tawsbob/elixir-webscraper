defmodule WebscraperQueueTest do
    
    use ExUnit.Case
  
    doctest Webscraper.Queue
    
    alias Webscraper.Helper
    alias Webscraper.LinkQueue
    alias Webscraper.Queue

    test "test handle_call with to get random link" do
        state = [
            %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
              }
          ]

          result = Queue.handle_call({:get_random_link}, nil, state)

          assert {
            :reply,

            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            },

            [
                %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
                }
            ]
        } = result
          
    end

    test "test handle_call with to get random link when state is empty" do
        
        state = []

        result = Queue.handle_call({:get_random_link}, nil, state)

        assert { :reply, nil, [] } = result
          
    end

end