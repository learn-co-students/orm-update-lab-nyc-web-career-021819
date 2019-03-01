require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade)
    self.name = name
    self.grade = grade
    self.id = nil
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def self.create_table
    DB[:conn].execute("CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if self.id != nil
      #replace w/ update
      DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
    else 
      #code to save new record to db, assign it's id
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
  end

  def self.new_from_db(attributes)
    new_student = Student.new(attributes[1], attributes[2])
    new_student.id = attributes[0]
    new_student
  end

  def self.find_by_name(name)
    student_array = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    new_student = new_from_db(student_array[0])
    new_student
  end


  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
  end


end
