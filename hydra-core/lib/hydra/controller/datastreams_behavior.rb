module Hydra::Controller::DatastreamsBehavior
  extend ActiveSupport::Concern
  
  included do
    include Hydra::Controller::ControllerBehavior
    include Hydra::Controller::UploadBehavior
    include Blacklight::SolrHelper
    before_filter :require_solr, :only=>[:index, :create, :show, :destroy]
    before_filter :enforce_access_controls
    # need to include this after the :require_solr/fedora before filters because of the before filter that the workflow provides.
    #include Hydra::SubmissionWorkflow
    prepend_before_filter :sanitize_update_params
    helper :hydra_uploader
    rescue_from ActiveFedora::ObjectNotFoundError, :with=>:fedora_object_not_found
  end
  
  def fedora_object_not_found
    flash[:notice] = "No object exists for #{params.delete(:pid)}"
    @container = nil
    @datastreams = {}
    render :controller=>'catalog', :action=>:index, :status=>404
  end
  
  def datastream_not_found
    flash[:notice] = "No #{params.delete(:dsid)} datastream exists for #{params.delete(:pid)}"
    @container = nil
    @datastreams = {}
    render :action=>:index, :status=>404
  end
  
  def load_permissions_from_solr(id=params[:asset_id], extra_controller_params={})
    super
  end
  
  def enforce_access_controls(opts={})
    params[:id] ||= params[:pid]
    super
  end
  
  def index
    if params[:layout] == "false"
      layout = false
    end
    unless params[:pid].nil?
      # It would be nice to handle these in a callback (before_render :yyy)
      @container =  ActiveFedora::Base.load_instance(params[:pid])
      @datastreams = @container.datastreams(params[:dsid])
      render :action=>params[:action], :layout=>layout
    else
      # What are we doing here without a containing object?
      flash[:notice] = "called DatastreamsController#index without containing object"
      @container = nil
      @datastreams = {}
      render :action=>params[:action], :layout=>layout, :status=>404
    end
  end
  
  def enforce_index_permissions(opts={})
    enforce_read_permissions
  end
  
  # Creates and Saves a Datastream to contain the the Uploaded file 
  def create
    if params[:pid].nil?
      raise "Cannot created a datastream without a containing object"
    else
      @container =  ActiveFedora::Base.load_instance(params[:pid])
    end

    if params[:dsid].nil?
      raise "Cannot created a datastream without a datastream id"
    end

    if params.has_key?(:Filedata)
      file_name = filename_from_params
      mime_type = params[:mime_type] || mime_type(file_name)
      @container.add_file_datastream(posted_file, :dsid=>params[:dsid], :label=>file_name, :mimeType=>mime_type, :size=>posted_file.size)
      @container.save

      flash[:notice] = "The file #{params[:Filename]} has been saved as #{params[:dsid]} in <a href=\"#{asset_url(@container.pid)}\">#{@container.pid}</a>."
    elsif params.has_key?(:Source)
      file_name = filename_from_url(params[:Source])
      mime_type = params[:mime_type] || mime_type(file_name)
      control_group = params.fetch(:control_group,'M')
      ds_props = {:dsid=>params[:dsid], :label=>file_name, :mimeType=>mime_type, :dsLocation=>params[:Source], :control_group=>control_group}
      @container.add_datastream(ActiveFedora::Datastream.new(ds_props))
      @container.save

      flash[:notice] = "#{params[:Source]} has been saved as #{params[:dsid]} in <a href=\"#{asset_url(@container.pid)}\">#{@container.pid}</a>."
    else
      flash[:notice] = "You must specify a file to upload or a source URL."
    end

    unless params[:pid].nil?
      redirect_params = {:controller=>"catalog", :id=>params[:pid], :action=>:edit}
    end

    redirect_params ||= {:action=>:index}

    redirect_to redirect_params
  end
    
  def enforce_create_permissions(opts={})
    enforce_edit_permissions(opts)
  end
  
  def update
    create
  end
  
  def show
    @container = ActiveFedora::Base.find(params[:pid])
    if (@container.nil?)
      # this is where 404 (no such object) happens
      logger.warn("No such fedora object: " + params[:pid])
      flash[:notice]= "No such fedora object."
      redirect_to(:action => 'index', :q => nil , :f => nil)
      return
    else
      if @container.datastreams_in_memory.include?(params[:dsid])
        ds = @container.datastreams_in_memory[params[:dsid]]
        opts = {:filename => ds.label}
        if params[:mime_type].nil?
          opts[:type] = ds.attributes["mimeType"]
        else
          opts[:type] = params[:mime_type]
        end
        if params[:disposition].nil?
          opts[:disposition] = "attachment"
        else
          opts[:disposition] = params[:disposition]
        end
        send_data ds.content, opts
        return
      else
        index
        render 'index', :status=>404
      end
    end
  end
  
  # this is the default impl, but with a redirection to catalog#index rather than #index.  Need some DRY refactoring here.
  def enforce_show_permissions(opts={})
    load_permissions_from_solr
    unless @permissions_solr_document['access_t'] && (@permissions_solr_document['access_t'].first == "public" || @permissions_solr_document['access_t'].first == "Public")
      if @permissions_solr_document["embargo_release_date_dt"] 
        embargo_date = Date.parse(@permissions_solr_document["embargo_release_date_dt"].split(/T/)[0])
        if embargo_date > Date.parse(Time.now.to_s)
          # check for depositor raise "#{@document["depositor_t"].first} --- #{user_key}"
          ### Assuming we're using devise and have only one authentication key
          unless current_user && user_key == @permissions_solr_document["depositor_t"].first
            flash[:notice] = "This item is under embargo.  You do not have sufficient access privileges to read this document."
            redirect_to(:controller=>'catalog', :action => 'index', :q => nil , :f => nil) and return false
          end
        end
      end
      unless reader?
        flash[:notice]= "You do not have sufficient access privileges to read this document, which has been marked private."
        redirect_to(:controller=>'catalog', :action => 'index', :q => nil , :f => nil) and return false
      end
    end
  end
  
  
  def destroy
    @container = ActiveFedora::Base.load_instance(params[:pid])
    @container.datastreams[params[:dsid]].delete
    render :text => "Deleted #{params[:dsid]} from #{params[:pid]}."
    @container.save
  end  
end