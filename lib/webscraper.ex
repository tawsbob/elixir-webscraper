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
    Queue.start()
    Queue.add_link([{ "https://canaltech.com.br/produto/apple/ipad-pro-129-2021/", "canaltech"  }])
    scrape_flow()

  end

  ## Pega um link na lista
  def scrape_flow() do

    case Queue.get_random_link() do

      %LinkQueue{ provider_name: provider_name, url: url } ->

        provider = get_provider( provider_name )
    
        url
        |>Helper.http_request
        |>provider.get_data
        |>pre_save
        |>save_hasura(url)

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

  def pre_save({product, links}) do
    
    Queue.add_link(links)

    #check on graphql if that product already exist in database
    case Hasura.looking_for_product(product) do
      {:ok, _} -> 
        IO.puts "Product already in database"
        ## recomeça o flow
        scrape_flow()
      _ -> nil
      ##salva o produto no db
      product
    end

  end

  ##remember to download the images and upload to s3 
  def save_hasura(product, scraped_link) when is_binary(scraped_link) do
    
    case Hasura.save_product(product) do

      {:ok, id } -> 
      IO.puts "New product #{product.product_name} on hasura databse with #{id}"
      Queue.remove_link(scraped_link)
      scrape_flow()
      
      nil -> IO.puts "Something goes wrong when trying to save #{product.product_name} on hasura"
    end

  end

end

Webscraper.start()