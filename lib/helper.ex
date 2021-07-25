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

    def slugfy(str, lowercase \\ true ) when is_binary(str) do
        IO.inspect str
        Slug.slugify(str,lowercase: lowercase)
    end

end