require 'will_paginate/array'

class PeopleController < ApplicationController
  before_action :permit_params

  def index
    params[:page] ||= 1
    @locations = []
    @affiliations = []

    if params[:sort_by].present?
      @people = Person.all.sort_by {|person| [ person[params[:sort_by]] ? 0 : 1, person[params[:sort_by]]]}.paginate(page: params[:page], per_page: 10)
    else
      @people = Person.all.paginate(page: params[:page], per_page: 10)
    end

    @locations = get_loc_aff('locations')
    @affiliations = get_loc_aff('affiliations')
  end

  def search
    @people = Person.where("first_name = ? OR last_name = ? OR species = ? OR gender = ? OR weapon = ? OR vehicle = ?",
            params[:first_name], params[:last_name], params[:species], params[:gender], params[:weapon], params[:vehicle]
    ).paginate(page: params[:page], per_page: 10)
    
    @people = Person.all.paginate(page: params[:page], per_page: 10) if @people.blank?
    @locations = get_loc_aff('locations')
    @affiliations = get_loc_aff('affiliations')

    render 'index'
  end

  private

  def permit_params
    params.permit!
  end

  def get_loc_aff(field)
    field_list = []
    affiliations = []
    locations = []

    if field == 'locations'
      @people.each do |person|
        if person.locations&.count > 1
          person.locations&.each do |location|
            field_list << location.location_name
          end
          locations << field_list.join(', ')
        else
          locations << person.locations.first.location_name
        end

        field_list = []
      end

      return locations
    elsif field == 'affiliations'
      @people.each do |person|
        if person.affiliations&.count > 1
          person.affiliations&.each do |affiliation|
            field_list << affiliation.affiliation_name
          end
          affiliations << field_list.join(', ')
        else
          affiliations << person.affiliations.first.affiliation_name
        end

        field_list = []
      end

      return affiliations
    end
  end
end
