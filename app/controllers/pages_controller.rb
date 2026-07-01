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
    # testing flashes, try not to comment this out in dev unless you need to spot check
    # flash.now[:error] = "test"
    # flash.now[:notice] = "test, notice"
    # flash.now[:success] = "test, success"
    # flash.now[:warning] = "test, warning"
  end
end
