defmodule WebscraperProductTest do
    use ExUnit.Case
  
    doctest Webscraper.Product
    
    alias Webscraper.Product
    alias Webscraper.Spec
    alias Webscraper.Speclist

    test "create a new product with a empty spec list" do
  
      new_product = Product.new(%{
        og_image: "http://www.cdn.com/",
        brand: "brand",
        brand_slug: "brand_slug",
        product_name: "product_name",
        product_slug: "product_slug",
        spec_list: []
      })
      
      check_was_attrs = new_product.og_image == "http://www.cdn.com/" and new_product.brand == "brand" and new_product.product_name == "product_name"
  
      #IO.inspect new_product
  
      assert check_was_attrs
          
  
    end
  
    test "create a new product with spec list filled" do
  
      single_spec = Spec.new(%{ label: "teste", content: "123" })
      spec_list   =  Speclist.new(%{ title: "Seção teste", specs: [single_spec] })
  
      new_product = Product.new(%{
        brand: "brand",
        product_name: "product_name",
        spec_list: spec_list
      })
  
      #IO.inspect new_product
  
      condition = new_product.brand == "brand" and new_product.spec_list.title == "Seção teste" and length(new_product.spec_list.specs) > 0

      assert condition
          
  
    end
  
  end
  