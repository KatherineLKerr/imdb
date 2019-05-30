require_relative("../db/sql_runner")
require_relative("star")

class Movie

  attr_reader :id
  attr_accessor :title, :genre, :budget

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @budget = options['budget'].to_i
  end

  def save
    sql = "INSERT INTO movies
    (title, genre, budget)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@title, @genre, @budget]
    movie_hash = SqlRunner.run(sql, values)
    @id = movie_hash[0]['id'].to_i
  end

  def update
    sql = "UPDATE movies SET
    (
    title, genre, budget
    ) = (
    $1, $2, $3
    ) WHERE id = $4"
    values = [@title, @genre, @budget, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM movies WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def stars
    sql = "SELECT stars.* FROM stars INNER JOIN castings ON castings.star_id = stars.id WHERE movie_id = $1"
    values = [@id]
    stars_array = SqlRunner.run(sql, values)
    result = stars_array.map{|star| Star.new(star)}
    return result
  end

  def remaining_budget
    sql = "SELECT castings.fee FROM castings
    INNER JOIN stars
    ON castings.star_id = stars.id
    WHERE movie_id = $1"
    values = [@id]
    fees_array = SqlRunner.run(sql, values)
    fees = fees_array.map{|fee| fee["fee"].to_i}

    movie_budget = @budget
    for fee in fees
      movie_budget -= fee
    end
    return movie_budget
  end

  def self.all
    sql = "SELECT * FROM movies"
    all_movies = SqlRunner.run(sql)
    result = all_movies.map{|movie| Movie.new(movie)}
    return result
  end

  def self.delete_all
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM movies WHERE id = $1"
    values =[id]
    movie = SqlRunner.run(sql, values)[0]
    return Movie.new(movie)
  end




end
