# frozen_string_literal: true

require 'rails_helper'

describe 'user new/registration page' do
  before do
    visit '/register'
  end
  it 'has a form to create a new user, and once created it redirects to the new users show page' do
    expect(page).to have_content('Register a New User')

    fill_in 'user[name]', with: 'Jane'
    fill_in 'user[email]', with: 'eleven@upsidedown.com'
    fill_in 'user[password]', with: 'Test123'
    fill_in 'user[password_confirmation]', with: 'Test123'
    click_button('Create New User')

    user = User.last

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content("Jane's Dashboard")
    expect(user.password_digest).to_not eq('Test123')
    expect(user).to have_attribute(:password_digest)
  end

  it 'displays an error message if the email entered is not unique' do
    user = User.create!(name: 'Jane', email: 'eleven@upsidedown.com', password: 'test123')

    fill_in 'user[name]', with: 'Max'
    fill_in 'user[email]', with: 'eleven@upsidedown.com'
    fill_in 'user[password]', with: 'Test123'
    fill_in 'user[password_confirmation]', with: 'Test123'
    click_button('Create New User')

    expect(current_path).to eq('/register')
    expect(page).to have_content('Oops, that email is already in use! Please try again with a unique email.')
    expect(user.password_digest).to_not eq('Test123')
    expect(user).to have_attribute(:password_digest)
  end

  it 'displays an error message if a name is not entered on the form' do
    fill_in 'user[name]', with: ''
    fill_in 'user[email]', with: 'eleven@upsidedown.com'
    fill_in 'user[password]', with: 'Test123'
    fill_in 'user[password_confirmation]', with: 'Test123'
    click_button('Create New User')

    expect(current_path).to eq('/register')
    expect(page).to have_content('Please enter a valid name.')
  end

  it 'displays an error message if a name is not entered on the form and the email is not unique' do
    User.create!(name: 'Jane', email: 'eleven@upsidedown.com', password: 'test123')

    fill_in 'user[name]', with: ''
    fill_in 'user[email]', with: 'eleven@upsidedown.com'
    fill_in 'user[password]', with: 'Test123'
    fill_in 'user[password_confirmation]', with: 'Test123'
    click_button('Create New User')

    expect(current_path).to eq('/register')
    expect(page).to have_content('Please enter a valid name and unique e-mail address.')
  end

  it 'displays an error message if the passwords do not match or are not provided' do
    fill_in 'user[name]', with: 'Thomas'
    fill_in 'user[email]', with: 'eleven@upsidedown.com'
    fill_in 'user[password]', with: 'Test123'
    fill_in 'user[password_confirmation]', with: 'Test'
    click_button('Create New User')

    expect(current_path).to eq('/register')
    expect(page).to have_content('Passwords do not match.')

    fill_in 'user[name]', with: 'Thomas'
    fill_in 'user[email]', with: 'eleven@upsidedown.com'
    fill_in 'user[password]', with: ''
    fill_in 'user[password_confirmation]', with: 'Test'
    click_button('Create New User')

    expect(current_path).to eq('/register')
    expect(page).to have_content('Please enter a password.')
  end
end
