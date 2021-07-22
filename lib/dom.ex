defmodule Webscraper.Dom do

    def str_html_to_dom_model( document_as_string ) when is_binary(document_as_string) do
        case Floki.parse_document(document_as_string) do
            {:ok, document} -> document
            _ -> nil
        end
    end

    def find( document, tag_selector ) do
        Floki.find(document, tag_selector)
    end

    def get_attr( node_model, attr ) do
        Floki.attribute( node_model, attr )
    end

    def get_node_text( node ) do
        Floki.text( node )
    end

end