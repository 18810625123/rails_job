class AddCompanyAddressToWorks < ActiveRecord::Migration[5.1]
  def change
  	add_column :works, :company_address, :string
  	add_column :works, :work_address, :string
  end
end
