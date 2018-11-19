RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  #config.include FactoryBot::SyntaxRunner.send(:include, PlaceHelper, type: :controller)

  # config.before(:all) do
  #   Rails.application.load_tasks
  #   Rake::Task['test:db:setup'].invoke
  # end
end
