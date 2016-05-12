# require "pry"
require 'active_support/inflector'
require 'twitter'


exit unless ((Time.now.hour % 3) == 0)

def ina_sentence
  structures = open('lib/structures.txt').read.split("\n")
  ingredients = open('lib/ingredients.txt').read.split("\n")
  places = open('lib/places.txt').read.split("\n")

  sentence = structures.sample
  if sentence =~ /#\{place\}/
    place = places.sample
    sentence = sentence.gsub('#{place}', place)
  end
  if num_ingredients = sentence.scan(/#\{ingredient\}/)
    ingredient_list = ingredients.sample(num_ingredients.count)
    ingredient_list.each do |ingredient|
      sentence = sentence.sub('#{ingredient}', ingredient)
    end
  end
  if sentence =~ /#\{ingredients\}/
    ingredient = ingredients.sample
    sentence = sentence.gsub('#{ingredients}',ingredient.pluralize)
  end
  if sentence =~ /#\{same ingredient\}/
    ingredient = ingredients.sample
    sentence = sentence.gsub('#{same ingredient}',ingredient)
  end
  sentence[0] = sentence[0].upcase
  sentence = sentence.gsub(',,',',').gsub(',.','.')
  sentence
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['consumer_key']
  config.consumer_secret = ENV['consumer_secret']
  config.access_token = ENV['access_token']
  config.access_token_secret = ENV['access_token_secret']
end

# client.update(ina_sentence)