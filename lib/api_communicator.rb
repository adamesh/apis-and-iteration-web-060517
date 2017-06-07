require 'rest-client'
require 'json'
require 'pry-byebug'

def get_character_movies_from_api(character)
  #make the web request
  character_array = []

  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  until character_hash["next"] == nil
    character_array << character_hash["results"]
    character_hash = JSON.parse(RestClient.get(character_hash["next"]))
  end
  character_array.flatten!

  #get pagination


  # iterate over the character hash to find the collection of `films` for the given
  #   `character`

  films_link_array = []
  character_array.each do |characters|
    if characters["name"].downcase == character
      films_link_array = characters["films"]
    end
  end

  films_array = films_link_array.map do |link|
    JSON.parse(RestClient.get(link))
  end

  films_array.sort! do |x, y|
    x["episode_id"] <=> y["episode_id"]
  end
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  puts "Appeared in: "
  films_hash.each do |movie|
    puts "Episode #{movie["episode_id"]}: #{movie["title"]}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

# parse_character_movies(get_character_movies_from_api("Luke Skywalker"))

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
