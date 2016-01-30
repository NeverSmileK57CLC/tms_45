User.create!(name: "Ngoc Vu",
  email: "ngocvu.uet@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: 0,
  reset_sent_at: Time.zone.now)

User.create!(name: "Bach Van Ngoc",
  email: "neversmile12b1@gmail.com",
  password: "123456",
  role: 0)

20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    role: 1)
end

12.times do |n|
  name = "Subject #{n}"
  description = Faker::Lorem.paragraphs.first
  tasks = {}
  4.times do |m|
    tasks["#{m}"] = {name: "Task #{m}"}
  end
  Subject.create! name: name,
    description: description,
    tasks_attributes: tasks
end

course = Course.create! name: "JavaScript Road Trip Part 1", user_id: 1,
  description: "An introduction to the very basics of the JavaScript
    language. Build a foundation of JavaScript syntax and learn how to use values, variables, and files.",
  status: 0,
  start_date: Time.now,
  end_date: Time.now,
  subjects_attributes: {
    "0": {name: "The Cliffs of Value",
      description: "Learn to manipulate values on the console.",
      tasks_attributes: {
        "0": {name: "Task 1"},
        "1": {name: "Task 2"}
      }},
    "1": {name: "Variable Valley",
      description: "Review how to store and use data with variables."},
    "2": {name: "Files Falls",
      description: "Create JS files and source them within HTML code."}
  }
  subject_courses1 = SubjectCourse.create! subject_id: 1,
    course_id: 1, status: 0
  course2 = Course.create! name: "JavaScript Road Trip Part 2", user_id: 2,
  description: "An introduction to the very basics of the JavaScript
    language. Build a foundation of JavaScript syntax and learn how to use values, variables, and files.",
  status: 0,
  start_date: Time.now,
  subjects_attributes: {
    "0": {name: "The Cliffs of Value",
      description: "Learn to manipulate values on the console."},
    "1": {name: "Variable Valley",
      description: "Review how to store and use data with variables."},
    "2": {name: "Files Falls",
      description: "Create JS files and source them within HTML code."}
  }
  course3= Course.create! name: "JavaScript Road Trip Part 3", user_id: 1,
  description: "An introduction to the very basics of the JavaScript
    language. Build a foundation of JavaScript syntax and learn how to use values, variables, and files.",
  status: 0,
  start_date: Time.now,
  subjects_attributes: {
    "0": {name: "The Cliffs of Value",
      description: "Learn to manipulate values on the console."},
    "1": {name: "Variable Valley",
      description: "Review how to store and use data with variables."},
    "2": {name: "Files Falls",
      description: "Create JS files and source them within HTML code."}
  }
5.times do |n|
  UserCourse.create! user_id: n + 5,
    course_id: course.id,
    supervisor: 0,
    status: 0
end
UserCourse.create! user_id: 2,
  course_id: course.id,
  supervisor: 1,
  status: 0
