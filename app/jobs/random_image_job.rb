require "net/http"

class RandomImageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    uri = URI("https://tico09.com/photos/api/recent")

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new uri

      response = http.request request # Net::HTTPResponse object
      if response.is_a?(Net::HTTPSuccess)
        body = response.body
        body_json = JSON.parse(body)
        photos = body_json["photos"]
        random_photo= photos.sample
        Rails.cache.write("random_photo", random_photo)
      end
    end
  end
end
