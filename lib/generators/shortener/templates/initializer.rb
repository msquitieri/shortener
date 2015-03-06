Shortener.configure do |config|

  # The length of the unique key.
  config.unique_key_length = 5

  # The character set used to create the
  # unique key.
  # Accepted Values: [:alphanum, :alphanumcase]
  # alphanum     => [a-z0-9]
  # alphanumcase => [A-z0-9]
  config.charset = :alphanum

  # Define a callback to be run after the
  # the redirect is successful. The shortened_url
  # object of the successful redirect is passed.
  config.after_redirect do |shortened_url|
    # Custom tracking, events, etc.
  end
end