require 'sqlite3'
require 'fileutils'

class Job
  attr_accessor :job_header, :employer_id, :location, :telecommute, :job_description, :skills_and_requirements, :link_to_listing

  @@db ||= SQLite3::Database.open('jobs.db')
  def insert_job(job_header, employer_id, location, telecommute, job_description, skills_and_requirements, link_to_listing)
        @@db.execute("INSERT INTO jobs (job_header, employer_id, location, telecommute, job_description, skills_and_requirements, link_to_listing) VALUES (?, ?, ?, ?, ?, ?, ?)", job_header, employer_id, location, telecommute, job_description, skills_and_requirements, link_to_listing)
    puts "inserting job info"
  end

end

class Employer
  attr_accessor :name, :url, :about

  @@db ||= SQLite3::Database.open('jobs.db')

  def insert_employer(employer_name, employer_url, about_company)
    @@db.execute("INSERT INTO employers (name, url, about) VALUES (?, ?, ?)", employer_name, employer_url, about_company)
    self.name = employer_name
    self.url = employer_url
    self.about = about_company
  end

  def self.find(employer_name)
    @@db.execute("SELECT id FROM employers WHERE name = '#{employer_name}'")
  end
end
