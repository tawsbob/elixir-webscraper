defmodule Webscraper.Provider do

    @doc """
    A Provider abstraction to get data from site.
    """
    @callback get_data( binary() ) :: tuple()
    @callback provider_name() :: binary()

  end