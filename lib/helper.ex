defmodule Webscraper.Helper do

    @moduledoc """
    A helper module with some of generic functions to help on development
    By Dellean Santos
    """

    @spec default_value_map( map(), atom(), any()  ) :: any()
    def default_value_map( map_to_check, key, default_value ) do
        if Map.has_key?(map_to_check, key) do 
            map_to_check[ key ]
        else 
            default_value
        end
    end


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

    @spec default_value( any(), any()  ) :: any()
    def default_value( default_value_param, value_else ) do
        if default_value_param do 
            default_value_param 
        else 
            value_else
        end
    end

    @spec default_value( any(), any(), fun() ) :: any()
    def default_value( default_value_param, value_else, fn_check ) do
        
        variable_check_test = fn_check.(default_value_param)

        if variable_check_test do 
            default_value_param 
        else 
            value_else
        end
    end

end