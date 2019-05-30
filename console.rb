require_relative( 'models/casting' )
require_relative( 'models/movie' )
require_relative( 'models/star' )

require('pry-byebug')

Casting.delete_all
Movie.delete_all
Star.delete_all

movie1 = Movie.new({ 'title' => "Matrix" , "genre" => "Scifi", "budget" => "1000"})
movie1.save
movie2 = Movie.new({ 'title' => "Jurassic Park" , "genre" => "horror", "budget" => "90000"})
movie2.save

star1 = Star.new({ "first_name" => "Keanu", "last_name" => "Reeves"})
star2 = Star.new({ "first_name" => "Karrie-Anne", "last_name" => "Moss"})
star1.save
star2.save

casting1 = Casting.new({ "star_id" => star1.id, "movie_id" => movie1.id, "fee" => "100"})
casting2 = Casting.new({ "star_id" => star2.id, "movie_id" => movie1.id, "fee" => "100"})
casting3 = Casting.new({ "star_id" => star2.id, "movie_id" => movie2.id, "fee" => "100"})
casting1.save
casting2.save
casting3.save

binding.pry
nil
