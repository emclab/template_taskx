module TemplateTaskx
  class Task < ActiveRecord::Base
    attr_accessor :project_name, :customer_name, :project_task_template_name, :skipped_noupdate, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate
    attr_accessible :assigned_to_id, :brief_note, :cancelled, :completed, :expedite, :finish_date, :last_updated_by_id,
                    :project_id, :skipped, :start_date, :template_item_id, :task_status_id,
                    :project_name, :customer_name, :project_task_template_name, :skipped_noupdate, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate,
                    :as => :role_new
    attr_accessible :assigned_to_id, :brief_note, :cancelled, :completed, :expedite, :finish_date, :last_updated_by_id,
                    :project_id, :skipped, :start_date, :template_item_id, :task_status_id,
                    :project_name, :customer_name, :project_task_template_name, :skipped_noupdate, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate,
                    :as => :role_update
                    
    belongs_to :project, :class_name => TemplateTaskx.project_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :template_item, :class_name => TemplateTaskx.template_item_class.to_s
    belongs_to :task_status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :assigned_to, :class_name => 'Authentify::User' 
    
    validates :project_id, :presence => true,
                           :numericality => {:greater_than => 0} 
    validates :template_item_id, :presence => true,
                                 :numericality => {:greater_than => 0},
                                 :uniqueness => {:scope => :project_id, :message => I18n.t('Duplicate Project!')}
    validates_presence_of :start_date, :finish_date
  end
end
