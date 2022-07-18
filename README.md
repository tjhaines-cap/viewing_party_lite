# Viewing Party

### About this Project

Viewing Part Lite is an application in which users can explore movie options and create a viewing party event for themselves and other users of the application.

## Installation

```
bundle install
bundle exec figaro install
```
add `tmdb_api_key: <you_key>` to `application.yml`
`rails db:create`
`rails dv:migrate`

## Setup for the use of the project

Worked on this project with Jenn Halloran. We set up the service, facade, and poro together to connect to the TMDB api. From there we each utilized the existing service to make api calls for our own parts of the project. 

This project begins with a welcome page where all existing users are listed with links to their dashboards. There is a button to create a new user which directs the user to a form to fill in teh name and email. The system checks that the email has not been previously used and that all fields are filled in and prompts the user to re-enter the fields if any information is not valid.   

## Versions

- Ruby 2.7.2

- Rails 5.2.6

Example wireframes to follow are found [here](https://backend.turing.io/module3/projects/viewing_party_lite/wireframes)
