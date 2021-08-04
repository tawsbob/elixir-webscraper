defmodule Webscraper.Youtube do

    alias Webscraper.Helper

    def get_videos(query) do
        url = "https://www.youtube.com/results?search_query=#{URI.encode(query)}"

        url
        |> Helper.http_request
        |> extract_data
    end


    def extract_data(html_string) do

        #regex = ~r/(?<=\sytInitialData\s\=)(.*)(?=\<\\script\>)/
        regex = ~r/var\sytInitialData\s\=(.*)\<\/script\>/
        result = Regex.run(regex, html_string)
        [ data, _ ] = result


        json = data
        |> String.replace("var ytInitialData = ", "")
        |> String.replace(~r/\;\<+(.*)/, "")
        |> JSON.decode

        case json do
            {:ok, json_decoded} -> get_primary_way(json_decoded)
            _ -> []
        end

    end

    def get_primary_way(json_decoded) do
        try do
            [ first , second | _ ] = json_decoded["contents"]["twoColumnSearchResultsRenderer"]["primaryContents"]["sectionListRenderer"]["contents"]
            if length( first["itemSectionRenderer"]["contents"]) == 1 do 
                get_videos_from_element( second )
            else 
                get_videos_from_element( first )
            end
        rescue
            e in RuntimeError -> 
                IO.puts("An error occurred: " <> e.message)
                save_json(json_decoded)
        end
    end

    def get_videos_from_element(element) do
        video_lenght = length( element["itemSectionRenderer"]["contents"] )
        IO.puts " ----- Scraping #{ video_lenght } videos ----- "

        videos = Enum.map(
                element["itemSectionRenderer"]["contents"],
                fn video_json ->
                    if video_json["videoRenderer"] do
                        video_id                =  video_json["videoRenderer"]["videoId"]
                        [%{ "text" => title}]   = video_json["videoRenderer"]["title"]["runs"]
                        [%{"text" => owner }]  = video_json["videoRenderer"]["ownerText"]["runs"]
                        %{video_id: video_id, title: title, owner: owner, provider: "youtube", product_id: "" }  
                    else
                    nil
                    end
                end
            )
        Enum.filter(videos, fn v -> v != nil end)
    end

    def save_json(json_decoded) do
        {:ok, json_decoded} = JSON.encode(json_decoded)
        save(json_decoded)
        []
    end

    def save( data ) do

        case File.write!("./data.json", data) do
            :ok -> 
                IO.puts "Image saved as well \n"
                :ok
            _ -> IO.puts "Error on save"
          end
    end  

end