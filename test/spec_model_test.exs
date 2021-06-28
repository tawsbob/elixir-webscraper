defmodule WebscraperSpecTest do
    use ExUnit.Case
  
    doctest Webscraper.Spec
  
    alias Webscraper.Spec

    test "create a spec" do
      
      single_spec = Spec.new(%{ label: "teste", content: "123" })

      condition = is_struct(single_spec) and single_spec.label == "teste"

      assert condition
  
    end

    test "create a spec with content as wrong type" do
      
      single_spec = Spec.new(%{ label: "teste", content: 123 })

      condition = is_struct(single_spec) and single_spec.label == "teste" and single_spec.content == ""

      assert condition
  
    end
  
  end
  