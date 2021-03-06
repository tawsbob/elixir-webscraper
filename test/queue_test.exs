defmodule WebscraperQueueTest do
    
    use ExUnit.Case
  
    doctest Webscraper.Queue
    
    alias Webscraper.QueueState
    alias Webscraper.LinkQueue
    alias Webscraper.Queue

    test "create state" do
        result = Queue.create_new_state([])
        assert %QueueState{length: 0, queue: []} == result
    end

    

    test "create state with one link" do

        result = Queue.create_new_state([
            %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            }, 
        ])

        assert %QueueState{
            length: 1,
            queue: [
              %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
              }
            ]
          } == result           

    end

    test "get all links" do

        state = Queue.create_new_state([
            %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            }, 
        ])
        
        result = Queue.handle_call({:get_link_list}, nil, state)
        
        assert {:reply,
             [
               %Webscraper.LinkQueue{
                 provider_name: "google",
                 status: :pending,
                 url: "https://www.google.com.br/"
               }
             ],
            _
        } = result           

    end

    test "add link to queue and check if is added correctly" do

        link = { "https://www.google.com.br/", "google"}

        result = Queue.handle_call({:add_link, [ link ]}, nil, Queue.create_new_state( [] ))

        {   
            :reply, 
            :ok,
            %QueueState{
                length: 1,
                queue: [
                    queue_link
                ]
            }
        } = result

        assert %LinkQueue{
            provider_name: "google",
            status: :pending,
            url: "https://www.google.com.br/"
        } = queue_link

    end

        
    test "test handle_call with to get random link when state is filled" do
        
        state = Queue.create_new_state([
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            },
        ])

        result = Queue.handle_call({:get_random_link}, nil, state)

        assert {
            :reply,
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            },
            %Webscraper.QueueState{
                length: 1,
                queue: [
                    %Webscraper.LinkQueue{
                    provider_name: "google",
                    status: :pending,
                    url: "https://www.google.com.br/"
                    }
                ]
            }
        } = result
        
    end

    test "test handle_call with to get random link when state is empty" do
    
        result = Queue.handle_call({:get_random_link}, nil, Queue.create_new_state([]) )
    
        assert { 
                :reply, 
                nil,
                %Webscraper.QueueState{
                    length: 0,
                    queue: []
                }
        } = result
          
    end

    test "test handle_call with to get random link" do
        state = [
            %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
              }
          ]
    
          result = Queue.handle_call({:get_random_link}, nil, Queue.create_new_state(state) )
    
          assert {
            :reply,
    
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
            },
            
            %QueueState{ queue: 
                [
                    %Webscraper.LinkQueue{
                    provider_name: "google",
                    status: :pending,
                    url: "https://www.google.com.br/"
                    }
                ]
             }
        } = result
          
    end

    test "check if status change correctly when call :remove_link " do

        queue = [
            %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/",
              },
              %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/teste"
              }
          ]
    
        result = Queue.handle_call({:remove_link, "https://www.google.com.br/"}, nil, Queue.create_new_state(queue))
        
        {   
            :reply, 
            :ok,
            %QueueState{
                length: 2,
                queue: [
                    queue_link | _
                ]
            }
        } = result  
    
        assert %Webscraper.LinkQueue{
            provider_name: "google",
            status: :done,
            url: "https://www.google.com.br/"
        } = queue_link
    
    end

    test "test handle_call with to get random link when state is filled and all links done" do
    
        state = Queue.create_new_state([
            %Webscraper.LinkQueue{
                provider_name: "google",
                status: :done,
                url: "https://www.google.com.br/"
            },
        ])
    
        result = Queue.handle_call({:get_random_link}, nil,  state)
    
        assert {
            :reply,
            nil, 
            _ 
        }  = result
          
    end

    test "convert turple on link queue model plain_links_to_model" do
    
        url = "https://www.google.com.br/"
        provider = "google"
    
         result = Queue.plain_links_to_model([{ url, provider }])
    
         assert [
            %LinkQueue{
              provider_name: "google",
              status: :pending,
              url: "https://www.google.com.br/"
            }
          ] = result 
      
        end
    
        test "Test filter_duplicated_link" do
            
            # LIST OF LINK THATS FIST ITEM IS DUPLICATED IN STATE AND MOST BE REMOVED
            list =  [
                %LinkQueue{
                  provider_name: "google",
                  status: :pending,
                  url: "https://www.google.com.br/"
                },
                %LinkQueue{
                    provider_name: "google",
                    status: :pending,
                    url: "https://www.google.com.br/1"
                  }
              ]
    
            state = [
                %LinkQueue{
                    provider_name: "google",
                    status: :pending,
                    url: "https://www.google.com.br/"
                  }
              ]
            
            
    
            result = Queue.filter_duplicated_link(list, state)
    
            assert [
                %LinkQueue{
                  provider_name: "google",
                  status: :pending,
                  url: "https://www.google.com.br/1"
                }
              ] = result 
    
        end
    
        test "Test filter_duplicated_link with empty state" do
            
          # LIST OF LINK THATS FIST ITEM IS DUPLICATED IN STATE AND MOST BE REMOVED
          list =  [
              %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
              }
            ]
    
          state = [ ]
          
          
    
          result = Queue.filter_duplicated_link(list, state)
    
          assert [
             %LinkQueue{
                provider_name: "google",
                status: :pending,
                url: "https://www.google.com.br/"
              }
            ] = result 
    
      end
    
      test "Test filter_duplicated_link with empty state and list" do
        list = []
        state = [ ]
        result = Queue.filter_duplicated_link(list, state)
        assert [] = result
      end 
        
    
        test "check_if_lnk_in_list" do
    
            list = [
                %LinkQueue{
                  provider_name: "google",
                  status: :pending,
                  url: "https://www.google.com.br/1"
                }
              ] 
    
            link = "https://www.google.com.br/1"
    
            result = Queue.check_if_lnk_in_list?(link, list)
    
            assert result
    
        end

    test "Start queue process" do
        assert is_pid( Queue.start() )
    end

    
end