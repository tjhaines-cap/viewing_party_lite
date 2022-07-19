# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'login form page', type: :feature do
  it 'has form for user to login' do
    user1 = User.create!(name: 'Jane Powell', email: 'jpowell38@gmail.com', password: 'test123')

    visit '/login'

    fill_in :email, with: 'jpowell38@gmail.com'
    fill_in :password, with: 'test123'
    click_button('Login')

    expect(current_path).to eq('/dashboard')
  end

  it 'displays error if either invalid email or invalid password entered' do
    user1 = User.create!(name: 'Jane Powell', email: 'jpowell38@gmail.com', password: 'test123')

    visit '/login'

    fill_in :email, with: 'jpowel@gmail.com'
    fill_in :password, with: 'test123'
    click_button('Login')

    expect(current_path).to eq('/login')
    expect(page).to have_content('Invalid Credentials')

    visit '/login'

    fill_in :email, with: 'jpowell38@gmail.com'
    fill_in :password, with: 'wrong'
    click_button('Login')

    expect(current_path).to eq('/login')
    expect(page).to have_content('Invalid Credentials')
  end
end
