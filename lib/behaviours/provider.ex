defmodule Webscraper.Provider do

    @doc """
    A Provider abstraction to get data from site.
    """
    @callback get_data( binary() ) :: struct()
    @callback get_image( binary() ) :: struct()

  end