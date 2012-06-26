# THIS FILE IS BARE.. NO CLOSURE WRAPPER

server_url = "http://mine-games.herokuapp.com"
# server_url = "http://localhost:3000"

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
        $curr.addClass("#{options.transition} out")
        $page.addClass("#{options.transition} in active")
        setTimeout ->
          $curr.removeClass("#{options.transition} out active reverse")
          $page.removeClass("#{options.transition} in reverse")
        , 250

    aOrAn = (word) ->
      console.log word.charAt(0)
      if word.charAt(0) == 'a' || word.charAt(0) == 'e' || word.charAt(0) == 'i' || word.charAt(0) == 'o' || word.charAt(0) == 'u'
        "an"
      else
        "a"

    pushLog = (msg) ->
      log = _.clone current.match.get('log')
      log.push msg
      current.match.set('log', log)
      console.log current.match.get('log')

    pusher = 0
    user_channel = 0
    match_channel = 0

    pusher = new Pusher('8aabfcf0bad1b94dbac3')

    cards = # All card properties are definied client-side.
      stone_pickaxe:
        name: 'stone pickaxe'
        type: 'action'
        cost: 3
        short_desc: 'Draw 1 card from the Mine'
        long_desc: 'long description'
        use: ->
          actions.draw current.match, 'mine'
            number: 1
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Stone Pickaxe</span> and got a <span class='money'>#{newcards[0]}</span>"
              current.match.save()
              current.deck.save()
              current.deck.trigger 'update_to_spend'

      iron_pickaxe:
        name: 'iron pickaxe'
        type: 'action'
        cost: 5
        short_desc: 'Draw 2 cards from the Mine'
        long_desc: 'long description'
        use: ->
          actions.draw current.match, 'mine'
            number: 2
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used an <span class='item action'>Iron Pickaxe</span> and got a <span class='money'>#{newcards[0]}</span> and <span class='money'>#{newcards[1]}</span>"
              current.match.save()
              current.deck.save()
              current.deck.trigger 'update_to_spend'
          
      diamond_pickaxe:
        name: 'diamond pickaxe'
        type: 'action'
        cost: 8
        short_desc: 'Draw 3 cards from the Mine'
        long_desc: 'long description'
        use: ->
          actions.draw current.match, 'mine'
            number: 3
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Diamond Pickaxe</span> and got a <span class='money'>#{newcards[0]}</span>, <span class='money'>#{newcards[1]}</span> and <span class='money'>#{newcards[2]}</span>"
              current.match.save()
              current.deck.save()
              current.deck.trigger 'update_to_spend'

      copper:
        name: 'copper'
        type: 'money'
        value: 1
        short_desc: 'Worth $1 at the Shop'
        long_desc: 'long description'
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      silver:
        name: 'silver'
        type: 'money'
        value: 2
        short_desc: 'Worth $2 at the Shop'
        long_desc: 'long description'
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      gold:
        name: 'gold'
        type: 'money'
        value: 3
        short_desc: 'Worth $3 at the Shop'
        long_desc: 'long description'
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      diamond:
        name: 'diamond'
        type: 'money'
        value: 5
        short_desc: 'Worth $5 at the Shop'
        long_desc: 'long description'
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      coal:
        name: 'coal'
        type: 'coal'
        value: 0
        short_desc: 'Worthless'
        long_desc: 'long description'
        use: ->
          console.log 'copper used'
          actions.discard
            number: 2

      tnt:
        name: 'tnt'
        type: 'action'
        cost: 1
        short_desc: "Destroy 2 items from an opponent's hand"
        long_desc: 'long description'
        use: ->
          console.log "tnt#use"
          current.attack = (player) ->
            console.log "current#attack"
            console.log "chosen opponent:"
            console.log player
            # create new deck model from selected opponent
            opponents_decks = new Decks()
            opponents_decks.url = "#{server_url}/decks_by_user/#{player.id}"
            console.log "fetching decks"
            opponents_decks.fetch
              success: ->
                console.log 'fetch success'
                target_deck = new Deck
                console.log "opponents deck:"
                console.log  opponents_decks.where(match_id: current.match.get('id'))[0]
                target_deck.set opponents_decks.where(match_id: current.match.get('id'))[0]

                reaction = false
                for card in target_deck.get('hand')
                  if cards[card].type == 'reaction'
                    reaction = true
                    break

                if reaction == false
                  actions.trash target_deck, 'hand',
                    random: true
                    number: 2
                    callback: (newcards) ->
                      console.log 'calling callback'
                      pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>TNT</span> on #{player.username} and trashed a <span class='money'>#{cards[newcards[0]].name}</span> and <span class='money'>#{cards[newcards[1]].name}</span>"
                      current.match.save()
                      current.deck.save()
                      target_deck.save()
                      current.deck.trigger 'update_to_spend'
                else
                  alert "#{player.username} used a fuckn' reaction card and blocked yo attack nigga!"



            if current.match.get('players').length > 1
              changePage '#match',
                transition: 'slide'

          if current.match.get('players').length > 1
            current.opponentsview = new ChooseOpponentsView()
            changePage '#choose-opponents',
              transition: 'slideup'
          else
            current.attack(current.match.get('players')[0])

          #do something

      minecart:
        name: 'minecart'
        type: 'action'
        cost: 5
        short_desc: '+1 Action, +1 Card'
        long_desc: 'long description'
        use: ->
          current.deck.set('actions', current.deck.get('actions')+1)
          actions.draw current.deck, 'cards',
            number: 1
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Minecart</span> and got a <span class='money'>#{cards[newcards[0]].name}</span>"
              current.match.save()
              current.deck.save()
              current.deck.trigger 'update_to_spend'
              #TODO: change card type dyanmically

      mule:
        name: 'mule'
        type: 'action'
        cost: 5
        short_desc: '+3 Cards'
        long_desc: 'long description'
        use: ->
          actions.draw current.deck, 'cards',
            number: 3
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Minecart</span> and got a <span class='money'>#{cards[newcards[0]].name}</span>, <span class='money'>#{newcards[1]}</span> and <span class='money'>#{newcards[2]}</span>"
              current.match.save()
              current.deck.save()
              current.deck.trigger 'update_to_spend'

      headlamp:
        name: 'headlamp'
        type: 'action'
        cost: 4
        short_desc: 'Choose 2 cards from your inventory before you draw your next hand.'
        long_desc: 'long description'

      gopher:
        name: 'gopher'
        type: 'action'
        cost: 4
        short_desc: "Steals a random card from an Opponent's hand"
        long_desc: 'long description'
        use: ->
          console.log "gopher#use"
          current.attack = (player) ->
            console.log "current#attack"
            console.log "chosen opponent:"
            console.log player
            # create new deck model from selected opponent
            opponents_decks = new Decks()
            opponents_decks.url = "#{server_url}/decks_by_user/#{player.id}"
            console.log "fetching decks"
            opponents_decks.fetch
              success: ->
                console.log 'fetch success'
                target_deck = new Deck
                console.log "opponents deck:"
                console.log  opponents_decks.where(match_id: current.match.get('id'))[0]
                target_deck.set opponents_decks.where(match_id: current.match.get('id'))[0]
                actions.draw target_deck, 'hand',
                  random: true
                  number: 1
                  callback: (newcards) ->
                    console.log 'calling callback'
                    pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Gopher</span> on #{player.username} and got a <span class='money'>#{cards[newcards[0]].name}</span>"
                    current.match.save()
                    current.deck.save()
                    target_deck.save()
                    current.deck.trigger 'update_to_spend'



            if current.match.get('players').length > 1
              changePage '#match',
                transition: 'slide'

          if current.match.get('players').length > 1
            current.opponentsview = new ChooseOpponentsView()
            changePage '#choose-opponents',
              transition: 'slideup'
          else
            current.attack(current.match.get('players')[0])

      magnet:
        name: 'magnet'
        type: 'action'
        cost: 5
        short_desc: 'Steal a tresure card from an Opponent'
        long_desc: 'long description'

      alchemy:
        name: 'alchemy'
        type: 'action'
        cost: 6
        short_desc: 'Turns 2 coals into a Diamond'
        long_desc: 'long description'

      shield:
        name: 'shield'
        type: 'reaction'
        cost: 1
        short_desc: 'Blocks an incoming attack'
        long_desc: "Prevents a single attack from affecting you. This card is then returned to your inventory after it's been used."

    actions = # Actions are decoupled from cards.

      draw: (model, attribute, options) ->
        # default options
        console.log "actions#draw"
        optoins.number = 1 if typeof options.number == 'undefined'
        optoins.random = false if typeof options.number == 'undefined'
        newcards = []

        console.log " - Iterating.."
        source = _.clone model.get(attribute)
        hand = _.clone current.deck.get('hand')

        for i in [1..options.number]
          console.log " - Check for options.random"
          if options.random == true
            console.log " - - random: true"
            r = Math.floor(Math.floor(Math.random()*(source.length-1)))
            newcard = source[r]
            source[r..r] = []
          else
            console.log " - - random: false"
            newcard = source[0]
            source[0..0] = []

          console.log " - newcard: #{newcard}"
          console.log " - Pushing new card"
          hand.push newcard
          newcards.push newcard

          console.log " - Setting model: #{attribute}"
          model.set(attribute, source)
          console.log " - Setting hand"
          current.deck.set('hand', hand)

          console.log " - Instantiating new CardListView"
          view = new CardListView(cards[newcard])

        console.log " - Firing callback"
        options.callback(newcards) if typeof options.callback == 'function'

      discard: (options, cb) ->
        # insert view that tells user to discard cards
        # add icon to click on each card that lets user discard that card
        $('.discard').show()
        console.log options.number
        current.deck.set
          amount_to_discard: options.number
          amount_discarded: 0
          discard_type: options.type

      trash: (model, attribute, options) ->
        console.log "actions#trash"
        optoins.number = 1 if typeof options.number == 'undefined'
        optoins.random = false if typeof options.number == 'undefined'
        newcards = []

        console.log " - Iterating.."
        source = _.clone model.get(attribute)

        for i in [1..options.number]
          console.log " - Check for options.random"
          if options.random == true
            console.log " - - random: true"
            r = Math.floor(Math.floor(Math.random()*(source.length-1)))
            newcard = source[r]
            source[r..r] = []
          else
            console.log " - - random: false"
            newcard = source[0]
            source[0..0] = []

          console.log " - newcard: #{newcard}"
          console.log " - Pushing new card"
          newcards.push newcard

          console.log " - Setting model: #{attribute}"
          model.set(attribute, source)

        console.log " - Firing callback"
        options.callback(newcards) if typeof options.callback == 'function'

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
          console.log "match changed"

    class Matches extends Backbone.Collection
      initialize: ->
        @fetch()
        console.log 'initializing Matches collection'

      model: Match
      url: "#{server_url}/matches"

    class Deck extends Backbone.Model
      initialize: ->
        # @on 'change', =>
        #   console.log "deck changed"
        #   $('#to_spend > .count').html(current.deck.to_spend())
          # @save()

      urlRoot: "#{server_url}/decks"

      amount_to_discard: 0
      amount_discarded: 0
      type: 0

      to_spend: ->
        console.log "Deck#to_spend"
        to_spend = 0
        console.log " - Iterating @get('hand').."
        console.log @get('hand')
        for card in @get('hand')
          console.log ' - - Checking type'
          console.log " - - Card: #{cards[card].name}"
          if cards[card].type == 'money'
            console.log ' - - - Type: money, getting value'
            to_spend += cards[card].value
        to_spend

      total_points: ->
        console.log "Deck#total_points"
        total_points = 0
        console.log " - Iterating @get('cards').."
        console.log @get('cards')
        for card in @get('cards')
          console.log ' - - Checking type'
          console.log " - - Card: #{cards[card].name}"
          if cards[card].type == 'money'
            console.log ' - - - Type: money, getting value'
            total_points += cards[card].value
        total_points + @to_spend()

      spend: (value) ->
        console.log 'Deck#spend'
        money_cards = []
        for card in @get('hand')
          if cards[card].type == 'money'
            money_cards.push(card)
        money_cards = _.sortBy money_cards, (i) -> return i
        console.log "current money cards in hand: #{money_cards}"
        new_hand = @get('hand')
        for card in money_cards
          if value > 0
            new_hand = new_hand.minus(card)
            console.log new_hand
            value = value - cards[card].value
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
        console.log @card
        $('#shop').find('#shopContainer').append(@el)
        #@$el.find('img')
        @$el.find('.count').html(@amount)
        @$el.find('.price').html(@card.cost)
        @$el.find('.name').html(@card.name)

      buy: ->
        console.log "ShopListView#buy"
        if @card.cost <= current.deck.to_spend() and current.turn
          console.log 'buying card..'
          console.log current.match.get('shop')
          shop = _.clone current.match.get('shop')
          shop = shop.minus(gsub(@card.name, ' ', '_'))
          current.match.set('shop', shop)
          curr_cards = _.clone current.deck.get('cards')
          curr_cards.push gsub(@card.name, ' ', '_')
          current.deck.set('cards', curr_cards)
          console.log current.match.get('shop')
          console.log current.deck.get('cards')
          @amount--
          @$el.find('.count').html(@amount)
          current.deck.spend(@card.cost)
          pushLog "<span class='name'>#{current.user.username}</span> bought #{aOrAn(@card.name)} <span class='item action'>#{@card.name}</span>"
          changePage '#match',
            transition: 'slide'
          current.match.save()
          current.deck.save()
          current.deck.trigger 'update_to_spend'
        else
          console.log 'not enough money'
          alert "not enough money!"

    class ShopView extends Backbone.View

      initialize: (@card) ->
        console.log 'init ShopView'
        # TODO: add listener for shop change
        current.match.on 'change:shop', =>
          @render()
        @render()

      el: '#shop'

      render: ->
        console.log 'ShopView#render'
        shop = {}
        prev = ''
        console.log current.match.get('shop')
        for card in current.match.get('shop')
          if card != prev
            shop[card] = 1
          else
            shop[card] = shop[card] + 1
          prev = card

        @$el.find('#shopContainer').html('')
        for card, amount of shop
          console.log cards[card]
          view = new ShopListView(cards[card], amount)

    class CardDetailView extends Backbone.View

      initialize: ->

      el: '#card-detail'

      render: (card) ->
        @$el.find('#card-detail-name').html(card.name)
        @$el.find('#card-detail-desc').html(card.long_desc)

    class CardListView extends Backbone.View

      initialize: (@card) ->
        console.log 'CardListView#initialize'
        console.log " - #{@card.name}"
        console.log " - Cloning .card template"
        @setElement $('#templates').find(".card").clone()
        @render()

      events:
        'touchstart': 'touchstart'
        'touchmove': 'touchmove'
        'swiperight': 'swiperight'
        'touchend': 'touchend'
        'touchcancel': 'touchend'
        'click .discard': 'discard'
        # 'click .trash': 'trash'

      render: ->
        console.log "CardListView#render"
        # @$el.find('.thumb').attr('src', "images/#{gsub(@card.name, ' ', '_')}") # FIXME: this breaks transition from lobby to matchview
        console.log " - Setting DOM name & desc"
        @$el.find('.name').html(@card.name)
        @$el.find('.desc').html(@card.short_desc)
        console.log " - Appending to #hand"
        $('#hand').append(@el)

      w: 55
      touch:
        x1: 0
        y1: 0
      swiping: false
      dragging: false
      selected: false
      use: false
      clicked: false
      dx: 0
      dy: 0

      render_card: ->
        console.log 'CardListView#render_card'
        current.carddetailview.render(@card)
        changePage '#card-detail',
          transition: 'flip'

      touchstart: (e) ->
        @clicked = true
        setTimeout =>
          @clicked = false
        , 650
        console.log 'touch start'
        # touch.x1 = e.touches[0].pageX
        # touch.y1 = e.touches[0].pageY
        @touch.x1 = e.pageX
        @touch.y1 = e.pageY

      touchmove: (e) ->
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
        console.log "CardListView#touchend"
        console.log "dy: #{@dy}"
        console.log 'touch end'
        @$el.removeClass("drag green").css "-webkit-transform", "translate3d(0,0,0)"
        if @use and @dx >= @w - 1
          @dx = 0
          if current.deck.get('actions') > 0 and current.turn
            console.log ' - Using card'
            current.deck.set('actions', current.deck.get('actions') - 1 ) if @card.type == 'action'
            @discard()
            @card.use()
          else
            if not current.turn
              alert "It's not your turn!"
            else
              if current.deck.get('actions') < 1
                alert "You have no actions left!"
        else
          if @clicked and Math.abs(@dy) < 6
            @clicked = false
            console.log 'clicked'
            @render_card()


        @dx = @dy = 0



      discard: () ->
        console.log "CardListView#discard"
        console.log " - removing from DOM"
        @remove()
        console.log " - Removing card from hand, adding to deck.cards"
        nh = _.clone current.deck.get('hand')
        nh = nh.minus(gsub(@card.name, ' ', '_'))
        current.deck.set('hand', nh)
        nd = _.clone current.deck.get('cards')
        nd.push(gsub(@card.name, ' ', '_'))
        current.deck.set('cards', nd)
        # current.deck.set('amount_discarded', current.deck.get('amount_discarded') + 1)
        # if current.deck.get('amount_discarded') == current.deck.get('amount_to_discard')
        #   console.log 'discard limit reached'
        #   $('.discard').hide()

    class MatchView extends Backbone.View

      initialize: () ->
        console.log 'MatchView#initialize'

        console.log " - instantiating CardDetailView"
        current.carddetailview = new CardDetailView

        console.log " - Binding pusher channels"
        match_channel.bind 'update', (data) ->
          console.log "match_channel:update"
          current.match.fetch() if not current.turn

        user_channel.bind 'update_deck', (data) =>
          console.log "user_channel:update_deck"
          @refresh()

        match_channel.bind 'change_turn', (data) =>
          console.log "match_channel:change_turn"
          @refresh()

        match_channel.bind 'update_score', (data) =>
          console.log "match_channel:update_score"
          @refresh()

        @refresh()

        console.log " - Binding backbone events"

        current.match.on 'change:log', =>
          console.log "current.match change:log"
          @$el.find('#log').html(_.last(current.match.get('log')))

        current.match.on 'change:mine', =>
          console.log "current.match change:mine"
          @$el.find('#mine > .count').html(current.match.get('mine').length)

        current.deck.on 'change:actions', =>
          console.log "current.deck change:actions"
          @$el.find('#actions > .count').html(current.deck.get 'actions')

        current.deck.on 'update_to_spend', =>
          console.log "event: update_to_spend"
          @$el.find('#to_spend > .count').html(current.deck.to_spend())
          @render()

      el: '#match'

      events:
        'click #end_turn': 'end_turn'

      render: ->
        console.log 'MatchView#render'
        console.log current.match
        console.log ' - Updating log DOM'
        @$el.find('#log').html(_.last(current.match.get('log')))
        console.log ' - clearing #hand'
        @$el.find('#hand').html('')
        console.log " - Iterating current.deck.get('hand')"
        console.log current.deck.get('hand')
        for card in current.deck.get('hand')
          console.log " - - Iterating.."
          view = new CardListView(cards[card])

        console.log " - Updating actions DOM"
        @$el.find('#actions > .count').html(current.deck.get 'actions')
        console.log " - Updating mine DOM"
        @$el.find('#mine > .count').html(current.match.get('mine').length)
        console.log " - Updating to_spend DOM"
        @$el.find('#to_spend > .count').html(current.deck.to_spend())
        console.log " - Updating turn DOM"
        if current.turn
          console.log " - - current.turn: true"
          @$el.find('#end_turn').show()
          @$el.find('#turn').hide()
        else
          console.log " - - current.turn: false"
          @$el.find('#end_turn').hide()
          @$el.find('#turn').show()
          players = current.match.get('players')
          player = _.find players, (player) ->
            player.id == current.match.get('turn')
          @$el.find('#turn > .count').html(player.username)
        console.log " - Updating player score DOM"
        # TODO: add string truncation for names
        # TODO: DRY this switch statement up
        switch current.match.get('players').length
          when 1
            console.log " - - Adding current.user"
            $("#two-players").show().html('')
            $player = $('#templates').find(".player").clone()
            $player.find('.name').html(current.user.username)
            $player.find('.score').html(current.deck.total_points())
            $("#two-players").append($player)
            console.log " - - Iterating match.players"
            for player in current.match.get('players')
              console.log " - - - Iterating.."
              console.log " - - - player:"
              console.log player
              $player = $('#templates').find(".player").clone()
              $player.find('.name').html(player.username)
              # TODO: add this as a global variable
              players_decks = new Decks()
              players_decks.url = "#{server_url}/decks_by_user/#{player.id}"
              console.log " - - - Fetching decks"
              players_decks.fetch
                success: ->
                  console.log ' - - - - Fetch success'
                  console.log " - - - - deck:"
                  console.log  players_decks.where(match_id: current.match.get('id'))[0]
                  deck = players_decks.where(match_id: current.match.get('id'))[0]
                  $player.find('.score').html(deck.total_points())
              $("#two-players").append($player)
          when 2
            console.log " - - Adding current.user"
            $("#three-players").html('')
            $player = $('#templates').find(".player").clone()
            $player.find('.name').html(current.user.username)
            $player.find('.score').html(current.deck.total_points())
            $("#three-players").append($player)
            console.log " - - Iterating match.players"
            for player in current.match.get('players')
              console.log " - - - Iterating.."
              console.log " - - - player:"
              console.log player
              $player = $('#templates').find(".player").clone()
              $player.find('.name').html(player.username)
              players_decks = new Decks()
              players_decks.url = "#{server_url}/decks_by_user/#{player.id}"
              console.log " - - - Fetching decks"
              players_decks.fetch
                success: ->
                  console.log ' - - - - Fetch success'
                  console.log " - - - - deck:"
                  console.log  players_decks.where(match_id: current.match.get('id'))[0]
                  deck = players_decks.where(match_id: current.match.get('id'))[0]
                  $player.find('.score').html(deck.total_points())
              $("#three-players").append($player)
            # three-players
          when 3
            console.log " - - Adding current.user"
            $("#four-players").html('')
            $player = $('#templates').find(".player").clone()
            $player.find('.name').html(current.user.username)
            $player.find('.score').html(current.deck.total_points())
            $("#four-players").append($player)
            console.log " - - Iterating match.players"
            for player in current.match.get('players')
              console.log " - - - Iterating.."
              console.log " - - - player:"
              console.log player
              $player = $('#templates').find(".player").clone()
              $player.find('.name').html(player.username)
              players_decks = new Decks()
              players_decks.url = "#{server_url}/decks_by_user/#{player.id}"
              console.log " - - - Fetching decks"
              players_decks.fetch
                success: ->
                  console.log ' - - - - Fetch success'
                  console.log " - - - - deck:"
                  console.log  players_decks.where(match_id: current.match.get('id'))[0]
                  deck = players_decks.where(match_id: current.match.get('id'))[0]
                  $player.find('.score').html(deck.total_points())
              $("#four-players").append($player)


        if @$el.css('display') == 'none'
          changePage '#match',
            transition: 'slide'

      end_turn: ->
        console.log 'MatchView#end_turn'
        $('#loader').show()
        $('#loader').css('opacity', 1)
        $('#loader').find('#loading-text').html('Submitting turn...')
        current.match.set('last_move', new Date().toString().split(' ').slice(0,5).join(' '))
        current.match.save {},
          success: =>
            $.post "#{server_url}/end_turn/#{current.match.get('id')}", (data) =>
              console.log data
              console.log 'fetching match data'
              # @refresh()

      refresh: ->
        # TODO: wait until all models have been fetched before changing page.
        console.log "MatchView#refresh"
        console.log " - fetching current.match"
        current.match.fetch
          success: =>
            console.log " - - current.match.fetch: Success"
            console.log " - - Fetching current.deck"
            current.deck.fetch
              success: =>
                console.log " - - - current.deck.fetch: Success"
                console.log " - - - Hiding #loader"
                $('#loader').hide()
                $('#loader').css('opacity', 0)
                console.log " - - - Setting current.turn"
                current.turn = if current.match.get('turn') == current.user.id then true else false
                console.log " - - - current.turn: #{current.turn}"
                console.log " - - - rendering.."
                @render()

          error: =>
            alert 'error getting match data'

    class MatchListView extends Backbone.View

      initialize: (@match, @deck) ->
        console.log 'init MatchListView'
        @setElement $('#templates').find(".match-item-view").clone()
        @render()

      events:
        'click': 'render_match'

      render: ->
        console.log 'MatchListView#render'
        if @match.get('turn') == current.user.id
          $('#matches').find('#your-turn').append(@el)
        else
          $('#matches').find('#their-turn').append(@el)
        @$el.find('.head').html("Mining with #{player.username for player in @match.get('players')}")
        if "#{@match.get('last_move')}" == "null"
          # think of something to do here
          @$el.find('.subhead').html("No moves yet!")
        else
          @$el.find('.subhead').html("Last move #{$.timeago @match.get('last_move')}")
        @$el.on 'click', (e) ->
          e.preventDefault()

      render_match: ->
        console.log 'MatchListView#render_match'
        current.match = @match
        current.deck = @deck
        match_channel = pusher.subscribe("#{current.match.get('id')}")


        console.log "checking if MatchView instance exists."
        if current.matchview
          console.log 'MatchView instance exists. Refreshing'
          current.matchview.refresh()
        else
          console.log 'MatchView instance doesnt exist. Creating new matchview'
          current.matchview = new MatchView

        if current.shopview
          current.shopview.render()
        else
          current.shopview = new ShopView

    class LobbyView extends Backbone.View

      initialize: () ->
        console.log 'init LobbyView'
        user_channel.bind('new_match', (data) =>
          alert "You've been challenged to a new game!"
          @render()
        )
        @render()

      el: '#lobby'

      events:
        'click #refresh_lobby': 'render'
        'click .logout': 'logout'

      logout: ->
        console.log "LobbyView#logout"
        $.cookie('token', null)
        changePage "#home",
          transition: "flip"

      render: ->
        console.log 'LobbyView#render'
        console.log 'fetching decks/matches'
        $('#loader').find('#loading-text').html('Finding matches...')
        matches.fetch
          success: =>
            console.log 'got match data, waiting on decks'
            decks.fetch
              success: =>
                $('#loader').css('opacity', 0)
                $('#loader').hide()
                $('#matches').find('#your-turn').html('')
                $('#matches').find('#their-turn').html('')
                $('#matches').find('#game-over').html('')
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

    set_user = ->
      $.getJSON "#{server_url}/users/1", (user) -> # users/:id param is arbitrary.
        if user == null
          alert "Sorry, there was an error. Please relink your account with facebook"
          $('#loader').css('opacity', 0)
          $('#loader').hide()
          facebook_auth set_user
        else
          current.user = user
          user_channel = pusher.subscribe("#{current.user.id}")
          console.log 'instantiating LobbyView'
          if current.lobby
            current.lobby.render()
          else
            current.lobby = new LobbyView

          changePage "#lobby",
            transition: "none"


    # $.cookie 'token', 'LollakwpnMXj54X6oWwt2g'
    
    # TODO: add a timeout
    if $.cookie("token")?
      # TODO: match token with user on server side, if match, execute the below block
      console.log 'cookie found'
      console.log $.cookie('token')
      # TODO: add 'logging in' animation loader
      $('#loader').show()
      $('#loader').css('opacity', 1)
      $('#loader').find('#loading-text').html('Logging in...')
      set_user()
    else
      console.log 'cookie not found'

    $("#facebook-auth").on 'click', ->
      console.log 'clicked facebook'
      facebook_auth set_user

    $('#login-form').submit (e) ->
      $('#loader').show()
      $('#loader').css('opacity', 1)
      $.post("#{server_url}/signin.json", $(this).serialize(), (user) ->
        if user.error?
          alert 'invalid username and/or password'
          $('#loader').hide()
          $('#loader').css('opacity', 0)
        else
          $('#loader').hide()
          $('#loader').css('opacity', 0)
          $.cookie 'token', user.token,
            expires: 7300
          console.log $.cookie 'token'
          current.user = user
          user_channel = pusher.subscribe("#{current.user.id}")

          if current.lobby
            current.lobby.render()
          else
            current.lobby = new LobbyView
            current.lobby.render()            

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

    $('#back-to-lobby').on 'click', ->
      current.lobby.render()

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
      if $($(this).attr('href')).length > 0
        e.preventDefault()
        reverse = false
        if $(this).attr('data-transition') == 'reverse'
          reverse = true
        changePage $(this).attr('href'),
          transition: 'slide'
          reverse: reverse












