defmodule Webscraper.Graphql do

    alias Webscraper.Helper
    
    def send({query, %{} = variables}, url, headers \\ []) when is_binary(query) and is_binary(url)  do
    
        {:ok, decoded_json } = JSON.encode(%{ query: query, variables: variables })
        
        gql_call(%{ 
            url: url, 
            payload: Helper.clean_elixir_struct_attr(decoded_json), 
            headers: headers 
        })
    end

    def gql_call(%{ url: url, payload: payload, headers: headers}) do

       case Tesla.post(url, payload, headers: headers) do
            {:ok, response} -> 
                case JSON.decode(response.body) do
                    {:ok, _} = result -> result
                    _ -> nil
                end
            err -> 
                IO.puts "error on post request gql_call"
                IO.inspect err

                err
        end
    end

   

end