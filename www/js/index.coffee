# THIS FILE IS BARE.. NO CLOSURE WRAPPER

# server_url = "http://mine-games.herokuapp.com" # TODO: replace with actual production server
server_url = "http://localhost:3000" # TODO: replace with actual production server

preventBehavior = (e) ->
  e.preventDefault()
document.addEventListener "touchmove", preventBehavior, false

onBodyLoad = ->
  document.addEventListener "deviceready", onDeviceReady, false

onDeviceReady = ->
  $ ->

    # pusher = new Pusher('efc99ac7a3e488aaa691')
    # channel = pusher.subscribe('mine-games')
    # channel.bind('new_match', (data) ->
    #   console.log(data)
    #   $('.matches').append("<li><a href='#match' class='match-list-item' data-transition='slide' data-id='#{data.match.id}'>#{user.username for user in data.match.users}</a></li>").listview('refresh')
    # )

    # dragging = false
    # dragFrom = 0
    # swiping = false
    # touch = {x1: '', y1: ''}
    # w = 55
    # dx = dy = 0
    # window.globalDrag = false
    # window.editing = false
    # used = false

    # cards =
    #   copper:
    #     type: 'money'
    #     value: 1
    #   silver:
    #     type: 'money'
    #     value: 2
    #   gold:
    #     type: 'money'
    #     value: 3
    #   diamond:
    #     type: 'money'
    #     value: 5
    #   stone_pickaxe:
    #     type: 'action'
    #     cost: 2
    #     desc: ''
    #     actions:
    #       mine: 1
    #   leather_bag:
    #     type: 'action'
    #     cost: 2
    #     desc: ''
    #     actions: [
    #       plus_action(1),
    #       plus_card()
    #     ]

    # Models
    # ============================================

    templates =
      LobbyMatchListItem: (id, players) ->
        "<li><a href='#match' class='match-list-item' data-transition='slide' data-id='#{id}'>#{player.username for player in players}</a></li>"
      CardListItem: (name, desc) ->
        "<li><a href='#card-detail' class='card-list-item' data-transition='slide'><img src='#{name}_thumb.png' alt='' />#{name}#{desc}</a></li>"

    cards =
      'stone pickaxe':
        short_desc: '+1 card from the mine'
        long_desc: 'Draw one card from the Mineshaft and add it to your hand.'
      'copper':
        short_desc: '+$1'
        long_desc: 'Worth $1 at the shop.'


    class Match extends Backbone.Model

    class Matches extends Backbone.Collection
      initialize: ->
        @fetch()

      url: "#{server_url}/matches"
      model: Match

    class Deck extends Backbone.Model

    class Decks extends Backbone.Collection
      initialize: ->
        @fetch()

      model: Deck
      url: "#{server_url}/decks"

    class LobbyView extends Backbone.View

      initialize: (@matches, @decks) ->
        @render()

      el: '#lobby'

      events:
        'click #refresh_lobby': 'refresh'

      # matches: new Matches
      # decks: new Decks

      render: =>
        @matches.on 'reset', => # 'reset' event is triggered when Collection#fetch completes
          @decks.on 'reset', =>
            console.log 'iterating...'
            for match in @matches.models
              do (match) =>
                console.log match
                deck = @decks.where(match_id: match.get('id'))
                view = new MatchListView(match, deck[0])

                @$el.find('#matches').append(view.el).listview('refresh')

      refresh: ->
        @matches.fetch(add: true)
        @decks.fetch(add: true)
        # Look for new matches



    class MatchListView extends Backbone.View

      initialize: (@match, @deck) ->
        @el = templates.LobbyMatchListItem(@match.get('id'), @match.get('players'))

      events:
        'click': 'render_match'

      render_match: ->
        view = new MatchView(@match, @deck)
        view.match = @match
        view.deck = @deck

        view.render()

    class MatchView extends Backbone.View

      initialize: (@match, @deck) ->

      el: '#match'

      render: ->
        for card in @deck.hand
          do (card) ->
            view = new CardListView
            $el.find('#hand').append(view.el)

        # render all the other shit too


    class CardListView extends Backbone.View
      # el: templates.CardListItem(@card.name, cards[@card.name].short_desc)
      events:
        'click': 'render_card'
      render_card: ->

