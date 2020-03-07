class ReviewController < ApplicationController

    get "/users/new_review" do
        @current_user = User.find_by(email: session[:email])
        erb :"/reviews/new"
    end

    post "/review/new" do
        @current_user = User.find_by(email: session[:email])
        @review = Review.new
        @review.title = params[:title]
        @review.content = params[:content]
        @review.rating = params[:rating]
        @review.date = DateTime.current.to_date
        @review.save

        redirect "/users/#{@current_user.id}/index"
    end

    get "/reviews" do
        @current_employee = Employee.find_by(email: session[:email])
        @current_user = User.find_by(email: session[:email])
        @reviews = Review.all
        erb :"/reviews/reviews"
    end

end