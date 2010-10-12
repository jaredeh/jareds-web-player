require File.join(File.dirname(__FILE__),'..','..','..','src','shoes_helpers.rb')


Given /^a heat value the function should return a rgb array:$/ do |table|
  table.hashes.each do |hash|
    JSH.color_it(hash["heat"].to_i).should == [ hash['r'].to_i, hash['g'].to_i, hash['b'].to_i ]
  end
end