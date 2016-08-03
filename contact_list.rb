 require_relative 'contact'

class ContactList
  class << self
    def create_new_contact
      puts "What is the name of the person you want to add?"
      name = STDIN.gets.chomp
      puts "what is their email?"
      email = STDIN.gets.chomp
      Contact.create(name, email)
    end

    def list_all_contacts
      Contact.all.each do |c|
        puts "#{c.id} #{c.name}, (#{c.email})"
      end
    end

    def show_a_contact
      id = ARGV[1].to_i
      c = Contact.find(id)
      puts "#{c.id} #{c.name}, (#{c.email})"
    end

    def seach_for_contacts
      qualifier = ARGV[1]
      c = Contact.search(qualifier)
      puts "#{c.id} #{c.name}, (#{c.email})"

    end

    def update_a_contact
      id = ARGV[1].to_i
      the_contact = Contact.find_or_initialize(id)
      puts "What do you want their name to be?"
      the_contact.name = STDIN.gets.chomp
      puts "What do you want their email to be?"
      the_contact.email = STDIN.gets.chomp
      the_contact.save
    end

    def delete_a_contact
      id = ARGV[1].to_i
      the_contact = Contact.find(id)
      the_contact.destroy
    end
  end

  case ARGV[0]
    when "new"
      self.create_new_contact

    when "list"
      self.list_all_contacts

    when "show"
      self.show_a_contact

    when "search"
      self.seach_for_contacts

    when "update"
      self.update_a_contact

    when "delete"
      self.delete_a_contact

    else
      puts "here are the commands you can do:"
      puts "  new     - Create a new contact"
      puts "  update  - Update a contact"
      puts "  list    - List all contacts"
      puts "  show    - Show a contact"
      puts "  search  - Search contacts"
      puts "  delete  - Delete contacts"
      puts ""
  end
end

main = ContactList.new
