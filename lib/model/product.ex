defmodule Webscraper.Product do

    alias Webscraper.Helper

    @enforce_keys [ :brand, :product_name ]

    defstruct   og_image: "",
                brand: "",
                brand_slug: "",
                product_name: "",
                product_slug: "",
                spec_list: []

    @type t :: %__MODULE__{
        og_image: String.t(),
        brand: String.t(),
        brand_slug: String.t(),  
        product_name: String.t(),  
        product_slug: String.t(),
        spec_list: list(%Webscraper.Speclist{})
    }
    
    @spec new( map() ) :: %__MODULE__{}
    def new( product_map ) when is_map(product_map) do

        %__MODULE__{
            og_image:   Helper.default_value_map(product_map, :og_image, ""),
            brand:      Helper.default_value_map(product_map, :brand, ""),
            brand_slug: Helper.default_value_map(product_map, :brand_slug, ""),
            product_name: Helper.default_value_map(product_map, :product_name, ""),
            product_slug: Helper.default_value_map(product_map, :product_slug, ""),
            spec_list:    Helper.default_value_map(product_map, :spec_list, []),
        }

    end

    

end