class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionController::UrlWriter

  # sphinxable_resource / thinking sphinx indices
  define_index do
    indexes log_message, ip_address
    has created_at, :sortable => true

    # *** when support for nil is added in, these guys can go away 
    # indexes ["LOWER(`audit_events`.`log_message`)"], :as => :log_message_sort,  :sortable => true
    # indexes log_message, :sortable => true

  end


  # before the AuditEvent is saved, call the proc defined for this AuditType & class to assemble
  # appropriate log message
  before_create :assemble_log_message

  def event_type
    "#{auditable_type.upcase} #{audit_type.name}"
  end
  
  def user_link
    if user.nil?
      "Unknown User"
    else
      link_to(user.name, edit_admin_user_path(user))
    end
  end

  def audit_type_with_cast=(type)
    @event_type = type.to_sym
    type = AuditType.find_by_name(type.to_s.upcase)
    self.audit_type_without_cast = type
  end
  alias_method_chain :audit_type=, :cast

  private
  def assemble_log_message
    return false unless Audit.logging?
    self.log_message = self.auditable.class.log_formats[@event_type].call(self)
  end

end
