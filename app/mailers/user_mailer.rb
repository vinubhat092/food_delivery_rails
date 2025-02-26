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

  def order_successful(user)
    @user=user
    mail(
      to:@user.email,
      subject: "Your order is succesfully received"
    ) do |format|
      format.html { render 'order_successful'}
    end
  end
end 