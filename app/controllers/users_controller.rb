class UsersController < ApplicationController

    get "/sign_up" do
        erb :sign_up
    end

    get "/login" do
        if logged_in?
            redirect "/users/#{current_user.id}/index"
        else
            erb :"/users/login"
        end
    end

    get "/logout" do
        logout!
    end

    post "/users/index/" do
        login(params[:email], params[:password])
        binding.pry
        @current_user = User.find_by(email: session[:email])
        redirect "/users/#{@current_user.id}/index"
    end

    post "/users" do  # Missing error msg for email already being used
        users = User.all.map { |x| x.email}
        if users.include?(params[:email])
            redirect "/sign_up"
        else
            @user = User.new(email: params[:email], password: params[:password])
            if @user.save
                redirect "/login"
            else
                redirect "/sign_nup"
            end
        end
    end

    get "/users/:id/index" do
        @current_user = User.find_by(email: session[:email])
        @appointment_ids = Appointment.all.pluck(:user_id)   ## REFACTOR WITH @CURRENT_USER.APPOINTMENTS.FIRST.EMPLOYEE
        if @current_user.medicines.size > 0
            @medicine = @current_user.medicines
        end

        if @appointment_ids.include?(@current_user.id)
            @appointment = Appointment.find_by(user_id: @current_user.id)
            @doctor = Employee.find_by(id: @appointment.employee_id)
        end
        erb :"/users/index"
    end

    post "/users/:id/form" do
        @current_user = User.find_by(email: session[:email])
        @detail = Detail.new
        @detail.full_name = params[:full_name]
        @detail.dob = params[:dob]
        @detail.gender = params[:gender]
        @detail.address = params[:address]
        @detail.phone_number = params[:phone_number]
        @detail.user_id = @current_user.id
        @detail.save
        redirect "/users/#{@current_user.id}/index"
    end

    get "/users/:id/edit" do
        @current_user = User.find_by(email: session[:email])
        erb :"/users/edit"
    end

    patch "/users/:id/edit" do
        @current_user = User.find_by(email: session[:email])
        @current_user.detail.full_name = params[:full_name]
        @current_user.detail.phone_number = params[:phone_number]
        @current_user.detail.address = params[:address]
        @current_user.email = params[:email]
        @current_user.save
        binding.pry
        redirect "/users/#{@current_user.id}/index"
    end

end