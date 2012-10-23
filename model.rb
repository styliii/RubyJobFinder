require 'sqlite3'
require 'fileutils'

class Job
  attr_accessor :job_header, :employer_id, :location, :telecommute, :job_description, :skills_and_requirements, :link_to_listing, :employer_name

  def initialize
  end
  # @@db ||= SQLite3::Database.open('jobs.db')
  def insert_job(database)
    employer = Employer.new(@employer_name)
    employer.insert_employer(database)
    employer_id = database.db.execute("select last_insert_rowid();").flatten.first
    # employer_id = database.db.execute("select id from employers where employers.name = '#{employer_name}'").flatten.first
    database.db.execute("INSERT INTO jobs (job_header, employer_id, location, telecommute, job_description, skills_and_requirements, link_to_listing) VALUES (?, ?, ?, ?, ?, ?, ?)", @job_header, employer_id, @location, @telecommute, @job_description, @skills_and_requirements, @link_to_listing)

  end

  def self.find_by_employer_name(employer_name, database)
    database.db.execute("SELECT * from jobs
                                      INNER JOIN employers on jobs.employer_id = employers.id
                                      WHERE employers.name = '#{employer_name}'").flatten
  end

end

class Employer
  attr_accessor :name, :url, :about

  def initialize(name="", url="", about="")
    @name = name
    @url = url
    @about = about
  end

  def insert_employer(database)
    if Employer.find(@name, database).empty?
      database.db.execute("INSERT INTO employers (name, url, about) VALUES (?, ?, ?)", @name, @url, @about)
    end
  end

  def self.find(employer_name, database)
    database.db.execute("SELECT id FROM employers WHERE name = '#{employer_name}'")
  end
end

class Database
 attr_accessor :db, :last_created_at

  def initialize
      @db = SQLite3::Database.new( "jobs.db" )
  end

  def create_employers_table
    sql = <<SQL
    DROP table if exists employers;
CREATE table employers
( id INTEGER PRIMARY KEY,
  about TEXT,
  url TEXT,
  name TEXT
  );
SQL
    @db.execute_batch( sql )
  end

  def create_jobs_table
    sql = <<SQL
    DROP table if exists jobs;
CREATE table jobs
( id INTEGER PRIMARY KEY,
job_header TEXT,
location TEXT,
telecommute BOOLEAN,
job_description TEXT,
skills_and_requirements TEXT,
link_to_listing TEXT,
last_posted TEXT,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
employer_id INTEGER
);
SQL
    @db.execute_batch( sql )
  end

  def drop_table(table_name)
sql = <<SQL
DROP table #{table_name}
);
SQL
      @db.execute_batch(sql)
  end
end
