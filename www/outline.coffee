# Models:
# 	Match:
# 		players
# 			score
# 		mineshaft
# 		shop

# 		Hand:
# 			cards
# 			actions
# 			to_spend


class Match
	constructor: (@id, @players, @mineshaft, @shop, @hand, @deck) ->
	lobby_list: ->
		@el = $("""
			<li>
				<a href='#match' class='match-list-item' data-transition='slide' data-id='#{@id}'>
					#{player.name for player in @players}
				</a>
			</li>
		""")
		@el.on 'click', =>
			this.render()
	render: ->
		@hand.render()


class Hand
	constructor: (@cards) ->
		@actions = 1
	render: ->
		$('#hand').html('') # reset html
		$('#hand').append(card.el) for card in @cards

class Deck
	constructor: (@cards) ->


class Card
	constructor: (@name) ->
		@el = $("<li class='card'>#{@name}</li>")
		@el.on 'click' ->
			# do something



match = new Match(
	match.id,
	match.players,
	match.mine,
	new Hand(new Card(card_name) for card_name in match.deck.hand),
	new Deck(new Card(card_name) for card_name in match.deck.cards)
)

get_lobby = ->
  $.getJSON "#{server_url}/matches/all.json", (matches) ->
    console.log 'got matches'
    console.log data
    $('#matches').html('')
    create = (match) ->
    	match = new Match(
				match.id,
				match.players,
				match.mine,
				new Hand(new Card(card_name) for card_name in match.deck.hand),
				new Deck(new Card(card_name) for card_name in match.deck.cards)
			)
	    $('#matches').append(match.el)

	  create match for match in matches
