defmodule Webscraper.ParsePlataform do

    alias Webscraper.Product
    alias Webscraper.Helper

    @api_base_endpoint "https://parseapi.back4app.com"
    @http_headers [
            {"content-type", "application/json"},
            {"X-Parse-Application-Id", "anDhhoOmvNdRtW848DVsOQZiETSXsqARyRVBATfW"},
            {"X-Parse-REST-API-Key", "4Kb4JyafMQhsTEDBFTyulRkCowjJWqwpZHJzExZ1"}
        ]
    
    def create_product(product) do
        url = @api_base_endpoint <> "/classes/Products"

        {:ok, json }    = JSON.encode( product )
        payload         = Helper.clean_elixir_struct_attr(json)

        IO.puts "Creating #{product.product_slug}"
        case Tesla.post(url, payload, headers: @http_headers) do
            {:ok, response} ->
                #IO.inspect response 
                case response.status do
                    200 -> JSON.decode(response.body)
                    _ -> nil
                end
            error -> 
                IO.inspect error
                error
        end
    end

    def get_product_by_slug(product_slug) do
        url = @api_base_endpoint <> "/classes/Products"
        
        IO.puts "get_product_by_slug #{product_slug}"

        case Tesla.get(url,query: [where: [product_slug: product_slug]], headers: @http_headers) do
            {:ok, response} ->
                case response.status do
                    200 -> JSON.decode(response.body)
                    _ -> nil
                end
            error -> 
                IO.inspect error
                error
        end
    end

    def download_image(file_name, image_url) do

        ext = String.split(image_url, ".") |> List.last

        case Tesla.get(image_url) do
            {:ok, response} ->
                upload_image({file_name, ext, response.body})
            error ->
                    IO.inspect error 
                    nil
        end
    end

    def upload_image({ file_name, ext, image_binary }) do
        
        headers = [ {"Content-Type", "image/#{ext}"} | @http_headers ]
        url     = @api_base_endpoint <> "/files/#{file_name}.#{ext}"

        IO.puts "Uploading #{file_name}"

        case Tesla.post( url, image_binary,  headers: headers) do
            {:ok, response} -> 
                IO.puts "image #{file_name} uploaded!"
                #retorna a imagem já em json para adicionar no produto antes de salvar
                JSON.decode(response.body)
            error ->
                IO.inspect error 
                nil
        end
        

    end

end