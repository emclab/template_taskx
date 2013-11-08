require 'spec_helper'

module TemplateTaskx
  describe Task do
    it "should be OK" do
      c = FactoryGirl.build(:template_taskx_task)
      c.should be_valid
    end
    
    it "should reject nil task_definition" do
      c = FactoryGirl.build(:template_taskx_task, :template_item_id => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate template item id for the same project" do
      c0 = FactoryGirl.create(:template_taskx_task, :template_item_id => 1, :project_id => 1)
      c = FactoryGirl.build(:template_taskx_task, :template_item_id => 1, :project_id => 1)
      c.should_not be_valid
    end
    
    it "should reject nil project_id" do
      c = FactoryGirl.build(:template_taskx_task, :project_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:template_taskx_task, :start_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil finish_date" do
      c = FactoryGirl.build(:template_taskx_task, :finish_date => nil)
      c.should_not be_valid
    end
  end
end
