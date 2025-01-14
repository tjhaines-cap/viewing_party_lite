# frozen_string_literal: true

class UserMoviesController < ApplicationController
  def index
    if params[:q] == 'top rated'
      @top_movies = MovieFacade.top_rated_movies
    elsif params[:search].strip == ''
      redirect_to "/users/#{params[:user_id]}/discover"
      flash[:alert] = 'Uh oh, something went wrong. Please try again.'
    elsif params[:search]
      @movie_search_results = MovieFacade.search(params[:search])
    end
  end

  def show
    @user = User.find(params[:user_id])
    @movie = MovieFacade.movie_details(params[:movie_id])
    @cast = @movie.cast[0..9]
  end
end
