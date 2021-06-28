defmodule WebscraperHelperTest do
    use ExUnit.Case
  
    doctest Webscraper.Helper
    
    alias Webscraper.Helper
    alias Webscraper.LinkQueue
    
    #QUEUE TESTS 
    test "convert turple on link queue model plain_links_to_model" do
    
    url = "https://www.google.com.br/"
    provider = "google"

     result = Helper.plain_links_to_model([{ url, provider }])

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
        
        

        result = Helper.filter_duplicated_link(list, state)

        assert [
            %LinkQueue{
              provider_name: "google",
              status: :pending,
              url: "https://www.google.com.br/1"
            }
          ] = result 

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

        result = Helper.check_if_lnk_in_list?(link, list)

        assert result

    end
    
  
  end
  