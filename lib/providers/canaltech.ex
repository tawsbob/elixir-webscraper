defmodule Webscraper.Canaltech do

    alias Webscraper.Provider
    alias Webscraper.Dom
    
    @behaviour Provider

    #@provider_name = "canaltech"

    @impl Provider
    def get_data( html_string ) do
        html_string
    end
    
    @impl Provider
    def get_image( image_url ) do
        image_url
    end
end