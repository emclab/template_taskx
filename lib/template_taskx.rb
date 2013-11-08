require "template_taskx/engine"

module TemplateTaskx
  mattr_accessor :project_class, :template_item_class, :project_resource, :template_class
  
  def self.project_class
    @@project_class.constantize
  end
  
  def self.template_class
    @@template_item_class.constantize
  end
  
  def self.template_item_class
    @@template_item_class.constantize
  end
end
