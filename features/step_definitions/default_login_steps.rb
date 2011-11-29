=begin
Feature: Check Default Logins
  In order to prevent a default login in production
  As an administrator
  I want to check systems for default logins

  Scenario: 	Check default logins
		Given I have a list of systems
		And a list of default users
		And a list of default passwords
		When I check for valid logins
		Then I should not have a valid login
=end

World(Metaworld)

Given /^I have a list of (.+) systems$/ do |named_list|
	if named_list == "default"
	 	@systems = "172.16.249.128"
	elsif named_list == "production"
	 	@systems = "172.16.249.128"	
	else
		@systems = File.open(File.join(Metadata.new.files,"#{named_list}_systems.txt")).read
	end
end

Given /^I have a list of (.+) usernames$/ do |named_list|
	if named_list == "default"
		@usernames = "administrator\nroot"
	else
		@usernames = File.open(File.join(Metadata.new.files,"#{named_list}_usernames.txt")).read
	end
end

Given /^I have a list of (.+) passwords$/ do |named_list|
	if named_list == "default"
		@passwords = "test\nlab"
	else
		@passwords = File.open(File.join(Metadata.new.files,"#{named_list}_passwords.txt")).read
	end
end
	
When /^I check for valid logins via (.+)$/ do |types|
	types = types.split(",")
	types.each do |type| 
		check_logins(type, @systems,@usernames,@passwords)
	end
end

Then /^I should have (.+) valid logins$/ do |count| 
	get_session_count.should == count.to_i
end