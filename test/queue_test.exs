defmodule WebscraperQueueTest do
    
    use ExUnit.Case
  
    doctest Webscraper.Queue
    
    alias Webscraper.LinkQueue
    alias Webscraper.Queue

    test "add link to queue and check if is added correctly" do

        link = { "https://www.google.com.br/", "google"}

        result = Queue.handle_call({:add_link, [ link ]}, nil, [])
        
        { :reply, :ok, [ queue_link ] } = result

        assert %Webscraper.LinkQueue{
            provider_name: "google",
            status: :pending,
            url: "https://www.google.com.br/"
        } = queue_link

    end

    test "check if status change correctly when call :remove_link " do

        state = [
            %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
              }
          ]

        result = Queue.handle_call({:remove_link, "https://www.google.com.br/"}, nil, state)
        
        { :reply, :ok, [ queue_link ] } = result

        assert %Webscraper.LinkQueue{
            provider_name: "google",
            status: :done,
            url: "https://www.google.com.br/"
        } = queue_link

    end

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

    test "test handle_call with to get random link when state is filled" do
        
        state = [
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            },

        ]

        result = Queue.handle_call({:get_random_link}, nil, state)

        assert {
            :reply,
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            }, 
            _ 
        }  = result
          
    end

    test "test handle_call with to get random link when state is filled and all links done" do
        
        state = [
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :done,
                url: "https://www.google.com.br/"
            },

        ]

        result = Queue.handle_call({:get_random_link}, nil, state)

        assert {
            :reply,
            nil, 
            _ 
        }  = result
          
    end

end