# -*- coding: utf-8 -*-
require 'spec_helper'

shared_examples_for "good code" do
  it "redirects to actual url" do
    get :show, :id => code
    response.should redirect_to("http://www.doorkeeperhq.com/")
  end
end

shared_examples_for "wrong code" do
  it "redirects to actual url" do
    get :show, :id => code
    response.should redirect_to("/")
  end
end

describe Shortener::ShortenedUrlsController do
  let(:short_url) { Shortener::ShortenedUrl.generate("www.doorkeeperhq.com") }

  describe "GET show with actual code" do
    let(:code) { short_url.unique_key}
    it_should_behave_like "good code"
  end

  describe "GET show with good code but trailing characters" do
    let(:code) { "#{short_url.unique_key}-" }
    it_should_behave_like "good code"
  end

  describe "GET show with wrong code" do
    let(:code) { "testing" }
    it_should_behave_like "wrong code"
  end

  describe "GET show with code of invalid characters" do
    let(:code) { "-" }
    it_should_behave_like "wrong code"
  end

  describe "GET show with after_redirect callback" do
    let(:code) { short_url.unique_key }

    before :each do
      Shortener.configure do |config|
        config.after_redirect do |shortened_url|
          shortened_url.update_attribute(:url, 'http://anotherurl.com')
        end
      end
    end

    it_should_behave_like 'good code'

    it 'executes the callback after the redirect' do
      get :show, :id => code
      Shortener::ShortenedUrl.where(unique_key: code).first.url.should eq('http://anotherurl.com')
    end
  end

  describe "GET show with different not_found_url" do
    before :each do
      Shortener.configure do |config|
        config.not_found_url = 'http://www.google.com'
      end
    end

    let(:code) { 'notfound' }
    it 'redirects to what is specified in the not_found_url config' do
      get :show, :id => code
      response.should redirect_to('http://www.google.com')
    end
  end
end
