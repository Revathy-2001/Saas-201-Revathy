require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def self.overdue
    (Todo.all.filter { |todo| todo.overdue? })
  end

  def self.due_today
    (Todo.all.filter { |todo| todo.due_today? })
  end

  def self.due_later
    (Todo.all.filter { |todo| todo.due_later? })
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}.  #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list(arr)
    arr.map { |todo| todo.to_displayable_string }
  end

  def self.add_task(new_task)
    Todo.create!(todo_text: new_task[:todo_text], due_date: Date.today + new_task[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find_by(id: todo_id)
    if !todo.nil?
      todo.completed = true
      todo.save
    else
      puts "No such Id Exists!"
      exit
    end
    todo
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts to_displayable_list(Todo.overdue)
    puts "\n\n"

    puts "Due Today\n"
    puts to_displayable_list(Todo.due_today)
    puts "\n\n"

    puts "Due Later\n"
    puts to_displayable_list(Todo.due_later)
    puts "\n\n"
  end
end
