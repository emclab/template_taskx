require_dependency "template_taskx/application_controller"

module TemplateTaskx
  class TasksController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = 'Tasks'      
      @tasks = params[:template_taskx_tasks][:model_ar_r]
      @tasks = @tasks.where(:project_id => params[:project_id]) if @project
      @tasks = @tasks.where(:template_item_id => params[:template_item_id]) if @template_item
      @tasks = @tasks.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('task_index_view', 'template_taskx')
      
    end
  
    def new
      @title = 'New Task'
      @task = TemplateTaskx::Task.new
    end
  
    def create
      @task = TemplateTaskx::Task.new(params[:task], :as => :role_new)
      @task.last_updated_by_id = session[:user_id]
      if @task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = 'Edit Task'
      @task = TemplateTaskx::Task.find_by_id(params[:id])
    end
  
    def update
      @task = TemplateTaskx::Task.find_by_id(params[:id])
      @task.last_updated_by_id = session[:user_id]
      if @task.update_attributes(params[:task], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = 'Task Info'
      @task = TemplateTaskx::Task.find_by_id(params[:id])
      @erb_code = find_config_const('task_show_view', 'template_taskx')
    end
    
    protected
    def load_parent_record
      @project = TemplateTaskx.project_class.find_by_id(params[:project_id]) if params[:project_id].present? && params[:project_id].to_i > 0
      @template_item = TemplateTaskx.template_item_class.find_by_id(params[:template_item_id]) if params[:template_item_id].present? && params[:template_item_id].to_i > 0
      @project = TemplateTaskx.project_class.find_by_id(TemplateTaskx::Task.find_by_id(params[:id]).project_id) if params[:id].present?
      @template_item = TemplateTaskx.project_class.find_by_id(TemplateTaskx::Task.find_by_id(params[:id]).template_item_id) if params[:id].present?
      @project = TemplateTaskx.project_class.find_by_id(params[:task][:project_id]) if params[:task].present? && params[:task][:project_id].to_i > 0
    end
  end
end
