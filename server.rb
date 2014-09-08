env = ENV["RACK_ENV"] || "development"

require 'data_mapper'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'

DataMapper.finalize

DataMapper.auto_upgrade!
