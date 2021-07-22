defmodule WebscraperLinkQueueTest do
    use ExUnit.Case
  
    doctest Webscraper.LinkQueue
  
    alias Webscraper.LinkQueue

    test "create a Link Queue" do

      url = "https://www.google.com"
      provider_name = "google"
      
      queue_struct = LinkQueue.new(%{ url: url, provider_name: provider_name })

      condition = 
                    is_struct(queue_struct) and 
                    queue_struct.url == url and 
                    queue_struct.provider_name == provider_name and 
                    queue_struct.status == :pending 

      assert condition
  
    end

  
  end
  