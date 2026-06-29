class PagesController < ApplicationController
  skip_before_action :require_login
  
  def index
    @photo = Rails.cache.read("random_photo")
    if @photo == nil
      @photo = ""
    else
      @author = @photo["author"]
      @acft = @photo["airline"]
      @photo = @photo["url"]
    end
  end
end
