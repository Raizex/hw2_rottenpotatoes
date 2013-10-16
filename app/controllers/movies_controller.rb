class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    

    if params[:ratings] != session[:ratings] || params[:order] != session[:order]
      session.merge!(params) # update session
      params[:order] = session[:order]  # reconstruct params to reflect updated session
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to movies_path(params) # redirect using new parameters
    end

    @all_ratings = Movie.all_ratings
    params[:ratings].nil? ? @ratings = @all_ratings : @ratings = params[:ratings].keys
    @movies = Movie.where(:rating => @ratings).order(params[:order])

    # if params[:ratings] && params[:order]
    #   session[:ratings] = params[:ratings]
    #   @ratings = params[:ratings].keys

    #   session[:order] = params[:order]
    #   order = params[:order]
    # elsif session[:ratings] && session[:order]
    #   params[:ratings] = session[:ratings]
    #   flash.keep
    #   redirect_to movies_path(params)
    # else
    #   @ratings = @all_ratings
    # end

    # if params[:order]
    #   session[:order] = params[:order]
    #   order = params[:order]
    # elsif session[:order]
    #   params[:order] = session[:order]
    #   flash.keep
    #   redirect_to movies_path(params)
    # else
    #   order = nil
    # end

        

    
    @movies = Movie.where(:rating => @ratings).order(params[:order])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
