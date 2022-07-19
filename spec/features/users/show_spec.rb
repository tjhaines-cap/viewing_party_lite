# frozen_string_literal: true

require 'rails_helper'

describe 'user show page (dashboard)' do
  before do
    @user1 = User.create!(name: 'Jane', email: 'eleven@upsidedown.com', password: 'test123')
    @user2 = User.create!(name: 'Dustin', email: 'hellfire@hawkins.edu', password: 'test123')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end
  it 'displays the users name' do
    visit '/dashboard'

    expect(page).to have_content("Jane's Dashboard")
    expect(page).to_not have_content("Dustin's Dashboard")
  end

  it 'has a button to link to the users movie discover page', :vcr do
    visit '/dashboard'
    click_button('Discover Movies')

    expect(current_path).to eq("/discover")
  end

  it 'has a section to display the users viewing parties', :vcr do
    party1 = ViewingParty.create!(date: Date.today, start_time: Time.now, duration: 180, movie_id: 120)
    party2 = ViewingParty.create!(date: Date.today, start_time: Time.now, duration: 80, movie_id: 1362)
    party3 = ViewingParty.create!(date: Date.today, start_time: Time.now, duration: 80, movie_id: 121)

    user_party1 = UserViewingParty.create!(user: @user1, viewing_party: party1, hosting: true)
    user_party2 = UserViewingParty.create!(user: @user2, viewing_party: party1, hosting: false)

    user_party3 = UserViewingParty.create!(user: @user1, viewing_party: party2, hosting: false)
    user_party4 = UserViewingParty.create!(user: @user2, viewing_party: party2, hosting: true)

    visit '/dashboard'

    within "#viewing-party#{party1.id}" do
      find("img[src='https://image.tmdb.org/t/p/w185/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg']")
      expect(page).to have_content(party1.movie.title)
      expect(page).to_not have_content(party2.movie.title)
      expect(page).to have_content(party1.formatted_date)
      expect(page).to have_content(party1.formatted_time.strip)
    end

    expect(page).to have_content(party2.movie.title)
    expect(page).to_not have_content(party3.movie.title)
  end

  it 'links to each movies details page', :vcr do
    party1 = ViewingParty.create!(date: Date.today, start_time: Time.now, duration: 180, movie_id: 120)
    user_party1 = UserViewingParty.create!(user: @user1, viewing_party: party1, hosting: true)

    visit '/dashboard'

    within "#viewing-party#{party1.id}" do
      click_link(party1.movie.title)
      expect(current_path).to eq("/movies/#{party1.movie.id}")
    end
  end

  it 'displays whether the user is the host or an attendee', :vcr do
    party1 = ViewingParty.create!(date: Date.today, start_time: Time.now, duration: 180, movie_id: 120)
    party2 = ViewingParty.create!(date: Date.today, start_time: Time.now, duration: 80, movie_id: 1362)

    user_party1 = UserViewingParty.create!(user: @user1, viewing_party: party1, hosting: true)
    user_party2 = UserViewingParty.create!(user: @user2, viewing_party: party1, hosting: false)

    user_party3 = UserViewingParty.create!(user: @user1, viewing_party: party2, hosting: false)
    user_party4 = UserViewingParty.create!(user: @user2, viewing_party: party2, hosting: true)

    visit '/dashboard'

    within "#viewing-party#{party1.id}" do
      expect(page).to have_content('You are hosting!')
      within '.attendees' do
        expect(page).to have_content('Dustin (hellfire@hawkins.edu)')
        expect(page).to_not have_content('Jane (eleven@upsidedown.com)')
      end
    end

    within "#viewing-party#{party2.id}" do
      expect(page).to have_content('Dustin is hosting a party!')
      within '.attendees' do
        expect(page).to have_content('Jane (eleven@upsidedown.com)')
      end
    end
  end
end
