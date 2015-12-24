class ArticlesMailer < ApplicationMailer
  def new_report_mailer(article, user)
    @user = user
    @article = article
    @header = "Новый отчёт"
    @link = "http://#{default_url_options[:host]}/articles/#{article.id}" #'http://visota-paraclub.ru'
    @user_add_message = "<b>#{@article.user.name}</b> добавил новый отчёт <b>#{@article.alter_name}</b>"
    @target_link = "<a href = '#{@link}'>Перейти к отчёту</a>"
    mail(to: user.email, :subject => @header) do |format|
      format.text {render 'new_article_mailer'}
      format.html {render 'new_article_mailer'}
    end
  end
  def new_review_mailer(article, user)
    @user = user
    @article = article
    @header = "Новый обзор"
    @user_add_message = "<b>#{@article.user.name}</b> добавил новый обзор <b>#{@article.alter_name }</b>"
    @link = "http://#{default_url_options[:host]}/articles/#{article.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейтие к обзору</a>"
    mail(to: user.email, :subject => @header) do |format|
      format.text {render 'new_article_mailer'}
      format.html {render 'new_article_mailer'}
    end
  end
  def new_flight_accident_mailer(article, user)
    @user = user
    @article = article
    @header = "Новый отчёт о лётном происшествии"
    @user_add_message = "<b>#{@article.user.name}</b> добавил отчёт о лётном происшествии <b>#{@article.alter_name}</b>"
    @link = "http://#{default_url_options[:host]}/articles/#{article.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к отчёту о лётном происшествии</a>"
    mail(to: user.email, :subject => @header) do |format|
      format.text {render 'new_article_mailer'}
      format.html {render 'new_article_mailer'}
    end
  end

  def new_document_mailer(article, user)
    @user = user
    @article = article
    @header = "Новый документ"
    @user_add_message = "<b>#{@article.user.name}</b> разместил документ <b>#{@article.alter_name}</b>"
    @link = "http://#{default_url_options[:host]}/articles/#{article.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к документу</a>"
    mail(to: user.email, :subject => @header) do |format|
      format.text {render 'new_article_mailer'}
      format.html {render 'new_article_mailer'}
    end
  end
  def new_article_mailer(article, user)
    @user = user
    @article = article
    @header = "Новая статья"
    @user_add_message = "<b>#{@article.user.name}</b> добавил статью <b>#{@article.alter_name}</b>"
    @link = "http://#{default_url_options[:host]}/articles/#{article.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к статье</a>"
    mail(to: user.email, :subject => @header) do |format|
      format.text {render 'new_article_mailer'}
      format.html {render 'new_article_mailer'}
    end
  end
end
