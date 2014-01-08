class InventoryController < ApplicationController

require "#{Rails.root}/lib/mosh_modules/management_module"
include MoshModules::ManagementModule
before_filter :management_filter

  def index
    @locations = Location.all
    if params[:location]
      @location = Location.find(params[:location])
    end

    @hardware_statuses = HardwareStatus.all
    if params[:hardware_status]
      @hardware_status = HardwareStatus.find(params[:hardware_status])
    end

    @hardware_types = HardwareType.all
    if params[:hardware_type]
      @hardware_type = HardwareType.find(params[:hardware_type])
    end
  end
end