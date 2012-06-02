# THIS FILE IS BARE.. NO CLOSURE WRAPPER

# server_url = "http://mine-games.herokuapp.com" # TODO: replace with actual production server
server_url = "http://localhost:3000" # TODO: replace with actual production server

# preventBehavior = (e) ->
#   e.preventDefault()
# document.addEventListener "touchmove", preventBehavior, false

onBodyLoad = ->
  document.addEventListener "deviceready", onDeviceReady, false

onDeviceReady = ->
  $ ->

    gsub = (source, pattern, replacement) ->
      unless pattern? and replacement?
        return source

      result = ''
      while source.length > 0
        if (match = source.match(pattern))
          result += source.slice(0, match.index)
          result += replacement
          source = source.slice(match.index + match[0].length)
        else
          result += source
          source = ''

      result

    # String::gsub =  (re, replStr) ->
    #   while (i = @indexOf(re)) != -1 # Do this block while 're' is found in the string
    #     pre  = @substr(0, i) # pre = the string up until 're' is found
    #     post = @substr(i+_.size(re),_.size(@)) # post = the string after the 're'
    #     @ = pre + replStr + post # put pre and post together with the replStr in between

    # Array::minus = (v) ->
    #   x for x in @ when x isnt v

    Array::minus = (v) ->
      results = []
      for x in @
        if x!=v
          results.push x
        else
          v = ''
      results


    Array::popper = (e) ->
      popper = @[e..e]
      @[e..e] = []
      return popper


    # pusher = new Pusher('efc99ac7a3e488aaa691')
    # channel = pusher.subscribe('mine-games')
    # channel.bind('new_match', (data) ->
    #   console.log(data)
    #   $('.matches').append("<li><a href='#match' class='match-list-item' data-transition='slide' data-id='#{data.match.id}'>#{user.username for user in data.match.users}</a></li>").listview('refresh')
    # )



    templates =
      LobbyMatchListItem: (id, players, turn) ->
        "<li><a>#{player.username for player in players} : #{if turn then 'your turn' else 'their turn'}</a></li>"
      CardListItem: (name, desc) ->
        "<li class='card'><a href='#card-detail' class='card-list-item' data-transition='slide'><img src='#{gsub(name, ' ', '_')}_thumb.png' alt='' />#{name}#{desc}</a></li>"

    cards =
      stone_pickaxe:
        name: 'stone pickaxe'
        type: 'action'
        cost: 3
        use: ->
          actions.mine
            number: 1
            callback: (new_card) ->
              console.log 'calling callback'
              log_msg = "<span class='name'>#{current.user.username}</span> used an <span class='item action'>Stone Pickaxe</span> and got a <span class='money'>#{new_card}</span>"
              if typeof current.match.get('log') isnt 'Array'
                log = []
              else
                log = current.match.get('log')
              log.push log_msg
              current.match.set('log', log)
              console.log log_msg

      iron_pickaxe:
        name: 'iron pickaxe'
        type: 'action'
        cost: 5
        use: ->
          actions.mine
            number: 2
          
      diamond_pickaxe:
        name: 'diamond pickaxe'
        type: 'action'
        cost: 8
        use: ->
          actions.mine(
            number: 3
          )

      copper:
        name: 'copper'
        type: 'money'
        value: 1
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      silver:
        name: 'silver'
        type: 'money'
        value: 2
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      gold:
        name: 'gold'
        type: 'money'
        value: 3
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      diamond:
        name: 'diamond'
        type: 'money'
        value: 5
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      tnt:
        name: 'tnt'
        type: 'action'
        cost: 6

      minecart:
        name: 'minecart'
        type: 'action'
        cost: 5

      headlamp:
        name: 'headlamp'
        type: 'action'
        cost: 4

      gopher:
        name: 'gopher'
        type: 'action'
        cost: 6

      magnet:
        name: 'magnet'
        type: 'action'
        cost: 6

      alchemy:
        name: 'alchemy'
        type: 'action'
        cost: 5

    actions =
      mine: (options) ->
        console.log 'mine'
        for i in [1..options.number]
          do ->
            console.log 'iterating..'
            m = current.match.get('mine')
            h = current.deck.get('hand')

            nc = m[0]
            m[0..0] = []
            h.push nc

            current.match.set('mine', m)
            current.deck.set('mine', h)

            console.log "new card: #{nc}"
            console.log current.deck.get('hand')

            view = new CardListView(cards[gsub(nc, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore
            current.hand.push view
            options.callback(nc)

      draw: (options, callback) ->
        console.log 'draw from your deck'
        for i in [1..options.number]
          do ->
            console.log 'iterating..'
            c = current.deck.get('cards')
            h = current.deck.get('hand')

            nc = c[0]
            c[0..0] = []
            h.push nc

            current.deck.set({cards: c})
            current.deck.set({hand: h})

            console.log "new card: #{nc}"

            view = new CardListView(cards[gsub(nc, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore
            current.hand.push view

        # if callback?
        #   callback()
        # else
        #   return
        # do something
      discard: (options, cb) ->
        # insert view that tells user to discard cards
        # add icon to click on each card that let's user discard that card
        $('.discard').show()
        console.log options.number
        current.deck.set
          amount_to_discard: options.number
          amount_discarded: 0
          discard_type: options.type

      trash: (i, type, cb) ->
        # do something

    current =
      lobby: 0 # LobbyView
      match: 0 # Match model
      deck:  0 # Deck model
      hand:  [] # array of CardListView
      turn: false
      user: 0
      before_turn: ->
        # do nothing

    # Models / Collections
    # ============================================

    class Match extends Backbone.Model
      initialize: ->
        # do something

    class Matches extends Backbone.Collection
      initialize: ->
        @fetch()
        @on 'reset', =>
          console.log @

      model: Match
      url: "#{server_url}/matches"

    class Deck extends Backbone.Model
      initialize: ->
        @on 'change', =>
          @save()
          if @actions is 0 and @buys is 0
            # server request to change turn
            if current.match.turn + 1 > current.match.players.length + 1
              current.match.turn = 0
            else
              current.match.turn += 1
            # end turn
          # @save()

      amount_to_discard: 0
      amount_discarded: 0
      type: 0

    class Decks extends Backbone.Collection
      initialize: ->
        @fetch()

      model: Deck
      url: "#{server_url}/decks"


    # Views
    # ============================================

    class ShopListView extends Backbone.View
      initialize: (@card, @amount) ->
        console.log 'init ShopListView'
        @setElement $('#templates').find("#shop-item").clone()
        @render()

      render: ->
        console.log 'ShopListView#render'
        $('#shop').append(@el)
        #@$el.find('img')
        @$el.find('.count').html(@amount)
        @$el.find('.price').html(@card.cost)
        @$el.find('.name').html(@card.name)


    class ShopView extends Backbone.View

      initialize: (@card) ->
        console.log 'init ShopView'
        @render()

      el: '#shop'

      render: ->
        console.log 'ShopListView#render'
        shop = {}
        prev = ''
        console.log current.match.get('shop')
        for card in current.match.get('shop')
          do (card) =>
            console.log 'iterating shop cards'
            if card != prev
              shop[card] = 1
            else
              console.log 'dupe'
              shop[card] = shop[card] + 1
            prev = card

        console.log shop
        for card, amount of shop
          view = new ShopListView(cards[gsub(card, ' ', '_')], amount)

    class CardDetailView extends Backbone.View
      el: 'what'

    class CardListView extends Backbone.View

      initialize: (@card) ->
        console.log 'init CardListView'
        @setElement $('#templates').find("##{gsub(@card.name, ' ', '_')}").clone()
        @render()

      events:
        # 'click': 'use'
        'touchstart': 'touchstart'
        'touchmove': 'touchmove'
        'swiperight': 'swiperight'
        'touchend': 'touchend'
        'touchcancel': 'touchend'
        'click .discard': 'discard'
        # 'click .trash': 'trash'

      render: ->
        console.log 'rendering CardListView'
        $('#hand').append(@el)

      # use: ->
      #   if current.turn
      #     @card.use()
      #   current.deck.set({ actions: current.deck.get('actions') - 1 }) if @card.type == 'action'


      w: 55
      touch:
        x1: 0
        y1: 0
      swiping: false
      dragging: false
      selected: false
      use: false

      render_card: ->
        console.log 'render me!'

      touchstart: (e) ->
        # touch.x1 = e.touches[0].pageX
        # touch.y1 = e.touches[0].pageY
        @touch.x1 = e.originalEvent.pageX
        @touch.y1 = e.originalEvent.pageY

      touchmove: (e) ->
        if current.deck.get('actions') > 0 and current.turn
          @dx = e.originalEvent.pageX - @touch.x1
          @dy = e.originalEvent.pageY - @touch.y1
          if Math.abs(@dy) < 6 and Math.abs(@dx) > 0 and not @swiping and not @dragging
            @swiping = true
            window.inAction = true
            @$el.addClass "drag"
          if @swiping
            if @dx > 0 and @dx < @w
              @use = false
              pct = @dx / @w
              pct = 0  if pct < 0.05
            else if @dx < 0 and @dx > -@w
            else if @dx >= @w
              @use = true
              @dx = @w + (@dx - @w) * .25
            else if @dx <= -@w
              @dx = -@w + (@dx + @w) * .25
            if @dx >= @w - 1
              @$el.addClass "green"
              @used = true
              # trigger use event
            else
              @$el.removeClass "green"
            @$el.css "-webkit-transform", "translate3d(" + @dx + "px, 0, 0)"  #if dx <= 0 #or list.todos.length > 0

      swiperight: (e) ->
        console.log 'swiping right'

      touchend: (e) ->
        console.log 'touch end'
        @$el.removeClass("drag green").css "-webkit-transform", "translate3d(0,0,0)"
        if @use and @dx >= @w - 1
          @dx = 0
          if current.turn
            console.log 'using card'
            @card.use()
            @discard()
            current.deck.set('actions', current.deck.get('actions') - 1 ) if @card.type == 'action'


      discard: () ->
        @remove()
        nh = current.deck.get('hand')
        nh = nh.minus(@card.name)
        current.deck.set('hand', nh)
        console.log current.deck.get('hand')
        current.deck.set('amount_discarded', current.deck.get('amount_discarded') + 1)
        # console.log current.deck.get('amount_to_discard') # FIXME: some error happens here
        # console.log current.deck.get('amount_discarded')
        if current.deck.get('amount_discarded') == current.deck.get('amount_to_discard')
          console.log 'discard limit reached'
          $('.discard').hide()


    class MatchView extends Backbone.View

      initialize: () ->
        console.log 'init MatchView'
        @render()
        if current.match.get('turn') == current.user.id
          current.turn = true
        else
          current.turn = false

        current.deck.on 'change:actions', =>
          console.log 'actions changed'
          @$el.find('#actions > .count').html(current.deck.get 'actions')
        current.deck.on 'change:hand', =>
          console.log 'hand changed'
          @$el.find('#to_spend > .count').html(@to_spend())

      el: '#match'

      to_spend: ->
        to_spend = 0
        for card in current.deck.get('hand')
          do (card) ->
            if cards[gsub(card, ' ', '_')].type == 'money'
              to_spend += cards[gsub(card, ' ', '_')].value
        to_spend

      events:
        'click #end_turn': 'end_turn'

      render: ->
        console.log 'rendering MatchView'
        console.log @$el.find('#hand')
        @$el.find('#hand').html('')
        console.log current.deck
        for card in current.deck.get('hand')
          do (card) =>
            console.log 'some card'
            view = new CardListView(cards[gsub(card, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore)
        #     current.hand.push view # TODO should probably take this out.

        @$el.find('#actions > .count').html(current.deck.get 'actions')
        @$el.find('#to_spend > .count').html(@to_spend())
        @$el.find('#turn > .count').html(current.match.get 'turn')


        $.mobile.changePage "#match",
          transition: "slide"

        # render all the other shit too

      end_turn: ->
        console.log 'ending turn'
        $.post("#{server_url}/end_turn/#{current.match.get('id')}", (data) ->
          console.log data
          current.match.fetch()
          current.deck.fetch()
        )
        # do something

    class MatchListView extends Backbone.View

      initialize: (@match, @deck) ->
        console.log 'init MatchListView'
        @setElement templates.LobbyMatchListItem(@match.get('id'), @match.get('players'), @match.get('turn') == current.user.id)
        @render()

      events:
        'click': 'render_match'

      render: ->
        console.log 'MatchListView#render'
        $('#matches').append(@el).listview('refresh')

      render_match: ->
        console.log 'rendering match'
        current.match = @match
        current.deck = @deck
        view = new MatchView()
        shopview = new ShopView()
        
    class LobbyView extends Backbone.View

      initialize: () ->
        console.log 'init LobbyView'
        # matches.on 'change', =>
        #   @render()
        @render()

      el: '#lobby'

      events:
        # 'click #refresh_lobby': 'refresh'
        'click .logout': 'logout'

      logout: ->
        $.cookie('token', null)
        $.mobile.changePage "#home",
          transition: "flip"

      render: =>
        console.log 'LobbyView#render'
        matches.fetch()
        decks.fetch()
        matches.on 'reset', => # 'reset' event is triggered when Collection#fetch completes
          decks.on 'reset', =>
            $('#matches').html('')
            console.log 'fetched data for matches and decks'
            $.mobile.changePage "#lobby",
            transition: "none"
            for match in matches.models
              do (match) =>
                d = decks.where(match_id: match.get('id'))
                view = new MatchListView(match, d[0])

      refresh: ->
        @render()



    # Authorization
    # ============================================
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

    matches = new Matches
    decks = new Decks

    $.cookie 'token', 'LollakwpnMXj54X6oWwt2g' #TODO: take this out and find out why cookies aren't persisting
    
    if $.cookie("token")?
      # TODO: match token with user on server side, if match, execute the below block
      console.log 'cookie found'
      # TODO: add 'logging in' animation loader
      $.getJSON("#{server_url}/users/1", (user) ->
        current.user = user
        console.log 'instantiating LobbyView'
        current.lobby = new LobbyView()
      )
    else
      console.log 'cookie not found'
      console.log $.cookie 'token'

    $("#facebook-auth").on 'click', ->
      console.log 'clicked facebook'
      facebook_auth ->
        current.lobby = new LobbyView()

    $('#login-form').submit (e) ->
      $.post("#{server_url}/signin.json", $(this).serialize(), (user) ->
        if user.error?
          alert 'invalid username and/or password'
        else
          $.cookie 'token', user.token
          console.log $.cookie 'token'
          current.user = user
          current.lobby = new LobbyView()
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
          current.lobby = new LobbyView()
      , 'json')
      e.preventDefault()













