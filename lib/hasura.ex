defmodule Webscraper.Hasura do

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
        headers = [
            {"content-type", "application/json"},
            {"x-hasura-admin-secret", "64aDuwbL2X3gEbVNh7JqbpDiS2CJ1SvX5DP6y2eLAe5EIouNk7FfGkh0pWa1CLf0"}
        ]

        {:ok, json_data } = JSON.encode(product)
        clean_json_data = Regex.replace(~r/\"__struct__\"\:\"(?<=\"\_\_struct\_\_\"\:\")(.+?)(?=\"\,)+\"+\,/, json_data, "")

        {:ok, payload} = JSON.encode(%{ query: query, variables: clean_json_data })

        #r/(?<=\"\_\_struct\_\_\"\:\")(.+?)(?=\"\,)/

       

        IO.inspect clean_json_data
        IO.puts "Sending product #{product.product_name} to hasura"

        # case File.write!('./teste.json', json_data) do
        #     :ok -> nil
        #     a -> IO.inspect a
        # end

        case Tesla.post("https://products-especifications.hasura.app/v1/graphql", payload, headers: headers) do
            {:ok, response} -> 
                IO.inspect response
                IO.inspect response.body
            a -> IO.inspect a
        end

    end
end