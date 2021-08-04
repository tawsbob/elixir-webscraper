defmodule Webscraper do
  @moduledoc """
  Documentation for `Webscraper`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Webscraper.hello()
      :world

  """
  @providers [ Webscraper.Canaltech ]

  alias Webscraper.Queue
  alias Webscraper.Helper
  alias Webscraper.LinkQueue
  #alias Webscraper.Hasura
  alias Webscraper.ParsePlataform

  def start() do

    ##iniciar o processo de fila
    link = "https://canaltech.com.br/produto/apple/ipad-pro-129-2021/" #"https://canaltech.com.br/produto/"
    |> Helper.http_request
    |> Webscraper.Canaltech.load_initial_links
    
    Queue.start()
    Queue.add_link(link)

    scrape_flow()

  end

  ## Pega um link na lista
  def scrape_flow() do

    IO.puts "Starting new scrape flow"

    case Queue.get_random_link() do

      %LinkQueue{ provider_name: provider_name, url: url } ->

        provider = get_provider( provider_name )

        IO.puts "Got #{url} from queue"
        IO.inspect url

        url
        |>Helper.http_request
        |>provider.get_data
        |>pre_save(url)

      _ -> 
          IO.puts "All links are scraped bitch!"

    end

  end


  def get_provider(provider_name) do
    Enum.find(
      @providers, 
      fn provider -> 
        provider.provider_name() == provider_name 
      end
    )
  end

  def pre_save({product, links}, scraped_link) do
    Queue.add_link(links)

    slug = product.product_slug

    case ParsePlataform.get_product_by_slug(slug) do

      {:ok, %{"results" => []}} -> #criar o produto se não existir no banco
        #upload image 
        
        IO.puts "creating new product #{product.product_slug}"

        case ParsePlataform.download_image(slug, product.scrape_image) do
          {:ok, image } ->
            image_object = %{ name: image["name"], url: image["url"], __type: "File" }
            save(%{product|image: image_object })
            Queue.remove_link(scraped_link)
            scrape_flow()
          error -> IO.inspect error
        end

      
      #save(product)
      {:ok, result} -> 
          IO.puts "Product alredy #{product.product_slug} in database...."
          Queue.remove_link(scraped_link)
          scrape_flow()
      _ -> IO.puts "Error on get_product_by_slug"
    end

  end

  def save(product) do

    case ParsePlataform.create_product(product) do
      {:ok, _} ->
        IO.inspect "Product #{product.product_slug} on database"
        _-> nil
    end
  end
  
  # def pre_save({{product, videos}, links}, scraped_link) do
    
  #   Queue.add_link(links)

  #   #check on graphql if that product already exist in database
  #   case Hasura.looking_for_product(product) do
  #     {:ok, _} -> 
  #       IO.puts "Product already in database"
  #       Queue.remove_link(scraped_link)
  #       ## recomeça o flow
  #       scrape_flow()

  #     _ -> nil
  #     ##salva o produto no db
  #     save_hasura({product, videos}, scraped_link)
  #   end

  # end

  ##remember to download the images and upload to s3 
  # def save_hasura({product, videos}, scraped_link) when is_binary(scraped_link) do
  #   case Hasura.save_product(product) do

  #     {:ok, id } -> 
  #     IO.puts "New product #{product.product_name} on hasura databse with #{id}"
  #     Queue.remove_link(scraped_link)

  #     videos_with_id = Enum.map(
  #       videos,
  #       fn video ->
  #         %{video | product_id: id }
  #       end
  #     )
  #     Hasura.save_videos(videos_with_id)
  #     scrape_flow() 
  #     nil -> IO.puts "Something goes wrong when trying to save #{product.product_name} on hasura"
  #   end
  # end

end

Webscraper.start()