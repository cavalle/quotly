OmniAuth.config.test_mode = true

module AuthHelpers
  def login_as(nickname)
    OmniAuth.config.add_mock 'twitter', {'uid' => nickname, 'user_info' => {'nickname' => 'jdoe'}}
    visit '/auth/twitter'
  end
end

MiniTest::Unit::TestCase.send :include, AuthHelpers
