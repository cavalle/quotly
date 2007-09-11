class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://q.uot.es/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://q.uot.es/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "team@q.uot.es"
      @subject     = "[q.uot.es] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
