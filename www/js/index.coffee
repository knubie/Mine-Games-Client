# THIS FILE IS BARE.. NO CLOSURE WRAPPER

server_url = "http://mine-games.herokuapp.com"
# server_url = "http://localhost:3000" # TODO: replace with actual production server

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

    changePage = (page, options) ->
      $curr = $('.active')
      $page = $(page)
      console.log page
      console.log 'options undefined' if typeof options == 'undefined'
      if options.reverse == true
          $curr.addClass('reverse')
          $page.addClass('reverse')

      if options.transition == 'none'
        console.log 'switch'
        console.log 'no transition'
        $curr.removeClass 'active reverse'
        $page.addClass 'active'
        $page.removeClass 'reverse'
      else
        console.log "changing page to #{page}"
        $curr.addClass('slide out')
        $page.addClass('slide in active')
        setTimeout(->
          console.log 'settimeout'
          $curr.removeClass('slide out active reverse')
          $page.removeClass('slide in reverse')
        , 350)



    # pusher = new Pusher('efc99ac7a3e488aaa691')
    # channel = pusher.subscribe('mine-games')
    # channel.bind('new_match', (data) ->
    #   console.log(data)
    #   $('.matches').append("<li><a href='#match' class='match-list-item' data-transition='slide' data-id='#{data.match.id}'>#{user.username for user in data.match.users}</a></li>").listview('refresh')
    # )

    cards = # All card properties are definied client-side.
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
            callback: (new_card) ->
              console.log 'calling callback'
              log_msg = "<span class='name'>#{current.user.username}</span> used an <span class='item action'>Iron Pickaxe</span> and got a <span class='money'>#{new_card}</span>"
              if typeof current.match.get('log') isnt 'Array'
                log = []
              else
                log = current.match.get('log')
              log.push log_msg
              current.match.set('log', log)
              console.log log_msg
          
      diamond_pickaxe:
        name: 'diamond pickaxe'
        type: 'action'
        cost: 8
        use: ->
          actions.mine
            number: 3
            callback: (new_card) ->
              console.log 'calling callback'
              log_msg = "<span class='name'>#{current.user.username}</span> used an <span class='item action'>Diamond Pickaxe</span> and got a <span class='money'>#{new_card}</span>"
              if typeof current.match.get('log') isnt 'Array'
                log = []
              else
                log = current.match.get('log')
              log.push log_msg
              current.match.set('log', log)
              console.log log_msg

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

      coal:
        name: 'coal'
        type: 'coal'
        value: 0
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      tnt:
        name: 'tnt'
        type: 'action'
        cost: 6
        use: ->
          #do something

      minecart:
        name: 'minecart'
        type: 'action'
        cost: 5
        use: ->
          current.deck.set('actions', current.deck.get('actions')+1)
          actions.draw
            number: 1
            callback: (new_card) ->
              console.log 'calling callback'
              log_msg = "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Minecart</span> and got a <span class='money'>#{new_card}</span>"
              if typeof current.match.get('log') isnt 'Array'
                log = []
              else
                log = current.match.get('log')
              log.push log_msg
              current.match.set('log', log)
              console.log log_msg

      mule:
        name: 'mule'
        type: 'action'
        cost: 5
        use: ->
          actions.draw
            number: 3
            callback: (new_card) ->
              console.log 'calling callback'
              log_msg = "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Minecart</span> and got a <span class='money'>#{new_card}</span>"
              if typeof current.match.get('log') isnt 'Array'
                log = []
              else
                log = current.match.get('log')
              log.push log_msg
              current.match.set('log', log)
              console.log log_msg

      headlamp:
        name: 'headlamp'
        type: 'action'
        cost: 4

      gopher:
        name: 'gopher'
        type: 'action'
        cost: 1
        use: ->
          console.log "gopher#use"
          current.opponentsview = new ChooseOpponentsView()
          changePage '#choose-opponents',
            transition: 'slide'

          current.attack = (player) ->
            console.log "current#attack"
            console.log "chosen opponent: #{player}"
            # create new deck model from selected opponent
            opponents_decks = new Decks()
            opponents_decks.url = "#{server_url}/decks_by_user/#{player.id}"
            console.log "fetching decks"
            opponents_decks.fetch
              success: ->
                console.log 'fetch success'
                target_deck = opponents_decks.where(match_id: current.match.get('id'))[0]
                actions.draw2 target_deck, 'hand',
                  random: true
                  number: 1

          # remove card from opponent.deck.hand
          # push card to current.deck.hand
          # save both deck models

      magnet:
        name: 'magnet'
        type: 'action'
        cost: 6

      alchemy:
        name: 'alchemy'
        type: 'action'
        cost: 5

    actions = # Actions are decoupled from cards.
      mine: (options) ->
        console.log 'mine'
        for i in [1..options.number]
          console.log 'iterating..'
          m = current.match.get('mine')
          h = current.deck.get('hand')

          nc = m[0]
          m[0..0] = []
          h.push nc

          current.match.set('mine', m)
          current.deck.set('hand', h)

          console.log "new card: #{nc}"
          console.log current.deck.get('hand')

          view = new CardListView(cards[gsub(nc, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore
          current.hand.push view

          options.callback(nc)

      draw2: (model, attribute, options) ->
        # default options
        console.log "setting defaults"
        optoins.number = 1 if typeof options.number == 'undefined'
        optoins.random = false if typeof options.number == 'undefined'

        for i in [1..options.number]
          console.log "#{i}: iterating.."      
          console.log "gtting source and hand"
          console.log "model:"
          console.log model
          console.log "attribute:"
          console.log attribute
          source = model.get(attribute)
          console.log "source: #{source}"
          hand = current.deck.get('hand')
          console.log "hand: #{hand}"

          if options.random == true
            console.log "drawing random card"
            r = Math.floor(Math.random()*source.length-1)
            console.log "r: #{r}"
            newcard = source[r]
            console.log "new card: #{newcard}"
            source[r..r] = []
          else
            console.log "drawing first card"
            newcard = source[0]
            source[0..0] = []

          console.log "pushing new card to hand"
          hand.push newcard

          console.log "source before draw: #{model.get(attribute)}"
          console.log "hand before draw: #{current.deck.get('hand')}"

          model.set(attribute, source)
          current.deck.set('hand', hand)

          console.log "source after draw: #{model.get(attribute)}"
          console.log "hand after draw: #{current.deck.get('hand')}"
          console.log "new card: #{newcard}"

          view = new CardListView(cards[gsub(newcard, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore

          model.save()
          current.deck.save()

          options.callback(newcard) if typeof callback == 'function'

      draw: (options) ->
        console.log 'draw from your deck'
        for i in [1..options.number]
          console.log 'iterating..'
          c = current.deck.get('cards')
          h = current.deck.get('hand')

          nc = c[0]
          c[0..0] = []
          h.push nc

          current.deck.set('cards', c)
          current.deck.set('hand', h)

          console.log "new card: #{nc}"

          view = new CardListView(cards[gsub(nc, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore
          current.hand.push view

          options.callback(nc)

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

    current = # namespace.
      lobby: 0 # LobbyView
      match: 0 # Match model
      deck:  0 # Deck model
      hand:  [] # array of CardListView
      turn: false
      user: 0
      to_spend: 0
      before_turn: ->
        # do nothing

    # Models / Collections
    # ============================================

    class Match extends Backbone.Model
      initialize: ->
        console.log "initializing Match model"
        @on 'change', =>
          console.log "#{@} model changed"

    class Matches extends Backbone.Collection
      initialize: ->
        @fetch()
        console.log 'initializing Matches collection'

      model: Match
      url: "#{server_url}/matches"

    class Deck extends Backbone.Model
      initialize: ->
        @on 'change', =>
          console.log "#{@} model changed"
          # @save()
        @on 'change:actions', =>
          console.log "actions changed, updating DOM"
          $('#actions > .count').html(current.deck.get 'actions')
        @on 'change:hand', =>
          console.log "hand changed, updating DOM"
          $('#to_spend > .count').html(current.deck.to_spend())


      urlRoot: "#{server_url}/decks"

      amount_to_discard: 0
      amount_discarded: 0
      type: 0

      to_spend: ->
        to_spend = 0
        console.log "calculating to_spend"
        for card in @get('hand')
          do (card) ->
            if cards[gsub(card, ' ', '_')].type == 'money'
              to_spend += cards[gsub(card, ' ', '_')].value
        to_spend

      spend: (value) ->
        console.log 'Deck#spend'
        money_cards = []
        for card in @get('hand')
          if cards[gsub(card, ' ', '_')].type == 'money'
            money_cards.push(card)
        money_cards = _.sortBy money_cards, (i) -> return i
        console.log "current money cards in hand: #{money_cards}"
        new_hand = @get('hand')
        for card in money_cards
          do (card) ->
            if value > 0
              new_hand = new_hand.minus(card)
              console.log new_hand
              value = value - cards[gsub(card, ' ', '_')].value
              console.log value
        if value < 0
          switch value
            when -1
              console.log "returning copper as change"
              new_hand.push 'copper'
            when -2 
              console.log "returning silver as change"
              new_hand.push 'silver'
            when -3 
              console.log "returning gold as change"
              new_hand.push 'gold'
            when -4 
              console.log "returning two silvers as change"
              new_hand.push 'silver'
              new_hand.push 'silver'

        console.log "new hand: #{new_hand}"
        @set('hand', new_hand)
        console.log "saving hand.."
        @save

    class Decks extends Backbone.Collection 
      initialize: ->
        console.log "initializing Decks collection"
        @fetch()

      model: Deck
      url: "#{server_url}/decks"


    console.log "creating new decks and matches collections"
    matches = new Matches
    decks = new Decks
    console.log matches
    console.log decks

    # Views
    # ============================================

    class OpponentsListView extends Backbone.View

      initialize: (@player) ->
        console.log "initializing opponentslistview"
        @setElement $('#templates').find(".opponent-item").clone()
        @render()

      events:
        'click': 'select'

      render: ->
        console.log 'OpponentsListView#render'
        $('#opponents').append(@el)
        @$el.html(@player.username)

      select: ->
        console.log "opponentlistview#select"
        current.attack(@player)



    class ChooseOpponentsView extends Backbone.View

      initialize: ->
        console.log "initializing ChooseOpponentsView"
        @render()

      el: '#choose-opponent'

      render: ->
        for player in current.match.get('players')
          console.log "opponent: #{player.username}"
          view = new OpponentsListView(player)


    class ShopListView extends Backbone.View
      initialize: (@card, @amount) ->
        console.log 'initializing ShopListView'
        @setElement $('#templates').find(".shop-item").clone()
        @render()

      events:
        'click': 'buy'

      render: ->
        console.log 'ShopListView#render'
        $('#shop').append(@el)
        #@$el.find('img')
        @$el.find('.count').html(@amount)
        @$el.find('.price').html(@card.cost)
        @$el.find('.name').html(@card.name)

      buy: ->
        console.log "ShopListView#buy"
        if @card.cost <= current.deck.to_spend() and current.turn
          console.log 'buying card..'
          console.log current.match.get('shop')
          shop = current.match.get('shop')
          shop = shop.minus(@card.name)
          current.match.set('shop', shop)
          curr_cards = current.deck.get('cards')
          curr_cards.push @card.name
          current.deck.set('cards', curr_cards)
          console.log current.match.get('shop')
          console.log current.deck.get('cards')
          @amount--
          @$el.find('.count').html(@amount)
          current.deck.spend(@card.cost)
          changePage '#match',
            transition: 'slide'
          current.match.save()
          current.deck.save()
        else
          console.log 'not enough money'

    class ShopView extends Backbone.View

      initialize: (@card) ->
        console.log 'init ShopView'
        @render()

      el: '#shop'

      render: ->
        console.log 'ShopListView#render'
        shop = {}
        prev = ''
        for card in current.match.get('shop')
          do (card) =>
            if card != prev
              shop[card] = 1
            else
              shop[card] = shop[card] + 1
            prev = card

        for card, amount of shop
          view = new ShopListView(cards[gsub(card, ' ', '_')], amount)

    class CardDetailView extends Backbone.View
      el: 'what'

    class CardListView extends Backbone.View

      initialize: (@card) ->
        console.log 'init CardListView'
        @setElement $('#templates').find(".card").clone()
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
        # @$el.find('.thumb').attr('src', "images/#{gsub(@card.name, ' ', '_')}") # FIXME: this breaks transition from lobby to matchview
        @$el.find('.name').html(@card.name)
        $('#hand').append(@el)

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
        console.log 'touch start'
        console.log e
        # touch.x1 = e.touches[0].pageX
        # touch.y1 = e.touches[0].pageY
        @touch.x1 = e.pageX
        @touch.y1 = e.pageY

      touchmove: (e) ->
        if current.deck.get('actions') > 0 and current.turn
          @dx = e.pageX - @touch.x1
          @dy = e.pageY - @touch.y1
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
            # @discard()
            # current.deck.set('actions', current.deck.get('actions') - 1 ) if @card.type == 'action'
            # current.deck.save()



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
        console.log current.match
        console.log current.deck
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
          @render()

      el: '#match'

      events:
        'click #end_turn': 'end_turn'

      render: ->
        console.log 'rendering MatchView'
        console.log @$el.find('#hand')
        @$el.find('#hand').html('')
        console.log current.deck
        for card in current.deck.get('hand')
          console.log 'some cards'
          view = new CardListView(cards[gsub(card, ' ', '_')]) #TODO take the gsub out and change card names on serverside to use underscore)


        console.log "current actions: #{current.deck.get 'actions'}"

        @$el.find('#actions > .count').html(current.deck.get 'actions')
        @$el.find('#to_spend > .count').html(current.deck.to_spend())
        console.log current.match.get('turn')
        if current.match.get('turn') == current.user.id
          console.log 'its yo turn'
          @$el.find('#end_turn').show()
          @$el.find('#turn').hide()
        else
          console.log 'aint yo turn nigga'
          @$el.find('#end_turn').hide()
          @$el.find('#turn').show()
          console.log current.user
          console.log current.match.get 'players'
          players = current.match.get('players')
          player = _.find players, (player) ->
            player.id == current.match.get('turn')
          console.log player
          @$el.find('#turn > .count').html(player.username)


        # changePage "#match",
        #   transition: "slide"

        # render all the other shit too

      end_turn: ->
        console.log 'ending turn'
        $('#loader').show()
        $('#loader').css('opacity', 1)
        $.post("#{server_url}/end_turn/#{current.match.get('id')}", (data) =>
          console.log data
          console.log 'fetching match data'
          current.match.fetch(
            success: =>
              console.log 'got match data'
              current.deck.fetch(
                success: =>
                  console.log 'got deck data'
                  $('#loader').hide()
                  $('#loader').css('opacity', 0)
                  @render()
              )
            error: =>
              console.log 'error getting match data'
          )
        )

    class MatchListView extends Backbone.View

      initialize: (@match, @deck) ->
        console.log 'init MatchListView'
        console.log "match turn: #{@match.get('turn')}"
        console.log "user id: #{current.user.id}"
        @setElement $('#templates').find(".match-item-view").clone()
        # @setElement templates.LobbyMatchListItem(@match.get('id'), @match.get('players'), @match.get('turn') == current.user.id)
        @render()

      events:
        'click': 'render_match'

      render: ->
        console.log 'MatchListView#render'
        $('#matches').append(@el)
        @$el.on 'click', (e) ->
          e.preventDefault()
          reverse = false
          if $(this).attr('data-transition') == 'reverse'
            reverse = true
          changePage '#match',
            transition: 'slide'
            reverse: reverse

      render_match: ->
        console.log 'rendering match'
        current.match = @match
        current.deck = @deck

        if current.matchview
          console.log 'refresh old matchview'
          current.matchview.render()
        else
          console.log 'create new matchview'
          current.matchview = new MatchView()

        if current.shopview
          current.shopview.render()
        else
          current.shopview = new ShopView()

        
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
        changePage "#home",
          transition: "flip"

      render: ->
        console.log 'LobbyView#render'
        console.log 'fetching decks/matches'
        matches.fetch
          success: =>
            console.log 'got match data, waiting on decks'
            decks.fetch
              success: =>
                $('#loader').css('opacity', 0)
                $('#loader').hide()
                $('#matches').html('')
                console.log 'fetched data for matches and decks'
                console.log 'about to iterate matches in LobbyView#render'
                for match in matches.models
                  console.log 'iterating matches in LobbyView#render'
                  d = decks.where(match_id: match.get('id'))
                  view = new MatchListView(match, d[0])
            
        

      refresh: ->
        @render()



    # Authorization
    # ============================================

    current.lobby = new LobbyView

    facebook_auth = (callback) ->
      console.log 'facebook_auth function'
      window.plugins.childBrowser.showWebPage "#{server_url}/auth/facebook?display=touch"
      console.log 1
      window.plugins.childBrowser.onLocationChange = (loc) ->
        console.log 2
        if /access_token/.test(loc)
          # URL looks like: server.com/access_token/:access_token
          console.log 3
          access_token = unescape(loc).split("access_token/")[1]
          console.log 4
          $.cookie "token", access_token,
            expires: 7300

          console.log 5
          window.plugins.childBrowser.close()
          console.log 6
          callback()

    $.cookie 'token', 'LollakwpnMXj54X6oWwt2g' #TODO: take this out and find out why cookies aren't persisting
    
    if $.cookie("token")?
      # TODO: match token with user on server side, if match, execute the below block
      console.log 'cookie found'
      # TODO: add 'logging in' animation loader
      $('#loader').show()
      $('#loader').css('opacity', 1)
      $.getJSON("#{server_url}/users/99", (user) ->
        current.user = user
        console.log 'instantiating LobbyView'
        current.lobby.render()
        changePage "#lobby",
          transition: "none"
      )
    else
      console.log 'cookie not found'

    $("#facebook-auth").on 'click', ->
      console.log 'clicked facebook'
      facebook_auth ->
        console.log 7
        $.getJSON "#{server_url}/users/1", (user) ->
          console.log 8
          current.user = user
          console.log 'instantiating LobbyView'
          current.lobby.render()
          changePage "#lobby",
            transition: "none"

    $('#login-form').submit (e) ->
      $('#loader').show()
      $('#loader').css('opacity', 1)
      $.post("#{server_url}/signin.json", $(this).serialize(), (user) ->
        console.log '930'
        if user.error?
          alert 'invalid username and/or password'
          $('#loader').hide()
          $('#loader').css('opacity', 0)
        else
          console.log '936'
          $('#loader').hide()
          $('#loader').css('opacity', 0)
          $.cookie 'token', user.token,
            expires: 7300
          console.log $.cookie 'token'
          console.log '942'
          current.user = user

          console.log '945'
          current.lobby.render()

          console.log '948'
          changePage "#lobby",
            transition: "none"

      , 'json')
      e.preventDefault()

    $('#signup-form').submit (e) ->
      $.post("#{server_url}/users.json", $(this).serialize(), (user) ->
        if user.error?
          alert 'error'
        else
          console.log $.cookie 'token',
            expires: 7300
          current.lobby.render()
          changePage '#lobby',
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
      # show loader
      $.post("#{server_url}/matches.json", $(this).serialize(), (data) ->
        if data.errors.length > 0
          # end loader
          alert error for error in data.errors
        else
          # end loader
          alert "match created"
          current.lobby.render()
          changePage "#lobby",
            transition: "none"
      , 'json')
      e.preventDefault()

    $('a').on 'click', (e) ->
      console.log $($(this).attr('href')).length
      if $($(this).attr('href')).length > 0
        e.preventDefault()
        reverse = false
        if $(this).attr('data-transition') == 'reverse'
          reverse = true
        changePage $(this).attr('href'),
          transition: 'slide'
          reverse: reverse













