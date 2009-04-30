class AuditsController < ApplicationController

  sphinx_resource   :sortable_attributes =>['created_at'],
                    :filterable_attributes => ['auditable_type', 'user_id', 'ip_address', 'audit_type_id', 'auditable_id'],
                    :range_attributes => ['created_at'],
                    :default_sort => "created_at",
                    :per_page => 100

  def index

    params[:filter] ||= {} # in case no filter params are sent, don't choke on the params[:filter][:foo] below
    
    if params[:report].blank?
      # filter by Event Type
      if !params[:event_type].blank?
        # event type comes through as "AUDITABLETYPE AUDITTYPE"; need to find both
        auditable_type, audit_type = params[:event_type].split(" ")
        audit_type_id = AuditType.find_by_name(audit_type).id
        params[:filter][:audit_type_id] = audit_type_id
        # convert "AUDITABLETYPE" => "Auditabletype"- it's a class name
        params[:filter][:auditable_type] = auditable_type.capitalize
      end

      # browse-by-date only shows one day at a time
      @startdate = params[:startdate].blank? ? Date.today : Date.parse(params[:startdate])
      @enddate = @startdate

      # calculate next and previous dates 
      @next_date = AuditEvent.find(:first, :select => :created_at, :conditions => ["created_at > ?", @enddate.next], :order => "created_at ASC")
      @previous_date = AuditEvent.find(:first, :select => :created_at, :conditions => ["created_at < ?", @startdate], :order => "created_at DESC")
      @next_date = @next_date.created_at unless @next_date.nil?
      @previous_date = @previous_date.created_at unless @previous_date.nil?

      # BROWSE-BY-DATE specific stuff
      @auditmenus = AuditEvent.find(:all, :conditions => ["created_at > :startdate AND created_at < :enddate", {:startdate => @startdate, :enddate => @enddate.next}])
      # some helper arrays for filter options
      @ip_addresses = @auditmenus.map(&:ip_address).uniq.compact
      @users = @auditmenus.map(&:user).uniq.compact
      @event_types = @auditmenus.collect { |a| a.event_type }.uniq.compact
      
    else
      # CUSTOM REPORT specific stuff
      if !params[:audit_type_name].blank?
        params[:filter][:audit_type_id] = AuditType.find_by_name(params[:audit_type_name]).id rescue nil
      end
      
      @startdate = params[:startdate].blank? ? "" : Date.parse(params[:startdate])
      # make enddate inclusive- show events through the enddate specified
      @enddate = params[:enddate].blank? ? "" : Date.parse(params[:enddate])
      
    end

    # date range
    # ThinkingSphinx apparently doesn't take logical operators, so we always need to provide it with an upper and lower bound for the date.
    if @startdate.blank?
      @startdate = AuditEvent.minimum(:created_at)
    end
    if @enddate.blank?
      @enddate = Date.today
    end
    
    params[:range] = "created_at" unless (@startdate.blank? && @enddate.blank?)
    params[:low] = Time.local(@startdate.year, @startdate.month, @startdate.day)
    # high = last second of the day
    params[:high] = Time.local(@enddate.year, @enddate.month, @enddate.day, 23, 59, 59)

    # default to sort by descending date
    params[:direction] ||= 'desc'
    
    # search for our audits with a little help from our friend Sphinx-it!
    @audits = AuditEvent.search(sphinxed_search_terms, sphinxed_search_conditions)

  end
end
