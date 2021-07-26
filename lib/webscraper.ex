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


    ## Pega um link na lista
    %LinkQueue{ provider_name: provider_name, url: url } = Queue.get_random_link()

    ##escolher o provider para ser scrapado
    provider = get_provider( provider_name )
    
    url
    |>Helper.http_request
    |>provider.get_data
    |>save_hasura
    ##salvar os dados no hasura
    ##Remover o produto da fila

    ##fazer o download das imagens
    #|> provider.get_image
    
    

    
    

    ##Recomeçar o fluxo denovo


    

    #Queue.add_link( [{"url", "provider name"}] )
    #Queue.get_link_list()

  end


  def get_provider(provider_name) do
    Enum.find(
      @providers, 
      fn provider -> 
        provider.provider_name() == provider_name 
      end
    )
  end

  def save_hasura({ product, link }) do
    Hasura.save_product(product)
  end

end

IO.inspect Webscraper.start()