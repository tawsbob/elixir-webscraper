defmodule WebscraperSpecListTest do
    use ExUnit.Case
  
    doctest Webscraper.Speclist

    alias Webscraper.Spec
    alias Webscraper.Speclist

    test "create a spec section" do
    
      single_spec = Spec.new(%{ label: "teste", content: "123" })
      spec_list   =  Speclist.new(%{ title: "Seção teste", specs: [single_spec] })
      
      #IO.inspect spec_list

      condition = is_struct(spec_list) and spec_list.title == "Seção teste"  and Enum.at(spec_list.specs, 0).label == "teste"
  
      assert condition
  
    end
  
    test "create a spec section without specs list" do
      
      spec_list =  Speclist.new(%{ title: "Seção teste", specs: [] })
      condition = is_struct(spec_list) and spec_list.title == "Seção teste"  and  length( spec_list.specs ) == 0
  
      #IO.inspect spec_list
  
      assert condition
  
    end

    test "create a spec section passing passing specs as wrong type" do
      
      spec_list =  Speclist.new(%{ title: "Seção teste", specs: "[]" })
      condition = is_struct(spec_list) and spec_list.title == "Seção teste"  and  is_list( spec_list.specs )
  
      IO.inspect spec_list
  
      assert condition
  
    end
  
  end
  