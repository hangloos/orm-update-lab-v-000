require 'pry'

require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end


  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY, 
    name TEXT, 
    grade INTEGER)
    SQL

    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end


  def save
    sql = <<-SQL
    INSERT INTO students(name, grade) VALUES (?,?)
    SQL

    DB[:conn].execute(sql,self.name,self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end


  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(database_array)
    self.new(database_array[0],database_array[1],database_array[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    student = DB[:conn].execute(sql,name)
    new_from_db(student[0])
  end


  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql,self.name,self.grade,self.id)
  end
  
end
