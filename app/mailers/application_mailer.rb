class ApplicationMailer < ActionMailer::Base
  default from: "no_reply@myapp.com"
  layout "mailer"
end
