Paperclip::Attachment.default_options.merge!({
  storage: Paperclip::Attachment.default_options[:storage],
  s3_credentials: {
    bucket: Rails.application.secrets.s3_bucket_name,
    access_key_id: Rails.application.secrets.s3_key,
    secret_access_key: Rails.application.secrets.s3_secret
  }
})
