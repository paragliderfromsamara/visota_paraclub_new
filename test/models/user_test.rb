require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Имя пользователя длиннее 32-х символов" do
	user = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Каждый охотник желает знать где сидит фазан')
    assert(!user.save, "Сохранён пользователь с длинным именем")
  end
  
  test "Пользователь без имени" do
	user = User.new(:password => '123456',:password_confirmation =>'123456', :name => '')
    assert(!user.save, "Сохранён пользователь без имени")
  end
  
  test "Пароль короче 6-ти символов" do
	user = User.new(:password => '12345',:password_confirmation =>'12345', :name => 'Василий')
    assert(!user.save, "Сохранён пользователь с коротким паролем")
  end
  
  test "Пароль с неправильным подтверждением" do
	user = User.new(:password => '123456',:password_confirmation =>'654321', :name => 'Василий')
    assert(!user.save, "Сохранён пользователь с коротким паролем")
  end
  
  test "Поле E-mail не соответствует маске" do
	user = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Василий', :email => 'eergerge')
    assert(!user.save, "Сохранён пользователь с неправильным почтовым адресом")
  end
  
  test "Поле E-mail не заполнено" do
	user = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Василий', :email => '')
    assert(!user.save, "Сохранён пользователь с пустым почтовым адресом")
  end
  
  test "Пользователь с существующим именем" do
	user_1 = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Василий', :email => 'dfgdg@gmail.ru')
    user_1.save
	user_2 = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Василий', :email => 'dfgdfgd@gmail.ru')
    
	assert(!user_2.save, "Сохранёно два пользователя с одинаковыми именами")
  end
  
  test "Пользователь с существующим E-mail" do
	user_1 = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Василий', :email => 'dfgdg@gmail.ru')
    user_1.save
	user_2 = User.new(:password => '123456',:password_confirmation =>'123456', :name => 'Вася', :email => 'dfgdg@gmail.ru')
	assert(!user_2.save, "Сохранёно два пользователя с одинаковыми E-mail адресами")
  end
end
