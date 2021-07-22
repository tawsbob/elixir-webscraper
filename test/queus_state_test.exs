defmodule WebscraperQueueStateTest do
    use ExUnit.Case
  
    doctest Webscraper.QueueState
  
    alias Webscraper.QueueState

    test "create a Link Queue" do

      queue_state_truct = QueueState.new(%{ queue: [], length: 0 })

      condition = 
                    is_struct(queue_state_truct) and 
                    queue_state_truct.length == 0 and
                    queue_state_truct.queue == []

      assert condition
  
    end
  
  end
  