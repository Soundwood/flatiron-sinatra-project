class VehiclesController < ApplicationController
    get '/vehicles' do
        redirect_if_logged_out
        @vehicles = Vehicle.all
        erb :'/vehicles/index'
    end
    get '/vehicles/new' do
        redirect_if_logged_out
        erb :'/vehicles/new'
    end
    
    post '/vehicles' do
        @location = Vehicle.create(params[:location])
        if !params["vehicle"]["vin"].empty?
            @location.vehicle << Vehicle.create(vin: params["vehicle"]["vin"])
        end
        redirect "/owners/#{@owner.id}"
    end
    
    get '/vehicles/:id/edit' do
        redirect_if_logged_out
        @vehicle = Vehicle.find(params[:id])
        erb :'/vehicles/edit'
    end
    get '/vehicles/unauth_for_vehicle' do
        erb :'/vehicles/unauth_access'
    end
    get '/vehicles/:id' do 
        redirect_if_logged_out
        @vehicle = Vehicle.find(params[:id])
        
        redirect_if_unauth_user(@vehicle.user_id)
        erb :'/vehicles/show'
    end
    patch '/vehicles/:id' do 
        @vehicle = Vehicle.find(params[:id])
        if !params["vehicle"]["vin"].empty? && !params["vehicle"]["model"].empty? && !params["vehicle"]["sub_model"].empty?
            @vehicle.update(params["vehicle"])
            redirect "/vehicles/#{@vehicle.id}"
        else
            redirect "/vehicles/#{@vehicle.id}"
        end
    end
    helpers do 
        def redirect_if_unauth_user(user_id)
            redirect to '/vehicles/unauth_for_vehicle' unless current_user.id == user_id
        end
    end
end