class UserMailer < ApplicationMailer
  def cart_abandoned(user)
    @user = user
    
    mail(
      to: @user.email,
      subject: 'Your food is getting cold!'
    ) do |format|
      format.html { render 'cart_abandoned' }
    end
  end
end 