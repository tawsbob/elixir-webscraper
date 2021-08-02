defmodule Webscraper.Product do
    
    
    alias Webscraper.Model
    alias Webscraper.Helper

    @behaviour Model
    @enforce_keys [ :brand, :product_name, :product_slug ]

    defstruct   image: "",
                scrape_image: "",
                brand: "",
                brand_slug: "",
                product_name: "",
                product_slug: "",
                specifications_section: []

    @type t :: %__MODULE__{
        image: String.t(),
        scrape_image: String.t(),
        brand: String.t(),
        brand_slug: String.t(),  
        product_name: String.t(),  
        product_slug: String.t(),
        specifications_section: list(%Webscraper.Speclist{})
    }
    
    @doc """
    new/1 create a new Product Struct

    ## Parameters
    - product_map: a map of key value

    ## product_map keys

    - image: String
    - scrape_image: String
    - brand: String
    - brand_slug: String
    - product_name: String
    - product_slug: String
    - specifications_section: List [%Speclist{}]
    """
    
    @impl Model
    @spec new( map() ) :: %__MODULE__{}
    def new( product_map ) when is_map(product_map) do

        %__MODULE__{
            image:   Helper.default_value_map(product_map, :image,  &is_binary/1, ""),
            scrape_image:   Helper.default_value_map(product_map, :scrape_image,  &is_binary/1, ""),
            brand:      Helper.default_value_map(product_map, :brand,  &is_binary/1, ""),
            brand_slug: Helper.default_value_map(product_map, :brand_slug,  &is_binary/1, ""),
            product_name: Helper.default_value_map(product_map, :product_name,  &is_binary/1, ""),
            product_slug: Helper.default_value_map(product_map, :product_slug,  &is_binary/1, ""),
            specifications_section:    Helper.default_value_map(product_map, :specifications_section,  &is_list/1, []),
        }

    end

    

end