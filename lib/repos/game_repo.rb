module RpsGame

	class GameRepo
		def self.create_game(db, game_data)
			the_time = Time.now

    		q = <<-SQL
    		INSERT INTO matches(start_time, user_id_one, user_id_two) 
    		VALUES($1, $2) RETURNING 'id'; 
    		SQL

			r = db.exec(q, [the_time.to_i, game_data['user_id_one'], game_data['user_id_two']])
			return JSON.generate(r)
    	end
	end

end