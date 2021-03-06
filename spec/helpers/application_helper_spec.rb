require 'spec_helper'

describe ApplicationHelper do
  describe '#current_url_with_format_of' do
    it 'should preserve controller, action, and other params' do
      controller.params['action'] = 'search'
      controller.params['controller'] = 'children'
      controller.params['param_a'] = 'foo'

      helper.current_url_with_format_of('csv').should ==
        '/children/search.csv?param_a=foo'
    end

    it 'should override any existing format' do
      controller.params['action'] = 'search'
      controller.params['controller'] = 'children'
      controller.params[:format] = 'pdf'

      url = helper.current_url_with_format_of('csv')
      url.should include('.csv')
      url.should_not include('.pdf')
    end
  end

  describe "user" do
    it "should return me the current logged in user" do
      user = User.new(:user_name => 'user_name', :role_names => ["default"])
      User.should_receive(:find_by_user_name).with('user_name').and_return(user)
      session = Session.new :user_name => user.user_name
      Session.should_receive(:get_from_cookies).with(anything).and_return(session)
      helper.current_user.user_name.should == 'user_name'
    end
  end
  
  describe "render_nav_bar?" do
      it "should return false when no user is logged in" do
        helper.render_nav_bar?.should_not be_true        
      end

      it "should return true when a user is logged in" do
        user = User.new(:user_name => 'user_name', :role_names => ["default"])
        User.should_receive(:find_by_user_name).with('user_name').and_return(user)
        session = Session.new :user_name => user.user_name
        Session.should_receive(:get_from_cookies).with(anything).and_return(session)        
        
        helper.render_nav_bar?.should be_true
      end
      
  end
  

end
