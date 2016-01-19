class AddIpAddrAndHostNameToStep < ActiveRecord::Migration
  def change
    add_column :steps, :ip_addr, :string
    add_column :steps, :host_name, :string
  end
end
