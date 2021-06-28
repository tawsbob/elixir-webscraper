defmodule WebscraperSpecTest do
    use ExUnit.Case
  
    doctest Webscraper.Spec
  
    alias Webscraper.Spec

    test "create a spec" do
      
      single_spec = Spec.new(%{ label: "teste", content: 123 })

      assert single_spec.label == "teste"
  
    end
  
  end
  