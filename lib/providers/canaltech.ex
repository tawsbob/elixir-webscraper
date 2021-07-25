defmodule Webscraper.Canaltech do

    alias Webscraper.Provider
    alias Webscraper.Product
    alias Webscraper.Helper
    alias Webscraper.Dom
    alias Webscraper.Speclist
    alias Webscraper.Spec

    @behaviour Provider

    @impl Provider
    def provider_name() do
        "canaltech"
    end

    @impl Provider
    def get_data( html_string ) do
        
        dom_model = Dom.str_html_to_dom_model( html_string )

        {image, ext} = get_image(dom_model)
        brand = get_brand(dom_model)
        brand_slug = Helper.slugfy(brand)
        product_name = get_product_name(dom_model)
        product_slug = Helper.slugfy(brand_slug <> "-" <> product_name)
        specifications_section = get_specs( dom_model )

        result = %{ 
            image: image,
            brand: brand,
            brand_slug: brand_slug,
            product_name: product_name, 
            product_slug: product_slug,
            specifications_section: specifications_section
        }

        Product.new(result)
    end
    
    @impl Provider
    def get_image( %Product{ image: image } ) do
        IO.puts image
        image
    end

    #module functions
    def get_brand(dom_model) do
        [{_, _, [brand | _]}] = Dom.find(dom_model, "h1.device-name a")
        brand
    end

    def get_product_name(dom_model) do
        [{_, _, contents }] = Dom.find(dom_model, "h1.device-name")
        [product_name] = Enum.filter(contents, fn cont -> is_binary(cont) end)
        String.trim(product_name)
      end

    def get_image( dom_model ) do
        image_url = Dom.get_attr( dom_model, "link[rel=image_src]", "href" )

        image = String.split(image_url, "/") 
        |> List.last
        |> String.replace(~r/^i/, "")

        ext = String.split(image, ".")
        |> List.last
        #DESCOBRI ISSO POR ACASO
       {"https://ib.canaltech.com.br/" <> image, ext}
    end

    def get_specs( dom_model ) do
        Dom.find(dom_model, "#specs ul.collapsible")
         |> Enum.map(
          fn element ->
            title = Dom.find(element, "div.collapsible-header span") |> Dom.text
            specs =  get_specs_from_node( element )

            Speclist.new(%{ title: title, specs: specs })
          end
         ) 
      end

      def get_specs_from_node( node ) do
        Dom.find(node, "div.collapsible-body table tr")
          |> Dom.find("tr")
          |> Enum.map(
            fn tr -> 
              label   = Dom.find(tr, "td:first-child") |> Dom.text
              content = Dom.find(tr, "td:last-child") |> Dom.text
              Spec.new(%{ label: label, content: content  })
            end
          )
      end

end