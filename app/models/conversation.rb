require 'digest'

class Conversation < ActiveRecord::Base
  attr_accessor :cnv_users
  attr_accessible :name, :salt, :multiple_users_flag, :cnv_users
  has_many :conversation_users, dependent: :destroy
  has_many :conversation_messages, dependent: :destroy
  has_many :users, through: :conversation_users
  before_save :make_salt
  after_save :check_users, on: :create
  
  def check_users
    if !self.cnv_users.blank?
      ids = []
      if self.cnv_users.class.name == 'String'
        ids = self.cnv_users.getIdsArray
      elsif self.cnv_users.class.name == 'Array'
        ids = self.cnv_users
      end
      if ids.size > 0
        ids.each do |id|
          u = User.find(id)
          self.conversation_users.create(user_id: u.id) if !u.nil?
        end
      end
    end
  end
  
  def alter_name(user=nil)
    if self.name.blank?
      val = ""
      usrs = self.users
      if user.nil?
        usrs.each {|u| val += "#{u.name}#{', ' if u != usrs.last}"}
      else
        usrs -= [user]
        usrs.each do |usr|
          val += usr.name
          val += ', ' if usr != usrs.last
        end
      end
      return val
    else
      return self.name  
    end
  end
  
  private 
  
  def make_salt
    self.salt = Digest::SHA2.hexdigest("--#{Time.now.utc}--") if new_record? 
  end

end
