class Tenant < ActiveRecord::Base
	after_create :create_tenant

	private

		def create_tenant
			Apartment::Tenant.create(subdomain)
			#tasks(subdomain)
		end

		def tasks(tenant)
  		load File.join(Rails.root, 'lib', 'tasks', 'config_system.rake')
			Rake::Task["db:config_system"].invoke(tenant)
		end
end


