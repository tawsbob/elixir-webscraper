defmodule WebscraperProductTest do
    use ExUnit.Case
  
    doctest Webscraper.Product
    
    alias Webscraper.Product
    alias Webscraper.Spec
    alias Webscraper.Speclist

    test "create a new product with a empty spec list" do
  
      new_product = Product.new(%{
        image: "http://www.cdn.com/",
        brand: "brand",
        brand_slug: "brand_slug",
        product_name: "product_name",
        product_slug: "product_slug",
        specifications_section: []
      })
      
      assert %Product{
        brand: "brand",
        brand_slug: "brand_slug",
        image: "http://www.cdn.com/",
        product_name: "product_name",
        product_slug: "product_slug",
        specifications_section: []
      } = new_product
          
  
    end
  
    test "create a new product with spec list filled" do
  
      single_spec = Spec.new(%{ label: "teste", content: "123" })
      specifications_section   =  Speclist.new(%{ title: "Seção teste", specs: [single_spec] })
  
      new_product = Product.new(%{
        image: "http://www.cdn.com/",
        brand: "brand",
        brand_slug: "brand_slug",
        product_name: "product_name",
        product_slug: "product_slug",
        specifications_section: specifications_section
      })
      
      
      assert %Product{
        brand: "brand",
        brand_slug: "brand_slug",
        image: "http://www.cdn.com/",
        product_name: "product_name",
        product_slug: "product_slug",
        specifications_section: %Speclist{
          specs: [%Spec{content: "123", label: "teste"}],
          title: "Seção teste"
        }
      } = new_product
                
  
    end
  
  end
  