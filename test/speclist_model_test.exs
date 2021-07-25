defmodule WebscraperSpecListTest do
    use ExUnit.Case
  
    doctest Webscraper.Speclist

    alias Webscraper.Spec
    alias Webscraper.Speclist

    test "create a spec section" do
    
      single_spec = Spec.new(%{ label: "teste", content: "123" })
      specifications_section   =  Speclist.new(%{ title: "Seção teste", specs: [single_spec] })
      
      #IO.inspect specifications_section

      condition = is_struct(specifications_section) and specifications_section.title == "Seção teste"  and Enum.at(specifications_section.specs, 0).label == "teste"
  
      assert condition
  
    end
  
    test "create a spec section without specs list" do
      
      specifications_section =  Speclist.new(%{ title: "Seção teste", specs: [] })
      condition = is_struct(specifications_section) and specifications_section.title == "Seção teste"  and  length( specifications_section.specs ) == 0
  
      #IO.inspect specifications_section
  
      assert condition
  
    end

    test "create a spec section passing passing specs as wrong type" do
      
      specifications_section =  Speclist.new(%{ title: "Seção teste", specs: "[]" })
      condition = is_struct(specifications_section) and specifications_section.title == "Seção teste"  and  is_list( specifications_section.specs )
  
      #IO.inspect specifications_section
  
      assert condition
  
    end
  
  end
  