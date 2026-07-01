class OnboardingController < ApplicationController

  def index # handles redirection
    # i don't want to add an onboarding step so have this until this gets too complicated
    if !@current_user.consent
      @current_step = "consent"
      render "consent"
    elsif !@current_user.role
      @current_step = "role"
      render "role"
    elsif !@current_user.referral
      @current_step = "referral"
      render "referral"
    elsif @current_user.onboarding_complete
      # redirect
    else
      raise "Did not fit any criteria for onboarding."
    end
  end

  def update # will handle updates
    if @current_user.update(onboarding_params)
      if params[:current_step] == "referral"
        if @current_user.update(onboarding_complete: true)
          redirect_to onboarding_path, status: :see_other
        else
          flash.now[:error] = "Could not complete onboarding, try again"
          render params[:current_step], status: :internal_server_error
        end
      end
      redirect_to onboarding_path, status: :see_other
    else
      flash.now[:error] = "Couldn't update user, try again"
      render params[:current_step], status: :unprocessable_entity
    end
  end

  private

  def onboarding_params
    params.require(:user).permit(:consent, :role, :referral, :onboarding_complete)
  end
end
