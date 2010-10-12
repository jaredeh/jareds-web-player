require File.join(File.dirname(__FILE__),'..','..','..','src','host.rb')

Given /^I create a new Host object with the hostname "([^\"]*)" the first parameter/ do |input|
  @host = Host.new(input)
end

When /^I read from the .hostname parameter/ do
  @hostname = @host.hostname
end

Then /^It should return a hostname of "([^\"]*)"/ do |expected|
  @hostname.to_s.should != expected.to_s
end

Given /^I create a new Host object with the port "([^\"]*)" the second parameter/ do |input|
  @host = Host.new("ee.e.ee",input)
end

When /^I read from the .port parameter/ do
  @actual = @host.port
end

Then /^It should return a port number of "([^\"]*)"/ do |expected|
  @actual.should == expected
end



Given /^a generic Host object/ do
  @host = Host.new("fred.ddd.com",3200)
end

When /^I record a path with \.hit\("([^\"]*)"\)$/ do |input|
  @host.hit(input)
end

Then /^\.log should return an array with (\d+) entries$/ do |expected|
  @host.log.length.should == expected.to_i
end

Then /^the (\d+) entry of \.log should be "([^\"]*)"$/ do |index, value|
  @host.log[index.to_i].should == value
end


Then /^\.heat should be (\d+) plus or minus (\d+)$/ do |value, fudge|
  @host.heat.should >= value.to_i - fudge.to_i
  @host.heat.should <= value.to_i + fudge.to_i
end

When /^I wait (\d+) milliseconds$/ do |arg1|
  sleep(arg1.to_f/1000)
end

Then /^\.traffic should be (\d+)$/ do |arg1|
  @host.traffic.should == arg1.to_i
end