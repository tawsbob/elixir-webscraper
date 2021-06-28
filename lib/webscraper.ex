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
  def hello do
    Webscraper.Product.new(%{
      og_image: "http://www.cdn.com/",
      brand: "brand",
      brand_slug: "brand_slug",
      product_name: "product_name",
      product_slug: "product_slug", 
    })
  end
end

IO.puts inspect Webscraper.hello()