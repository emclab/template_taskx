require 'spec_helper'

module TemplateTaskx
  describe TasksController do
    before(:each) do
      controller.should_receive(:require_signin)
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'fixed_task_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', 
        :argument_value => ' FixedTaskProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (FixedTaskProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      #view_from_config = FactoryGirl.create(:engine_config, :argument_name => 'view_from_config', :argument_value => 'false')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @proj_type = FactoryGirl.create(:simple_typex_type)
      @proj_type1 = FactoryGirl.create(:simple_typex_type, :name => 'newnew')
      @tt = FactoryGirl.create(:task_templatex_template, :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type.id)
      @tt1 = FactoryGirl.create(:task_templatex_template, :name => 'a new name', :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type1.id)
      @task_def = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_definition', :active => true)
      @task_def1 = FactoryGirl.create(:commonx_misc_definition, :name => 'a new task name', :for_which => 'task_definition', :active => true)
      @cust = FactoryGirl.create(:kustomerx_customer)
      @proj = FactoryGirl.create(:fixed_task_projectx_project, :task_template_id => @tt.id, :customer_id => @cust.id)
      @proj1 = FactoryGirl.create(:fixed_task_projectx_project, :task_template_id => @tt1.id, :name => 'a new name', :project_num => 'something new', :customer_id => @cust.id)
      @item = FactoryGirl.create(:task_templatex_template_item, :template_id => @tt.id, :task_definition_id => @task_def.id)
      @item1 = FactoryGirl.create(:task_templatex_template_item, :template_id => @tt1.id, :task_definition_id => @task_def1.id)
      @task_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
    end
      
    render_views
  
    describe "GET 'index'" do
      it "returns all tasks for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TemplateTaskx::Task.where(:cancelled => false).order('created_at')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task, :cancelled => false, :last_updated_by_id => @u.id, :template_item_id => @item.id)
        qs1 = FactoryGirl.create(:template_taskx_task, :cancelled => false, :last_updated_by_id => @u.id, :template_item_id => @item1.id)
        get 'index' , {:use_route => :template_taskx}
        #response.should be_success
        assigns(:tasks).should =~ [qs, qs1]       
      end
      
      it "should return tasks for the template item" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TemplateTaskx::Task.where(:cancelled => false).order('created_at')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task, :cancelled => false, :last_updated_by_id => @u.id, :template_item_id => @item.id)
        qs1 = FactoryGirl.create(:template_taskx_task, :cancelled => true, :last_updated_by_id => @u.id, :template_item_id => @item1.id)
        get 'index' , {:use_route => :template_taskx, :template_item_id => @item.id}
        assigns(:tasks).should eq([qs])
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :template_taskx, :template_item_id => @item.id, :project_id => @proj.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:template_taskx_task, :template_item_id => @item.id, :project_id => @proj.id)
        get 'create' , {:use_route => :template_taskx,  :task => qs, :project_id => @proj.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:template_taskx_task, :start_date => nil)
        get 'create' , {:use_route => :template_taskx, :template_item_id => @item.id, :task => qs, :project_id => @proj.id}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task, :template_item_id => @item.id, :project_id => @proj.id)
        get 'edit' , {:use_route => :template_taskx, :project_id => @proj.id, :id => qs.id}
        response.should be_success
      end
      
      it "should redirect if no right" do
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task)
        get 'edit' , {:use_route => :template_taskx, :project_id => @proj.id, :id => qs.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=template_taskx/tasks")
      end
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task)
        get 'update' , {:use_route => :template_taskx, :project_id => @proj.id, :id => qs.id, :task => {:finish_date => '2013-01-09'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task)
        get 'update' , {:use_route => :template_taskx, :project_id => @proj.id, :id => qs.id, :task => {:finish_date => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:template_taskx_task, :template_item_id => @item.id)
        get 'show' , {:use_route => :template_taskx, :template_item_id => @item.id, :id => qs.id, :project_id => @proj.id}
        response.should be_success
      end
    end
  
  end
end
