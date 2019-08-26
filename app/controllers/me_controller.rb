class MeController < ApplicationController
  before_action :authenticate
  def home
    @address = set_address
  end

  def update
    current_user.display_name = params['display_name']
    current_user.name = params['full_name']

    @address = set_address
    update_address

    if current_user.save && @address.save
      respond_to do |format|
        format.html { redirect_to '/me', notice: 'User info was updated.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/me', error: 'There was an error. Try again?' }
      end
    end
  end

  private

  def set_address
    return current_user.address if current_user.address.present?

    Address.new(user_id: current_user&.id)
  end

  def update_address
    @address.first_line = params['first_line']
    @address.second_line = params['second_line']
    @address.city = params['city']
    @address.county_province = params['county_province']
    @address.zip_or_postcode = params['zip_or_postcode']
    @address.country = params['country']
    @address.prize_level = params['prize_level']
  end

  def match_params
    params.permit(
      :full_name, :display_name,
      :first_line, :second_line, :city, :county_province,
      :zip_or_postcode, :country, :prize_level
    )
  end
end
