# frozen_string_literal: true

folders = %w[security_news security_categories views]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
