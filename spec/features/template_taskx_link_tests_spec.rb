require 'spec_helper'

describe "LinkTests" do
  describe "GET /template_taskx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
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
      @task_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status', :active => true)
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "TemplateTaskx::Task.where(:cancelled => false).order('created_at')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'template_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'create_task_definition', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")  
      ua41 = FactoryGirl.create(:user_access, :action => 'create_task_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "") 
      ua41 = FactoryGirl.create(:user_access, :action => 'index_task_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "Commonx::MiscDefinition.where(:for_which => 'task_status')")   
                                
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login' 
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      qs = FactoryGirl.create(:template_taskx_task, :cancelled => false, :last_updated_by_id => @u.id, :template_item_id => @item.id)
      visit tasks_path
      #save_and_open_page
      page.should have_content('Tasks')
      click_link('Edit')
      #save_and_open_page
      page.should have_content('Update Task')
      
      visit tasks_path
      click_link(qs.id.to_s)
      page.should have_content('Task Info')
      
      visit tasks_path(:project_id => @proj.id)
      click_link('New Task')
      #save_and_open_page
      page.should have_content('New Task')
    end
  end
end
