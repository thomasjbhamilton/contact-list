require 'csv'
require 'pry'
require 'pg'

class Contact
  TABLE = 'contacts'
  attr_accessor :name, :email
  attr_reader :id

  def initialize(params={})
    @id = params[:id]
    @name = params[:name]
    @email = params[:email]
  end

  def saved?
    !@id.nil?
  end

  # Add new or update customer
  def save
    if saved?
      Contact.conn.exec("UPDATE #{TABLE} SET name =$2, email =$3 WHERE id = $1::int;", [@id, @name, @email])
    else
      Contact.conn.exec("INSERT INTO #{TABLE} (name, email) VALUES ($1,$2);", [@name, @email])
    end
  end

  def destroy
    Contact.conn.exec("DELETE FROM #{TABLE} WHERE id = $1::int;", [@id])
  end

  class << self

    def create(name, email)
      contact = Contact.new(name: name, email: email)
      contact.save
      contact
    end

    def instance_from_row(row)
      self.new({
        id: row['id'].to_i,
        name: row['name'],
        email: row['email']
      })
    end

    def all
      self.conn.exec("SELECT * from #{TABLE};").map {|contact| instance_from_row(contact)}
    end

    def find(id)
      self.conn.exec("SELECT * FROM #{TABLE} WHERE id = $1::int;", [id]).map {|contact| instance_from_row(contact)}.first
    end

    def find_or_initialize(id)
      if contact_exists?(id)
        self.find(id)
      else
        self.new
      end
    end

    def contact_exists?(id)
      self.conn.exec("SELECT * FROM #{TABLE} WHERE id = $1::int;", [id]).cmd_tuples > 0
    end

    def search(term)
      self.conn.exec("SELECT * FROM #{TABLE} WHERE name LIKE $1;", ["%#{term}%"]).map {|contact| instance_from_row(contact)}.first
    end

    def conn
      PG.connect(
        host: 'localhost',
        dbname: 'contacts',
        user: 'development',
        password: 'development'
        )
    end
  end
end
