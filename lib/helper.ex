defmodule Webscraper.Helper do

    alias Webscraper.LinkQueue

    @moduledoc """

    A helper module with some of generic functions to help on development
    By Dellean Santos
    """
    
    @doc """
    
    default_value_map/3 return a default value if map key isnt in map 
    
    ## Parameters
        - map: a map to check the key value
        - atom: key of map as atom
        - default_value: default value to replace in case of missing value on map
    """
    @spec default_value_map( map(), atom(), any()  ) :: any()
    def default_value_map( map_to_check, key, default_value ) do
        if Map.has_key?(map_to_check, key) do 
            map_to_check[ key ]
        else 
            default_value
        end
    end

    @doc """
    
    # default_value_map/4 
    
    return a default value if map key isnt in map and with type valudation
    
    ## Parameters
        - map: a map to check the key value
        - atom: key of map as atom
        - fn_check: a function that check type of key value
        - default_value: default value to replace in case of missing value on map
    """
    @spec default_value_map( map(), atom(), fun(), any()  ) :: any()
    def default_value_map( map_to_check, key, fn_check, default_value ) do
        if Map.has_key?(map_to_check, key) do 
            variable_check_test = fn_check.(default_value)
            if variable_check_test do
                map_to_check[ key ]
            else
                default_value
            end
        else 
            default_value
        end
    end

    @doc """
    
    # default_value/3
    
    return a default value if map key isnt in map and with type valudation
    
    ## Parameters
        - initial_value: initial value
        - default_value: default value if initial value is not valid
        - fn_check: a function that check type of key value
    """

    @spec default_value( any(), any(), fun() ) :: any()
    def default_value( initial_value, default_value, fn_check ) do
        
        variable_check_test = fn_check.(initial_value)

        if variable_check_test do 
            initial_value 
        else 
            default_value
        end
    end

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
    

    def http_request( url ) do
        case Tesla.get(url) do
            {:ok, response} -> 

                IO.puts "Loading data from #{url} done()"
                
                if response.status == 200 do
                    response.body
                else 
                    IO.puts "Something goes wrong when trying to fetch data \n"
                    IO.inspect response
                    nil
                end

            _ -> nil
        end
    end

end