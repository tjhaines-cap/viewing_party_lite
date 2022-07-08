# frozen_string_literal: true

require 'rails_helper'

describe 'user show page (dashboard)' do
  before do
    @user1 = User.create!(name: 'Jane', email: 'eleven@upsidedown.com')
    @user2 = User.create!(name: 'Dustin', email: 'hellfire@hawkins.edu')
    visit user_path(@user1)
  end
  it 'displays the users name' do
    expect(page).to have_content("Jane's Dashboard")
    expect(page).to_not have_content("Dustin's Dashboard")
  end

  it 'has a button to link to the users movie discover page' do
    click_button('Discover Movies')

    expect(current_path).to eq("/users/#{@user1.id}/discover")
  end

  # it 'has a section to display the users viewing parties'
  # viewing_party1 = 
end
