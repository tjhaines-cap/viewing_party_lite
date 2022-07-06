# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'landing page', type: :feature do
  it 'displays the title of the application, a button to create new users, and existing users' do
    user1 = User.create!(name: 'Jane Powell', email: 'jpowell38@gmail.com')
    user2 = User.create!(name: 'Ann Miller', email: 'amiller@gmail.com')
    visit '/'

    expect(page).to have_content('Viewing Party Light')
    expect(page).to have_link('Home')
    click_link('Home')
    expect(current_path).to eq('/')
    expect(page).to have_button('Create a New User')
    # click_button('Create a New User')
    # expect(current_path).to eq('/register')
    # visit '/'
    expect(page).to have_content('Existing Users:')
    within '#user-0' do
      expect(page).to have_link("Jane Powell's Dashboard")
      expect(page).to_not have_link("Ann Miller's Dashboard")
      # click_link("Jane Powell's Dashboard")
      # expect(current_path).to eq("/users/#{user1.id}")
      # visit "/"
    end
    within '#user-1' do
      expect(page).to have_link("Ann Miller's Dashboard")
      expect(page).to_not have_link("Jane Powell's Dashboard")
      # click_link("Ann Miller's Dashboard")
      # expect(current_path).to eq("/users/#{user2.id}")
    end
  end
end