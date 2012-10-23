require './model.rb'

def test(title, &b)
  begin
    if b
      result = b.call
      if result.is_a?(Array)
        puts "fail: #{title}"
        puts "      expected #{result.first} to equal #{result.last}"
      elsif result
        puts "pass: #{title}"
      else
        puts "fail: #{title}"
      end
    else
      puts "pending: #{title}"
    end
  rescue => e
    puts "fail: #{title}"
    puts e
  end
end

def assert(statement)
  !!statement
end

def assert_equal(actual, expected)
  if expected == actual
    true
  else
    [expected, actual]
  end
end




test 'Can intialize an Employer' do
  assert Employer.new
end

