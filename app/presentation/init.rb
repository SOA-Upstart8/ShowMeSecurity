# frozen_string_literal: true

folders = %w[representers view_object]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
