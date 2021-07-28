defmodule Webscraper.Hasura do

    alias Webscraper.Product
    alias Webscraper.Graphql

    @graphql_endpoint "https://products-especifications.hasura.app/v1/graphql"
    @http_headers [
            {"content-type", "application/json"},
            {"x-hasura-admin-secret", "64aDuwbL2X3gEbVNh7JqbpDiS2CJ1SvX5DP6y2eLAe5EIouNk7FfGkh0pWa1CLf0"}
        ]
        

    def looking_for_product(%Product{ product_slug: product_slug }) do
        query = """
            query checkForProductElixir(
                $product_slug: String!
            ){
                product(
                    where: {
                        product_slug: { _eq: $product_slug }
                    }
                ) {
                    id
                }
            }
        """
    
        IO.puts "-----------------------"
        IO.inspect product_slug
        IO.puts "-----------------------"

       payload  = %{ product_slug: product_slug }
        
        case  Graphql.send({ query,  payload }, @graphql_endpoint, @http_headers) do
            {:ok, %{"data" => %{"product" => %{"id" => id } }}} -> 
                {:ok, id}
            err -> 
                IO.puts "error on post request looking_for_product"
                IO.inspect err
                :err
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
 
        
        IO.puts "Sending product #{product.product_name} to hasura"

        # case File.write!('./teste.json', clean_json_data) do
        #     :ok -> nil
        #     a -> IO.inspect a
        # end
        
        #remember to switch to an abstraction to better software architecture
        case Graphql.send({ query,  product }, @graphql_endpoint, @http_headers) do
            {:ok, %{"data" => %{"insert_product_one" => %{"id" => id } }}} -> 
                IO.puts "Product created with id #{id}"
                {:ok, id}
                err -> 
                    IO.puts "error on post request save_product"
                    IO.inspect err
                    err
        end

    end

end