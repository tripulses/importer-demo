require 'will_paginate/array'

class PeopleController < ApplicationController
  before_action :permit_params
  def index
    params[:page] ||= 1

    if params[:sort_by].present?
      @people = Person.all.sort_by {|person| [ person[params[:sort_by]] ? 0 : 1, person[params[:sort_by]]]}.paginate(page: params[:page], per_page: 10)
    else
      @people = Person.all.paginate(page: params[:page], per_page: 10)
    end
  end

  def search
    @people = Person.where("first_name = ? OR last_name = ? OR species = ? OR gender = ? OR weapon = ? OR vehicle = ?",
            params[:first_name], params[:last_name], params[:species], params[:gender], params[:weapon], params[:vehicle]
    ).paginate(page: params[:page], per_page: 10)
    
    @people = Person.all.paginate(page: params[:page], per_page: 10) if @people.blank?

    render 'index'
  end

  private
  def permit_params
    params.permit!
  end
end
