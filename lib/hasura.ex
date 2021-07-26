defmodule Webscraper.Hasura do

    alias Webscraper.Product

    @http_headers [
            {"content-type", "application/json"},
            {"x-hasura-admin-secret", "64aDuwbL2X3gEbVNh7JqbpDiS2CJ1SvX5DP6y2eLAe5EIouNk7FfGkh0pWa1CLf0"}
        ]

    def looking_for_product(%Product{ product_name: product_name, brand: brand  }) do
        query = """
        query checkForProductElixir(
            $brand: String!
            $product_name: String!

        ){
            product(
                where: {
                    brand: { _eq: $brand },
                    product_name: { _eq: $product_name}
                }
            ) {
                id
              }
        }
        """

        {:ok, payload } = JSON.encode(%{ query: query, variables: %{ product_name: product_name, brand: brand  } })
        
        case Tesla.post("https://products-especifications.hasura.app/v1/graphql", payload, headers: @http_headers) do
            {:ok, response} -> 
                #IO.inspect response
                case JSON.decode(response.body) do
                    {:ok, %{"data" => %{"product" => %{"id" => id } }}} -> 
                        {:ok, id}
                    _ -> nil
                end
            err -> 
                IO.puts "error on post request looking_for_product"
                IO.inspect err
        end

    end

    def save_product(product) do
        query = "
        mutation createProductElixir(
            $brand: String!
            $brand_slug: String!
            $image: String!
            $product_name: String!
            $product_slug: String!
            $specifications_section: json!
        ){
        insert_product_one(
                object:{
                    brand: $brand,
                    brand_slug: $brand_slug,
                    image: $image,
                    product_name: $product_name,
                    product_slug: $product_slug,
                    specifications_section: $specifications_section
                }
            ){
                id
            }
        }
        "
 

        {:ok, decoded_json } = JSON.encode(%{ query: query, variables: product })
        
        #clean struct field 
        payload = clean_elixir_struct_attr(decoded_json)

        
        IO.puts "Sending product #{product.product_name} to hasura"

        # case File.write!('./teste.json', clean_json_data) do
        #     :ok -> nil
        #     a -> IO.inspect a
        # end
        
        #remember to switch to an abstraction to better software architecture
        case Tesla.post("https://products-especifications.hasura.app/v1/graphql", payload, headers: @http_headers) do
            {:ok, response} -> 
                #IO.inspect response
                case JSON.decode(response.body) do
                    {:ok, %{"data" => %{"insert_product_one" => %{"id" => id } }}} -> 
                        IO.puts "Product created with id #{id}"
                        {:ok, id}
                        err -> 
                            IO.puts "error on post request save_product"
                            IO.inspect err
                end
            a -> IO.inspect a
        end

    end

    def clean_elixir_struct_attr( decoded_json ) do
        Regex.replace(~r/\"__struct__\"\:\"(?<=\"\_\_struct\_\_\"\:\")(.+?)(?=\"\,)+\"+\,/, decoded_json, "")
    end

end