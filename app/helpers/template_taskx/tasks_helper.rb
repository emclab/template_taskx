module TemplateTaskx
  module TasksHelper
=begin
    def return_task_definition(project_template_id)
      Commonx::MiscDefinition.where(:id => TemplateTaskx.template_item_class.where(:template_id => project_template_id).select('task_definition_id'))
    end
    
    def return_project_task_template(project_task_template_id=nil)
      if project_template_id
        Projectx::ProjectTaskTemplate.where(:id => project_task_template_id)
      else
        Projectx::ProjectTaskTemplate.order('name')
      end  
    end  
=end
    def return_template_item(task_template_id)
      TemplateTaskx.template_item_class.where(:template_id => task_template_id).order('execution_order, execution_sub_order')
    end 
  end
end
