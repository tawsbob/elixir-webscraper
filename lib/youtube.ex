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
            {:ok, json_decoded} -> 

                [ el ,_] = json_decoded["contents"]["twoColumnSearchResultsRenderer"]["primaryContents"]["sectionListRenderer"]["contents"]
                
                videos = Enum.map(
                    el["itemSectionRenderer"]["contents"],
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
            _ -> nil
        end
    end

    def save( data ) do

        case File.write!("./data-1.json", data) do
            :ok -> 
                IO.puts "Image saved as well \n"
                :ok
            _ -> IO.puts "Error on save"
          end
    end  

end