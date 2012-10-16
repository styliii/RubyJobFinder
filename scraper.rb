require 'open-uri'
require 'nokogiri'
require 'sqlite3'
require 'fileutils'

# creating database
unless File.exists?("jobs.db")
@db = SQLite3::Database.new( "jobs.db" )
sql = <<SQL
CREATE table jobs
( id INTEGER PRIMARY KEY,
job_header TEXT,
employer TEXT,
location TEXT,
telecommute BOOLEAN,
job_description TEXT,
skills_and_requirements TEXT,
about_company TEXT,
link_to_listing TEXT,
last_posted TEXT,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE table tags
  (id INTEGER PRIMARY KEY,
    name TEXT
    )

SQL

@db.execute_batch( sql )
end

# Setting database
@db ||= SQLite3::Database.open('jobs.db')

# helper methods
class String
  def clean
    clean_self = self.gsub(/\\r\\n\\t/," ").strip
    clean_self = clean_self.gsub(/\\t/," ").strip
  end
end

# Get some info from user
print "Would you like to search for ruby jobs in NY? (y/n) "
answer = gets
answer = answer.chomp!

# case answer
# when "y"
  job_type = "ruby"
  location = "New+York"
# when "n"
#   print "What type of jobs are you looking for? "
#   job_type = gets
#   job_type.chomp!
#   job_type = job_type.split(" ").join("+")
#   print "What location? "
#   location = gets
#   location.chomp!
#   location = location.split(" ").join("+")
# end

range = 170

job_search_url = "http://careers.stackoverflow.com/"
job_search_query = "jobs?searchTerm=#{job_type}&location=#{location}&range=#{range}"

job_list_page = Nokogiri::HTML(open(job_search_url + job_search_query))
job_links = job_list_page.css("a.title").map{|link| link["href"]}

  job_links.each do |link|
    next !@db.execute("SELECT * FROM jobs WHERE link_to_listing = ? ", link).empty?

    listing_page = Nokogiri::HTML(open(job_search_url + link))

    job_header = listing_page.css("a.title").text
    employer = listing_page.css("a.employer").text
    puts employer.inspect
    location = listing_page.css("span.location").text.clean
    telecommute = location.include?("telecommute") ? 1 : 0
    tags = listing_page.css("a.post-tag").map{|tag| tag.text}
    if !(listing_page/"div.jobdetail div.description p").empty?
      job_description = (listing_page/"div.jobdetail div.description p")[0].text.clean
    else
      job_description = (listing_page/"div.jobdetail div.description").text.clean
    end
    unless (listing_page/"div.jobdetail div.description")[1].nil?
      skills_and_requirements = (listing_page/"div.jobdetail div.description")[1].text.clean
    end
    unless (listing_page/"div.jobdetail div.description")[2].nil?
    about_company = (listing_page/"div.jobdetail div.description")[2].text.clean
    end
    link_to_listing = job_search_url + link

    #insert into database now!
    @db.execute("INSERT INTO jobs (job_header, employer, location, telecommute, job_description, skills_and_requirements, about_company, link_to_listing) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", job_header, employer, location, telecommute, job_description, skills_and_requirements, about_company, link_to_listing)
    puts "inserting job info"
  end






