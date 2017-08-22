require 'digest'

class Conversation < ActiveRecord::Base
  attr_accessor :assigned_users, :message_content, :user_id
  attr_accessible :name, :salt, :multiple_users_flag, :assigned_users, :message_content, :user_id
  has_many :conversation_users, dependent: :destroy
  has_many :conversation_messages, dependent: :destroy
  has_many :users, through: :conversation_users
  before_save :make_salt
  after_save :assign_users
  
  validate :check_users_blank
  validate :check_message_blank, on: :create
  
  def assign_users
    attrUsers = self.getUsersFromAttribute
    toDelFromConversation = self.conversation_users.where.not(user_id: attrUsers)
    toDelFromConversation.delete_all if !toDelFromConversation.blank?
    attrUsers.each do |u|
      self.conversation_users.create(user_id: u.id) if self.conversation_users.where(user_id: u.id).size == 0
    end
    self.conversation_messages.create(user_id: self.user_id, content: self.message_content) if new_record?
  end

  def check_message_blank
    if message_content.blank? || message_content.mb_chars.length > 1000
      errors.add(:message_content, "Сообщение не должно быть пустым") if message_content.blank?
      errors.add(:message_content, "Сообщение не должно превышать 1000 знаков") if message_content.mb_chars.length > 1000
    end
  end

  def check_users_blank
    if self.getUsersFromAttribute.blank?
      errors.add(:assigned_users, "В списке должен быть хоть один пользователь")
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
      return "#{self.multiple_users_flag ? "Дискуссия с " : "Диалог с "}#{val}"
    else
      return self.name  
    end
  end
  
  def assigned_users_string
    return '' if self.users.blank?
    str = ''
    self.users.each {|u| str+= "[#{u.id}]"}
    return str
  end
  
  def getUsersFromAttribute
    usrs = []
    if !self.assigned_users.blank?
      ids = [self.user_id.to_i]
      if self.assigned_users.class.name == 'String'
        ids += self.assigned_users.getIdsArray
      elsif self.assigned_users.class.name == 'Array'
        ids += self.assigned_users
      end
      if ids.size > 1
        usrs = User.where(id: ids).select(:id)
      end
    end
    self.multiple_users_flag = usrs.size > 2 ? true : false
    return usrs
  end
  
  private 
  
  def make_salt
    self.salt = Digest::SHA2.hexdigest("--#{Time.now.utc}--") if new_record? 
  end

end
