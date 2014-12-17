require 'pg'
module RpsGame
	def self.create_db_connection()
		cstring = {
  		host: "localhost",
  		dbname: "rps_game",
  		user: "ruby",
  		password: "rubyRailsJS"
		
		}

		PG.connect(cstring)
	end
	def self.clear_db(db)
	    db.exec <<-SQL
	      DELETE FROM users;
	      /* TODO: Clear rest of the tables (books, etc.) */
	    SQL
	end

	def self.create_tables(db)
	    db.exec <<-SQL	
	      CREATE TABLE users(
	        id SERIAL PRIMARY KEY,
	        username VARCHAR,
	        password VARCHAR
	        );
	    SQL
	    db.exec <<-SQL
	      CREATE TABLE matches(
	        id SERIAL PRIMARY KEY,
	        start_time INTEGER,
	        end_time INTEGER,
	        user_id_one INTEGER,
	        user_id_two INTEGER,
	        user_one_action_one VARCHAR,
	        user_two_action_one VARCHAR
	        user_one_action_two VARCHAR,
	        user_two_action_two VARCHAR
	        user_one_action_three VARCHAR,
	        user_two_action_three VARCHAR
	        );
	    SQL
	end
	def self.drop_tables(db)
	    db.exec <<-SQL
	      DROP TABLE users;
	      /* TODO: Drop rest of the tables (books, etc.) */
	    SQL
	end
end