class InvoiceMailer < ApplicationMailer

  default from: "ameropa.logistics@gmail.com"
  layout 'mailer'

  def invoice_email(email, file)
  	@invoiceName = file.invoiceName
  	@invoiceTrip = file.invoiceTrip
  	attachments[file.name] = file.file
    mail(to: email, bcc: "ameropa.logistics@yahoo.com", subject: "Invoice for ".to_s+file.invoiceTrip.to_s)
  end

end