#============================

    # class Match
    #   constructor: (@id, @players, @mineshaft, @shop, @hand, @deck) ->

    #     @el = $("""
    #       <li>
    #         <a href='#match' class='match-list-item' data-transition='slide' data-id='#{@id}'>
    #           #{(player.username for player in @players)}
    #         </a>
    #       </li>
    #     """)
    #     @el.on 'click', =>
    #       @render()

    #   render: () ->
    #     @hand.render(@)
    #     @deck.render(@)

    #   set_action_count: (i) ->
    #     match.actions += i

    #   mine: (i) ->
    #     j = i - 1
    #     cards = @mineshaft[0..j]
    #     @mineshaft[0..j] = []
    #     @hand[@hand.length..(@hand.length+j)] = cards

    #   draw: (i) ->
    #     j = i - 1
    #     cards = @deck[0..j]
    #     @deck[0..j] = []
    #     @hand[@hand.length..(@hand.length+j)] = cards

    #   discard: () ->


    # class Hand
    #   constructor: (@cards) ->
    #     @actions = 1
    #   render: (match) ->
    #     @match = match
    #     @cards.render(@match)
    #     $('#hand').html('') # reset html
    #     $('#hand').append(card.el) for card in @cards

    # class Deck
    #   constructor: (@cards) ->
    #   render: (match) ->
    #     @match = match
    #     @cards.render(@match)

    # class Card
    #   constructor: (@name) ->
    #   render: (match) ->
    #     @match = match
    #     @el = $("<li class='card'>#{@name}</li>")
    #     @el.on('click', ->
    #       @[@name]()
    #       # do something
    #     ).on('touchstart', (e) ->
    #       if not window.editing
    #         # touch.x1 = e.touches[0].pageX
    #         # touch.y1 = e.touches[0].pageY
    #         touch.x1 = e.originalEvent.pageX
    #         touch.y1 = e.originalEvent.pageY
    #     ).on('touchmove', (e) ->
    #       if not window.globalDrag and not window.editing and not window.draggingDown #and e.touches.length is 1
    #         dx = e.originalEvent.pageX - touch.x1
    #         dy = e.originalEvent.pageY - touch.y1
    #         if Math.abs(dy) < 6 and Math.abs(dx) > 0 and not swiping and not dragging
    #           swiping = true
    #           window.inAction = true
    #           $(this).addClass "drag"
    #           # list.home.resetIcons @el
    #         if swiping
    #           if dx > 0 and dx < w
    #             used = false
    #             pct = dx / w
    #             pct = 0  if pct < 0.05
    #             # $("#check").css "opacity", pct
    #             # line.css "-webkit-transform", "scaleX(" + pct + ")"  unless @done
    #           else if dx < 0 and dx > -w
    #             # $("#cross").css "opacity", -dx / w
    #           else if dx >= w
    #             dx = w + (dx - w) * .25
    #             # $("#check").css
    #             #   opacity: 1
    #             #   "-webkit-transform": "translate3d(" + (dx - w) + "px, 0, 0)"
    #           else if dx <= -w
    #             dx = -w + (dx + w) * .25
    #             # $("#cross").css
    #             #   opacity: 1
    #             #   "-webkit-transform": "translate3d(" + (dx + w) + "px, 0, 0)"
    #           if dx >= w - 1
    #             $(this).addClass "green"
    #             used = true
    #             # if @done
    #             #   @el.removeClass "done"
    #             # else
    #             #   @el.addClass "green"
    #           else
    #             $(this).removeClass "green"
    #             # if todo.done
    #             #   @el.addClass "done"
    #             # else
    #             #   @el.removeClass "green"
    #           $(this).css "-webkit-transform", "translate3d(" + dx + "px, 0, 0)"  #if dx <= 0 #or list.todos.length > 0
    #         # if dragging
    #         #   window.inAction = true
    #         #   $(this).css "-webkit-transform", "translate3d(0," + (dy - dragFrom) + "px, 0) scale(1.05)"
    #         #   if dy - dragFrom < -30 or dy - dragFrom > +30
    #         #     step = Math[(if dy > 0 then "ceil" else "floor")]((if dy > 0 then dy - 30 else dy + 30) / 60)
    #         #     newDragFrom = step * 60
    #         #     if dragFrom isnt newDragFrom and todo.index + step >= 0 and @index + step < @list.todos.length
    #         #       target = $(@list.view.find("li.todo").get(@index + step))
    #         #       target[(if newDragFrom > dragFrom then "after" else "before")] @el
    #         #       dragFrom = newDragFrom
    #         #       @el.css "-webkit-transform", "translate3d(0," + (dy - dragFrom) + "px, 0) scale(1.05)"
    #     ).on "touchend touchcancel", (e) ->
    #   copper: ->
    #   stone_pickaxe: ->
    #     @match.set_action_count(-1)
    #     @match.mine(1)



    # Controllers
    # ============================================

    # get_lobby = ->
    #   $.getJSON "#{server_url}/matches/all.json", (matches) ->
    #     $('#matches').html('')
    #     create = (match) ->
    #       match = new Match(
    #         match.id,
    #         match.players,
    #         match.mine,
    #         match.shop
    #         new Hand(new Card(card_name) for card_name in match.deck.hand),
    #         new Deck(new Card(card_name) for card_name in match.deck.cards)
    #       )
    #       $('#matches').append(match.el).listview('refresh')

    #     create match for match in matches


    facebook_auth = (callback) ->
      window.plugins.childBrowser.showWebPage "#{server_url}/auth/facebook?display=touch"
      window.plugins.childBrowser.onLocationChange = (loc) ->
        if /access_token/.test(loc)
          # URL looks like: server.com/access_token/:access_token
          access_token = unescape(loc).split("access_token/")[1]
          $.cookie "token", access_token,
            expires: 7300

          window.plugins.childBrowser.close()
          callback()


    # Authorization
    # ============================================

    if $.cookie("token")?
      # TODO: match token with user on server side, if match, execute the below block
      $.mobile.changePage "#lobby",
        transition: "none"
      lobby = new LobbyView(new Matches, new Decks)

    $("#facebook-auth").on 'tap', ->
      console.log 'clicked facebook'
      facebook_auth ->
        $.mobile.changePage "#lobby",
          transition: "none"

    $('#login-form').submit (e) ->
      $.post("#{server_url}/signin.json", $(this).serialize(), (user) ->
        if user.error?
          alert 'invalid username and/or password'
        else
          $.cookie 'token', user.token
          $.mobile.changePage '#lobby',
            transition: 'slidedown'
      , 'json')
      e.preventDefault()

    $('#signup-form').submit (e) ->
      $.post("#{server_url}/users.json", $(this).serialize(), (user) ->
        if user.error?
          alert 'error'
        else
          $.cookie 'token', user.token
          $.mobile.changePage '#lobby',
            transition: 'slidedown'
      , 'json')
      e.preventDefault()

    # Lobby
    # ============================================

    $('.logout').click ->
      $.cookie('token', null)
      $.mobile.changePage "#home",
        transition: "flip"

    $('#lobby').on('pageinit', ->
      # get_lobby()
    )
    $('#refresh_lobby').click ->
      # get_lobby()


    $('#new_match_facebook').on 'pageshow', ->
      # TODO: send to facebook auth if token fails
      $.getJSON "#{server_url}/friends.json", (data) ->
        $("#play_friends").html('')
        list = (friend, type) ->
          # if typeof friend == 'object'
          $("##{type}").append("<label><input id='users_' name='users[]' type='checkbox' value='#{friend.id}'>#{friend.name}</label>").trigger('create')
        list friend, 'play_friends' for friend in data.play_friends
        # list friend, 'invite_friends' for friend in data.invite_friends


    # Create Game
    # ============================================


    $('#new-match-username-form').submit (e) ->
      $.post("#{server_url}/matches.json", $(this).serialize(), (data) ->
        if data.errors.length > 0
          alert error for error in data.errors
        else
          alert "match created"
      , 'json')
      e.preventDefault()













