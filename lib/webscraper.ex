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

  alias Webscraper.Queue
  alias Webscraper.Helper

  def start() do

    ##iniciar o processo de fila
    ##carregar o estado vindo do arquivo binário
    ##escolher o provider para ser scrapado
    ##fazer o http_request
    ##extair os dados da página
    ##fazer o download das imagens
    ##salvar os dados no disco
    ##Remover o produto da vida
    ##Recomeçar o fluxo denovo


    Queue.start()

    #Queue.add_link( [{"url", "provider name"}] )
    #Queue.get_link_list()

  end
end

IO.puts inspect Webscraper.start()