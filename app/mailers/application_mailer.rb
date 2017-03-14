class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@visitor.com'
  layout 'mailer'
end
