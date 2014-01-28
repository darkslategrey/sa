


require 'pry'
require './app'

Dir['models/*.rb'].map do |m| require "./#{m}" end



DB.with_server(:je) do
  a = Action.new(:label => 'test', :datep => DateTime.now, :datep2 => DateTime.now + 1.day)
  puts a.id
  a.save

end

# params = {"startDate"=>"2013-12-29",
#           "endDate"=>"2014-02-01",
#           "page"=>"1",
#           "start"=>"0",
#           "limit"=>"25"}

# actions = Action.ax_find params, [:je, :jd]

# pp actions
