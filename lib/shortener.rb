require "active_support/dependencies"

module Shortener

  autoload :ActiveRecordExtension, "shortener/active_record_extension"
  autoload :ShortenUrlInterceptor, "shortener/shorten_url_interceptor"

  class Configuration
    attr_accessor :charset, :unique_key_length, :after_redirect_call

    def initialize
      # character set to chose from:
      #  :alphanum     - a-z0-9     -  has about 60 million possible combos
      #  :alphanumcase - a-zA-Z0-9  -  has about 900 million possible combos
      @charset = :alphanum

      # default key length: 5 characters
      @unique_key_length = 5
    end

    def after_redirect(&block)
      @after_redirect_call = block
    end
  end

  def self.configure
    yield(self.config)
  end

  mattr_accessor :config
  self.config = Configuration.new

  CHARSETS = {
    :alphanum => ('a'..'z').to_a + (0..9).to_a,
    :alphanumcase => ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
  }

  def self.key_chars
    CHARSETS[self.config.charset]
  end
end

# Require our railtie and engine
require "shortener/railtie"
require "shortener/engine"
