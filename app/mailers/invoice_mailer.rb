class InvoiceMailer < ApplicationMailer

  default from: "c"
  layout 'mailer'

  def invoice_email(email, file, invoice)
  	@invoiceName = file.invoiceName
  	@invoiceTrip = file.invoiceTrip
  	attachments[file.name] = file.file

    invoice_client = invoice.client_id

    invoice.invoiced_trips.each_with_index do |invoicedTrip,index|

      if invoicedTrip.client_id != invoice.client_id
        return false
      end

      invoicedTrip.activities.each do |activity|

        if activity.client_id != invoice.client_id
         return false
        end

        @references = activity.references     
        activity.trip_images.each_with_index do |img,i|
     	    if img.blob.filename.to_s.include?("jpeg") or img.blob.filename.to_s.include?("jpg")
        	  attachments[@references.to_s+"_#{ i }.jpeg"] = img.blob.download
      	    elsif img.blob.filename.to_s.include?("pdf") 
     	      attachments[@references.to_s+"_#{ i }.pdf"] = img.blob.download
      	    elsif img.blob.filename.to_s.include?("doc") 
     	      attachments[@references.to_s+"_#{ i }.doc"] = img.blob.download
        	end
        end

      end
    end


    mail(to: email, bcc: "invoice.ameropa.backup@gmail.com", subject: "Invoice for ".to_s+file.invoiceTrip.to_s)
  end

end
