#!/usr/bin/env bundle exec ruby

require_relative 'course'
require_relative 'questionnaire'

# Midterm questions

questions = [
  SingleScale.new("How much fun are you having working on your project?"),
  SingleScale.new("What’s your feeling right now about how the project will turn out at the end of the semester?"),
  MemberScale.likert("reliable and fully participating"),
  MemberScale.likert("making good contributions"),
  MemberScale.likert("helps create a positive team dynamic"),
  OpenAnswer.new("What is your team doing well?"),
  OpenAnswer.new("What would you like your team to do better?"),
  OpenAnswer.new("How are you doing?"),
  OpenAnswer.new("Any other comments?"),
]

course = read_course

puts "#{course.students.count} students"

ratings_file = ARGV.shift or abort "ERROR: Please provide path to csv file"
CSV.foreach(ratings_file, headers: :first_row) do |row|
  next if row.to_h.values.compact.empty?  # skip blank rows

  unless student = course.student_with_email(row.fetch("Email Address"))
    raise "No student with email: #{row.fetch("Email Address").inspect}"
  end
  
  teammates = (1...MAX_TEAM_SIZE).map do |i|
    name = row.fetch("Teammate #{i} name#{" (leave blank for a team of 3)" if i == 3}")
    next if [nil, "no one", "none", "n/a", "null"].include?(name&.downcase)
    student.team.member_named(name)
  end
  rated_students = [student] + teammates

  puts "#{student.first_name} → #{rated_students.compact.map(&:first_name)}"

  cols = row[2..3] + row[8..-1]
  questions.each do |question|
    question.read_response(student, rated_students, cols)
  end
rescue
  STDERR.puts "Error while processing row: #{row.inspect}"
  raise
end

course.teams.each do |team|
  outfile = "/tmp/#{team.section} #{team.name}.html"
  render_haml('results', outfile, title: "Midterm Team Self-Assessment", team: team, questions: questions)
  `open "#{outfile}"`
end
