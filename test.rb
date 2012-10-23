require 'rubygems'
gem 'minitest'
require './model.rb'
require 'minitest/autorun'
require 'sqlite3'


# @db.results_as_hash = true

describe Employer do

  it "can be created with no arguments" do
    Employer.new.must_be_instance_of Employer
  end

  it "can have a name" do
    employer = Employer.new
    employer.name = "Google"
    employer.name.must_equal "Google"
  end

  it "can be saved into a database" do
    @db = Database.new
    @db.create_employers_table
    employer = Employer.new("Google", "www.google.com", "weoiruwer")
    employer.insert_employer(@db)
    count = @db.db.execute("select count(id) from employers").flatten.count
    count.must_equal 1
  end
end

describe Job do
  it "can be created with no arguments" do
    Job.new.must_be_instance_of Job
  end

  it "can have a name" do
    job = Job.new
    job.job_header = "Google"
    job.job_header.must_equal "Google"
  end

  it "will only create employers that are unique" do
    @db = Database.new
    @db.create_employers_table
    @db.create_jobs_table
    job_1 = Job.new
    job_1.job_header = "Jr. Dev"
    job_1.employer_name = "Google"
    job_1.insert_job(@db)
    job_2 = Job.new
    job_2.job_header = "Sys Admin"
    job_2.employer_name = "Google"
    job_2.insert_job(@db)

    Employer.find("Google", @db).count.must_equal 1
  end

  it "should be able to search by employer for all the jobs" do
    @db = Database.new
    @db.create_employers_table
    @db.create_jobs_table
    # @db.db.results_as_hash = true

    job_1 = Job.new
    job_1.job_header = "Jr. Dev"
    job_1.employer_name = "Google"
    job_1.insert_job(@db)
    job_2 = Job.new
    job_2.job_header = "Sys Admin"
    job_2.employer_name = "Yahoo!"
    job_2.insert_job(@db)

    # job_2.find_employer(@db).count.must_equal 1
    Employer.find_by_name(job_2.employer_name).count.must_equal 1
  end
end

# describe Database do
#   it "can be created with no arguments" do
#     Database.new.must_be_instance_of Database
#   end

# end
