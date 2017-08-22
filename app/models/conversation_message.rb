require 'openssl'
class ConversationMessage < ActiveRecord::Base
  attr_accessor :last_visible_msg_id
  attr_accessible :user_id, :conversation_id, :content, :salt, :last_visible_msg_id
  belongs_to :user
  belongs_to :conversation
  has_many :conversation_user_messages, dependent: :delete_all
  before_save :encrypt_content
  after_save :assign_conversation_users_to_message, on: :create
  
  def decrypted_content
    return decrypt_content
  end
  
  private
  
  def assign_conversation_users_to_message
    usrs = self.conversation.users.select(:id)
    newArr = []
    usrs.each {|u| newArr[newArr.length] = {user_id: u.id}}
    self.conversation_user_messages.create(newArr)
  end
  
  def encrypt_content
    #cipher = OpenSSL::Cipher::Cipher.new("AES-128-CBC")
    #cipher.encrypt
   # self.salt = cipher.random_iv if new_record?
    #cipher.key = self.conversation.salt
    #cipher.iv = self.salt
   # encContent = cipher.update(self.content)
   # encContent << cipher.final
   #Base64.encode64('Send reinforcements')
    self.content = Base64.encode64(self.content)
  end
  
  def decrypt_content
    #cipher = OpenSSL::Cipher::Cipher.new("AES-128-CBC")
    #cipher.decrypt
    #cipher.key = self.conversation.salt
    #cipher.iv = self.salt
    #decContent = cipher.update(self.content)
    #decContent << cipher.final
    return Base64.decode64(self.content).force_encoding('UTF-8')
  end
  
end
