class ActivityMailer < ApplicationMailer

  default from: "ameropa.logistics@gmail.com"
  layout 'mailer'

  def activity_email(email, activity)
  	#@invoiceTrip = file.references
  	#attachments["a"] = file

    @references = activity.references
    @extra_email_text = activity.email_text

    activity.email_counter = activity.email_counter.to_i+1
    activity.save

    activity.trip_images.each_with_index do |img,i|

      if img.blob.filename.to_s.include?("jpeg") or img.blob.filename.to_s.include?("jpg")
        attachments[@references.to_s+"_#{ i }.jpeg"] =  img.blob.download
      elsif img.blob.filename.to_s.include?("pdf") 
        attachments[@references.to_s+"{_#{ i }.pdf"] =  img.blob.download
      elsif img.blob.filename.to_s.include?("doc") 
        attachments[@references.to_s+"_#{ i }.doc"] =  img.blob.download
      end

    end

   
    mail(to: email, bcc: "ameropa.logistics@yahoo.com", subject: "Papers for ".to_s+ @references.to_s )
      end

end
