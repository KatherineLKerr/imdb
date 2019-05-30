require_relative("../db/sql_runner")
require_relative("movie")
require_relative("star")

class Casting

  attr_reader :id
  attr_accessor :star_id, :movie_id, :fee

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @star_id = options["star_id"].to_i
    @movie_id = options["movie_id"].to_i
    @fee = options["fee"]
  end

  def save
    sql = "INSERT INTO castings
    (star_id, movie_id, fee)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@star_id, @movie_id, @fee]
    casting_hash = SqlRunner.run(sql, values)
    @id = casting_hash[0]['id'].to_i
  end

  def update
    sql = "UPDATE castings SET (
    star_id, movie_id, fee
    ) = (
      $1, $2, $3
    ) WHERE id = $4"
    values = [@star_id, @movie_id, @fee, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM castings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM castings WHERE id = $1"
    values = [id]
    casting_hash = SqlRunner.run(sql, values).first
    casting = Casting.new(casting_hash)
    return casting
  end

  def self.delete_all
    sql = "DELETE FROM castings"
    SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM castings"
    array_of_hashes = SqlRunner.run(sql)
    array_of_objects = array_of_hashes.map{|casting| Casting.new(casting)}
    return array_of_objects
  end

end
