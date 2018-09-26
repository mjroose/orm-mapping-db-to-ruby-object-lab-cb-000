class Student
  attr_accessor :id, :name, :grade

  def initialize(attributes = nil)
    if attributes != nil
      @name = attributes[:name]
      @grade = attributes[:grade]
      @id = attributes[:id]
    else
      @name, @grade, @id = nil
    end
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(name: name, grade: grade, id: id)
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 9;
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = ?;
    SQL

    DB[:conn].execute(sql, grade).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade < 12;
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 10
      LIMIT 1;
    SQL

    row = DB[:conn].execute(sql).first
    self.new_from_db(row)
  end

  def self.first_X_students_in_grade_10(number_of_students)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 10
      LIMIT ?;
    SQL

    result = DB[:conn].execute(sql, number_of_students).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
      LIMIT 1;
    SQL

    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
