module Admin::AuditsHelper

  def audited_ip_addresses
    @audited_ip_addresses ||= AuditEvent.find(:all, :select => :ip_address, :group => :ip_address).map(&:ip_address).compact
  end

  def audited_users
    @audited_users ||= AuditEvent.find(:all, :group => :user_id, :include => :user, :order => 'users.login').map(&:user).compact
  end

  def audited_event_types
    @audited_event_types ||= AuditEvent.find(:all, :select => 'auditable_type, audit_type_id', :group => 'auditable_type, audit_type_id').map(&:event_type).compact.sort
  end

  def filters_set?
    [params[:ip], params[:user], params[:event_type], params[:log], params[:auditable_id], params[:auditable_type]].compact.any?
  end

  def reverse_direction
    (params[:direction] == 'asc') ? 'desc' : 'asc'
  end
  
  def event_user_name(event)
    event.user.try(:login) || '(Unknown)'
  end

  def item_link
    case @item
    when Page : link_to @item.title, edit_admin_page_path(@item)
    when Snippet : link_to @item.name, edit_admin_snippet_path(@item)
    when Layout : link_to @item.name, edit_admin_layout_path(@item)
    when User : link_to @item.login, edit_admin_user_path(@item)
    when nil
      if params[:auditable_type] and params[:auditable_id] and AuditEvent.find_by_auditable_type_and_auditable_id(params[:auditable_type], params[:auditable_id])
        "#{(h params[:auditable_type]).camelcase} ##{h params[:auditable_id]} (deleted)"
      end
    end
  end
end
