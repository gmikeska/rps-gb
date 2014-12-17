module RpsGame

	class UserRepo
		def self.all(db)
			db.exec("SELECT * FROM users").to_a
    	end
    	def self.create_user(db, user_data)
    		q = <<-SQL 
    		SELECT * FROM users 
    		WHERE username = $1 
    		SQL
    		check = db.exec(q, [user_data['username']]).to_a
    		if(check == [])
				q = <<-SQL
				INSERT INTO users(username, password) 
				VALUES($1, $2) RETURNING 'id'; 
				SQL
				r = db.exec(q, [user_data['username'], Password.create(user_data['password'])])
			else
				r = {'error'=>'Username is already taken! Please choose another username!'}
			end
			return JSON.generate(r)
    	end
		def self.auth_user(db, user_data)
    		q = <<-SQL
    		SELECT * FROM users 
    		WHERE username = $1 
    		SQL
    		user_record = db.exec(q, [user_data['username']]).to_a.first
    		if(user_record)
				if(Password.new(user_record['password']) == user_data[password])
					r = user_record
					r.delete('password')
				else
					r = {'error' => 'Incorrect username or password.'}
				end
			else
				r = {'error' => 'Incorrect username or password.'}
			end
			return JSON.generate(r)
    	end
    	def self.find(db, user_id)
    		q = <<-SQL
    		SELECT * FROM users 
    		WHERE id = $1 
    		SQL
    		r = db.exec(q, [user_id]).to_a.first
    		return JSON.generate(r)
    	end
    	def self.get_games(db, user_id)
    		q = <<-SQL
    		SELECT * FROM users 
    		WHERE user_id_one = $1 or user_id_two = $2 
    		SQL
    		r = db.exec(q, [user_id, user_id]).to_a
    		return JSON.generate(r)
    	end
    	def self.get_open_games(db, user_id)
    		q = <<-SQL
    		SELECT * FROM users 
    		WHERE user_id_one = $1 and end_time = NULL or user_id_two = $2 and end_time = NULL 
    		SQL
    		r = db.exec(q, [user_id, user_id]).to_a
    		return JSON.generate(r)
    	end
	end
end