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
  alias Webscraper.Hasura

  def start() do

    ##iniciar o processo de fila
    link = "https://canaltech.com.br/produto/"
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

  def pre_save({{product, videos}, links}, scraped_link) do
    
    Queue.add_link(links)

    #check on graphql if that product already exist in database
    case Hasura.looking_for_product(product) do
      {:ok, _} -> 
        IO.puts "Product already in database"
        Queue.remove_link(scraped_link)
        ## recomeça o flow
        scrape_flow()

      _ -> nil
      ##salva o produto no db
      save_hasura({product, videos}, scraped_link)
    end

  end

  ##remember to download the images and upload to s3 
  def save_hasura({product, videos}, scraped_link) when is_binary(scraped_link) do
    
    

    case Hasura.save_product(product) do

      {:ok, id } -> 
      IO.puts "New product #{product.product_name} on hasura databse with #{id}"
      Queue.remove_link(scraped_link)

      videos_with_id = Enum.map(
        videos,
        fn video ->
          %{video | product_id: id }
        end
      )

      Hasura.save_videos(videos_with_id)

      scrape_flow()
      
      nil -> IO.puts "Something goes wrong when trying to save #{product.product_name} on hasura"
    end

  end

end