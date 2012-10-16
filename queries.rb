require 'sqlite3'
require 'fileutils'

@db ||= SQLite3::Database.open('jobs.db')

# last 10 job listings
