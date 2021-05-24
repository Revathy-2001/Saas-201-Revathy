require "active_record"

class Todo < ActiveRecord::Base
  def self.overdue
    where("due_date < ?", Date.today)
  end

  def self.due_today
    where("due_date = ?", Date.today)
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = (due_date == Date.today) ? nil : due_date
    "#{id}.  #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.add_task(new_task)
    create!(todo_text: new_task[:todo_text], due_date: Date.today + new_task[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = find_by(id: todo_id)
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
    puts overdue.to_displayable_list
    puts "\n\n"

    puts "Due Today\n"
    puts due_today.to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    puts due_later.to_displayable_list
    puts "\n\n"
  end
end
