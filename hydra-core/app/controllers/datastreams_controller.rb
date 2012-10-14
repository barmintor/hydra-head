class DatastreamsController < ApplicationController
  before_filter :rename_params
  def rename_params
    params[:dsid] ||= params[:id]
  end
  include Hydra::Controller::Datastreams
end