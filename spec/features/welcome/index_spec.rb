# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'landing page', type: :feature do
  it 'displays the title of the application, a button to create new users, and existing users' do
    user1 = User.create!(name: 'Jane Powell', email: 'jpowell38@gmail.com', password: 'test123')
    user2 = User.create!(name: 'Ann Miller', email: 'amiller@gmail.com', password: 'test123')
    visit '/'

    expect(page).to have_content('Viewing Party Light')
    expect(page).to have_link('Home')
    click_link('Home')
    expect(current_path).to eq('/')
    expect(page).to have_button('Create a New User')
    click_button('Create a New User')
    expect(current_path).to eq('/register')
    visit '/'
    expect(page).to have_button('Login')
    click_button('Login')
    expect(current_path).to eq('/login')
    visit '/'
    expect(page).to_not have_content('Existing Users:')
    expect(page).to_not have_content("amiller@gmail.com")
    expect(page).to_not have_content("jpowell38@gmail.com")
  end

  it 'has logout button if user is logged in' do
    user1 = User.create!(name: 'Jane Powell', email: 'jpowell38@gmail.com', password: 'test123')
    user2 = User.create!(name: 'Ann Miller', email: 'amiller@gmail.com', password: 'test123')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
    visit '/login'
    fill_in :email, with: 'jpowell38@gmail.com'
    fill_in :password, with: 'test123'
    click_button('Login')

    visit '/'

    expect(page).to have_button('Logout')
    expect(page).to_not have_button('Login')
    expect(page).to_not have_button('Create a New User')
    expect(page).to have_content('Existing Users:')
    within '#user-0' do
      expect(page).to have_content("jpowell38@gmail.com")
      expect(page).to_not have_content("amiller@gmail.com")
    end
    within '#user-1' do
      expect(page).to have_content("amiller@gmail.com")
      expect(page).to_not have_content("jpowell38@gmail.com")
    end

    click_button('Logout')

    expect(current_path).to eq('/')
    expect(page).to_not have_button('Logout')
    expect(page).to have_button('Login')
    expect(page).to have_button('Create a New User')
    expect(page).to_not have_content('Existing Users:')
    expect(page).to_not have_content("amiller@gmail.com")
    expect(page).to_not have_content("jpowell38@gmail.com")
  end

  it 'displays error message if user tries to go to /dashboard without logging in' do
    user1 = User.create!(name: 'Jane Powell', email: 'jpowell38@gmail.com', password: 'test123')
    user2 = User.create!(name: 'Ann Miller', email: 'amiller@gmail.com', password: 'test123')
    
    visit '/dashboard'

    expect(current_path).to eq('/')
    expect(page).to have_content('You must be logged in to access your dashboard')
  end
end
