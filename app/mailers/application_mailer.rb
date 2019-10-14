class ApplicationMailer < ActionMailer::Base
  
  default from: "ameropa.logistics@gmail.com"

  def sample_email(client)
    @user = client
    mail(to: @client.email, subject: 'Sample Email')
  end

  layout 'mailer'
end
