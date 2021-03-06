# THIS FILE IS BARE.. NO CLOSURE WRAPPER

server_url = "http://mine-games.herokuapp.com"
# server_url = "http://localhost:3000"

# preventBehavior = (e) ->
#   e.preventDefault()
# document.addEventListener "touchmove", preventBehavior, false

onBodyLoad = ->
  document.addEventListener "deviceready", onDeviceReady, false

onDeviceReady = ->

  # Facebook plugin setup
  try
    FB.init
      appId: "247405602033317"
      nativeInterface: CDV.FB
      useCachedDialogs: false
      # status: true
  catch e
    alert e

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
      $('.active').addClass('curr')
      $curr = $('.curr')
      $page = $(page)
      # TODO: find a less hacky solution
      if page == '#match'
        $('#match').find('#hand-container').css('height', '267px')

      if page == '#lobby'
        $('#lobby').find('#matches-container').css('height', '330px')

      if options?
        if options.reverse == true
          $curr.addClass('reverse')
          $page.addClass('reverse')

        $page.css("z-index", -10)

        $curr.addClass("#{options.transition} out")
        $page.addClass("#{options.transition} in active")

        $page.css("z-index", "")

        $curr.one 'webkitAnimationEnd', ->
          $curr.removeClass("#{options.transition} out active reverse curr")

        $page.one 'webkitAnimationEnd', ->
          $page.removeClass("#{options.transition} in reverse")

          if page == '#match'
            $('#lobby').find('#matches-container').css('height', '0')

          if page == '#lobby'
            $('#match').find('#hand-container').css('height', '0')

      else
        $curr.removeClass 'active reverse curr'
        $page.addClass 'active'
        $page.removeClass 'reverse'
        if page == '#match'
          $('#lobby').find('#matches-container').css('height', '0')

        if page == '#lobby'
          $('#match').find('#hand-container').css('height', '0')

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

    user_channel = 0
    match_channel = 0

    pusher = new Pusher('8aabfcf0bad1b94dbac3')

    cards = # All card properties are definied client-side.
      stone_pickaxe:
        name: 'stone pickaxe'
        type: 'action'
        cost: 1
        short_desc: 'Draw 1 card from the Mine'
        long_desc: 'long description'
        use: ->
          actions.draw current.match, 'mine'
            number: 1
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Stone Pickaxe</span> and drew a <span class='item money'>#{newcards[0]}</span> from the <span class='mine'>mine</span>"
              current.match.save()
              current.deck.save()

      iron_pickaxe:
        name: 'iron pickaxe'
        type: 'action'
        cost: 3
        short_desc: 'Draw 2 cards from the Mine'
        long_desc: 'long description'
        use: ->
          actions.draw current.match, 'mine'
            number: 2
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used an <span class='item action'>Iron Pickaxe</span> and drew a <span class='item money'>#{newcards[0]}</span> and <span class='item money'>#{newcards[1]}</span> from the <span class='mine'>mine</span>"
              current.match.save()
              current.deck.save()
          
      diamond_pickaxe:
        name: 'diamond pickaxe'
        type: 'action'
        cost: 6
        short_desc: 'Draw 3 cards from the Mine'
        long_desc: 'long description'
        use: ->
          actions.draw current.match, 'mine'
            number: 3
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Diamond Pickaxe</span> and drew a <span class='item money'>#{newcards[0]}</span>, <span class='item money'>#{newcards[1]}</span> and <span class='item money'>#{newcards[2]}</span> from the <span class='mine'>mine</span>"
              current.match.save()
              current.deck.save()

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
        type: 'attack'
        cost: 5
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
                      pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item attack'>TNT</span> and destroyed a <span class='item #{cards[newcards[0]].type}'>#{cards[newcards[0]].name}</span> and <span class='item #{cards[newcards[1]].type}'>#{cards[newcards[1]].name}</span> from <span class='name'>#{player.username}'s</span> hand."
                      current.match.save()
                      current.deck.save()
                      target_deck.save()
                else
                  alert "#{player.username} used a reaction card and blocked your attack!"
                  pushLog "<span class='name'>#{player.username}</span> blocked <span class='name'>#{current.user.username}'s</span> <span class='item attack'>TNT</span> with a <span class='item'>Shield</span>."



            if current.match.get('players').length > 2
              changePage '#match',
                transition: 'slide'

          if current.match.get('players').length > 2
            current.opponentsview = new ChooseOpponentsView()
            changePage '#choose-opponents',
              transition: 'slideup'
          else
            current.attack(_.find current.match.get('players'), (player) -> player.id isnt current.user.id)

          #do something

      minecart:
        name: 'minecart'
        type: 'action'
        cost: 5
        short_desc: '+2 Action, +1 Card'
        long_desc: 'long description'
        use: ->
          current.deck.set('actions', current.deck.get('actions')+2)
          actions.draw current.deck, 'cards',
            number: 1
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Minecart</span> and drew a <span class='item #{cards[newcards[0]].type}'>#{cards[newcards[0]].name}</span> from their deck."
              current.match.save()
              current.deck.save()
              #TODO: change card type dyanmically

      mule:
        name: 'mule'
        type: 'action'
        cost: 4
        short_desc: '+3 Cards'
        long_desc: 'long description'
        use: ->
          actions.draw current.deck, 'cards',
            number: 3
            random: false
            callback: (newcards) ->
              console.log 'calling callback'
              pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Minecart</span> and drew a <span class='item #{cards[newcards[0]].type}'>#{cards[newcards[0]].name}</span>, <span class='item #{cards[newcards[1]].type}'>#{newcards[1]}</span> and <span class='item #{cards[newcards[2]].type}'>#{newcards[2]}</span> from their deck."
              current.match.save()
              current.deck.save()

      headlamp:
        name: 'headlamp'
        type: 'action'
        cost: 99
        short_desc: 'Draw two additional cards next hand.'
        long_desc: 'long description'

      gopher:
        name: 'gopher'
        type: 'attack'
        cost: 5
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
                    pushLog "<span class='name'>#{current.user.username}</span> used a <span class='item action'>Gopher</span> and stole a <span class='item #{cards[newcards[0]].type}'>#{cards[newcards[0]].name}</span> from <span class='name'>#{player.username}'s</span> hand."
                    current.match.save()
                    current.deck.save()
                    target_deck.save()



            if current.match.get('players').length > 2
              changePage '#match',
                transition: 'slide'

          if current.match.get('players').length > 2
            current.opponentsview = new ChooseOpponentsView()
            changePage '#choose-opponents',
              transition: 'slideup'
          else
            current.attack(_.find current.match.get('players'), (player) -> player.id isnt current.user.id)

      magnet:
        name: 'magnet'
        type: 'action'
        cost: 99
        short_desc: 'Steal a tresure card from an Opponent'
        long_desc: 'long description'

      alchemy:
        name: 'alchemy'
        type: 'action'
        cost: 4
        short_desc: 'Turns 2 coals into a Diamond'
        long_desc: 'long description'
        use: ->
          source = _.clone current.deck.get 'hand'
          coals = _.filter source, (card) ->
            card == 'coal'
          source = _.reject source, (card) ->
            card == 'coal'
          if coals.length >= 2
            source.push 'diamond'
            current.deck.set('hand', source)
            pushLog "<span class='name'>#{current.user.username}</span> used <span class='item action'>Alchemy</span> and synthesized 2 <span class='money'>Coals</span> into a <span class='money'>Diamond</span>"
            current.match.save()
            current.deck.save()
          else
            current.deck.set('actions', current.deck.get('actions') + 1 )
            new_hand = _.clone current.deck.get 'hand'
            new_hand.push 'alchemy'
            current.deck.set 'hand', new_hand
            alert 'You need at least two coals in hand to make use this card!'

      canary:
        name: 'canary'
        type: 'reaction'
        cost: 1
        short_desc: 'Absorbs an incoming attack'
        long_desc: "Prevents a single attack from affecting you. This card gets trashed after it's been used."

      scrip:
        name: 'scrip'
        type: 'action'
        cost: 3
        short_desc: '+$2'
        long_desc: "When used this card gives you an extra $2 to spend at the shop this turn. It gets returned to your deck when used."
        use: ->
          current.deck.set('extra_spend', current.deck.get('extra_spend') + 2)
          pushLog "<span class='name'>#{current.user.username}</span> used <span class='item action'>Scrip</span> and got an extra <span class='money'>2$</span> to spend."
          current.deck.save()

      trash_four:
        name: 'TBD'
        type: 'action'
        cost: 92
        short_desc: 'Trash up to four cards from your hand'
        long_desc: "Trash up to four cards from your hand."

      play_twice:
        name: 'TBD'
        type: 'action'
        cost: 94
        short_desc: 'Play a card from your hand twice.'
        long_desc: "Choose a card from your hand and it will be played twice, costing no additional actions."

      action_and_coal:
        name: 'TBD'
        type: 'action'
        cost: 94
        short_desc: '+1 action, +1 coal to opponents'
        long_desc: "Gain an action while giving a coal to all opponents."

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


        model.set(attribute, source)
        current.deck.set('hand', hand)

        console.log " - Firing callback"
        options.callback(newcards) if typeof options.callback == 'function'

      user_discard: (options, cb) ->
        # insert view that tells user to discard cards
        # add icon to click on each card that lets user discard that card
        $('.discard').show()
        console.log options.number
        current.deck.set
          amount_to_discard: options.number
          amount_discarded: 0
          discard_type: options.type

      user_trash: (options, cb) ->
        # insert view that tells user to discard cards
        # add icon to click on each card that lets user discard that card
        $('.trash').show()
        current.deck.set
          amount_to_trash: options.number
          amount_trashed: 0
          trash_type: options.type

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

    collections = {}

    views = {}


    # Models / Collections
    # ============================================

    class Match extends Backbone.Model
      initialize: ->
        console.log "initializing Match model"
        @on 'change', =>
          console.log "match changed"

    class Matches extends Backbone.Collection
      initialize: ->
        console.log 'initializing Matches collection'

      model: Match
      url: "#{server_url}/matches"

    class Deck extends Backbone.Model
      initialize: ->
        console.log "initializing deck model"
        @on 'change', =>
          console.log "deck changed"
        #   $('#to_spend > .count').html(current.deck.to_spend())
          # @save()

      urlRoot: "#{server_url}/decks"

      amount_to_discard: 0
      amount_discarded: 0
      type: 0

      to_spend: ->
        console.log "Deck#to_spend"
        to_spend = @get('extra_spend')
        for card in @get('hand')
          if cards[card].type == 'money'
            to_spend += cards[card].value
        to_spend

      total_points: ->
        total_points = 0
        for card in @get('cards')
          if cards[card].type == 'money'
            total_points += cards[card].value
        total_points + @to_spend()

      spend: (value) ->
        console.log 'Deck#spend'
        value = value - @get('extra_spend')
        @set('extra_spend', 0)
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

      model: Deck
      url: "#{server_url}/decks"


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
          view = new OpponentsListView(player) unless player.id == current.user.id


    # Shop

    class ShopListView extends Backbone.View
      initialize: (@card, @amount) ->
        console.log 'initializing ShopListView'
        @setElement $('#templates').find(".shop-item").clone()
        @render()

      events:
        'tap': 'buy'

      render: ->
        console.log 'ShopListView#render'
        console.log @card
        $('#shop').find('#shopContainer').append(@el)
        #@$el.find('img')
        @$el.find('.count').html(@amount)
        @$el.find('.price').html(@card.cost)
        @$el.find('img').attr('src', "images/cards/#{gsub(@card.name, ' ', '_')}_thumb.png")

      buy: ->
        console.log "ShopListView#buy"
        if @card.cost <= current.deck.to_spend()
          if current.turn
            shop = _.clone current.match.get('shop')
            shop = shop.minus(gsub(@card.name, ' ', '_'))
            current.match.set('shop', shop)
            curr_cards = _.clone current.deck.get('hand')
            curr_cards.push gsub(@card.name, ' ', '_')
            current.deck.set('hand', curr_cards)
            @amount--
            @$el.find('.count').html(@amount)
            current.deck.spend(@card.cost)
            pushLog "<span class='name'>#{current.user.username}</span> bought #{aOrAn(@card.name)} <span class='item action'>#{@card.name}</span>"
            changePage '#match',
              transition: 'slide'
            current.match.save()
            current.deck.save()
          else
            alert "It's not your turn!"
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

      events:
        'tap .back': 'back'

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

      back: ->
        changePage "#match",
          transition: 'slide'
          reverse: true



    # Match

    class CardDetailView extends Backbone.View
      initialize: ->
        @swipeview = new Swipe(document.getElementById('card-detail'))

      el: '#card-detail'

      events:
        'tap .close': 'close'

      render: ->
        for card in current.deck.get('hand')
          @$card = $('#templates').find(".card-detail").clone()
          @$card.find('.card-detail-name').html(cards[card].name)
          @$card.find('.card-detail-desc').html(cards[card].long_desc)
          @$el.find('ul').prepend(@$card)

      close: ->
        changePage '#match',
          transition: 'pop'
          reverse: true

    class CardListView extends Backbone.View
      initialize: (@card) ->
        console.log 'CardListView#initialize'
        @setElement $('#templates').find(".card").clone()
        @render()

      events:
        'touchstart': 'touchstart'
        'touchmove': 'touchmove'
        'swiperight': 'swiperight'
        'touchend': 'touchend'
        'touchcancel': 'touchend'
        'tap .discard': 'discard'
        'tap .trash': 'trash'

      render: ->
        @$el.find('.thumb').attr('src', "images/cards/#{gsub(@card.name, ' ', '_')}_thumb.png")
        @$el.find('.name').html(@card.name)
        @$el.find('.name').addClass("name-#{@card.type}")
        @$el.find('.desc').html(@card.short_desc)
        @$el.find('.card-notch').addClass(@card.type)
        $('#hand').prepend(@el)

      w: 50
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
        views.carddetail.render(@card)
        changePage '#card-detail',
          transition: 'pop'

      touchstart: (e) ->
        @clicked = true
        setTimeout =>
          @clicked = false
        , 250
        @touch.x1 = e.touches[0].pageX
        @touch.y1 = e.touches[0].pageY

      touchmove: (e) ->
        if not window.globalDrag and e.touches.length == 1
          @dx = e.touches[0].pageX - @touch.x1
          @dy = e.touches[0].pageY - @touch.y1
          if Math.abs(@dy) < 6 and Math.abs(@dx) > 1 and not @swiping and not @dragging
            @swiping = true
            window.inAction = true
            @$el.find('.card-main').addClass "drag"
            @$el.find('.card-notch').addClass "drag"
          if @swiping and @dx > 0
            if @dx < @w
              @use = false
              pct = @dx / @w
              pct = 0  if pct < 0.05
              @$el.find('.use').css "opacity", "#{pct}"
            else if @dx >= @w
              @use = true
              @dx = @w + (@dx - @w) * .25
              @$el.find('.card-notch').css "-webkit-transform", "translate3d(#{@dx-@w}px, 0, 0)"  #if dx <= 0 #or list.todos.length > 0
            else if @dx <= -@w
              @dx = -@w + (@dx + @w) * .25
            if @dx >= @w - 1
              @$el.find('.card-main').addClass "green"
              @used = true
              # trigger use event
            else
              @$el.find('.card-main').removeClass "green"
            @$el.find('.card-main').css "-webkit-transform", "translate3d(#{@dx}px, 0, 0)"  #if dx <= 0 #or list.todos.length > 0

      swiperight: (e) ->
        console.log 'swiping right'

      touchend: (e) ->
        console.log "CardListView#touchend"
        console.log "dy: #{@dy}"
        console.log 'touch end'
        if e.touches.length == 0
          window.inAction = false
          @touch =
            x1: 0
            y1: 0
          @$el.find('.card-main').removeClass("drag").css "-webkit-transform", "translate3d(0,0,0)"
          @$el.find('.card-notch').removeClass("green").css "-webkit-transform", "translate3d(0,0,0)"
          if @swiping
            @swiping = false
        if @use and @dx >= @w - 1
          @dx = 0
          if current.deck.get('actions') > 0 and current.turn
            dy = ($('.card').size() - (@$el.index() + 2)) * 58
            setTimeout =>
              @$el.find('.card-main, .card-notch').css
                'z-index': '999'
                'margin-bottom':'-51px'
                'opacity':'0'
                '-webkit-transition': 'all .25s ease-in-out !important'
                '-webkit-transform':"translate3d(0,#{dy}px,0)"

              setTimeout =>
                current.deck.set('actions', current.deck.get('actions') - 1 ) if @card.type == 'action' or @card.type == 'attack'
                @discard()
                @card.use()
                current.match.set('last_move', new Date().toString().split(' ').slice(0,5).join(' '))
              , 250

            , 150
            console.log ' - Using card'
            # current.deck.set('actions', current.deck.get('actions') - 1 ) if @card.type == 'action' or @card.type == 'attack'
            # @discard()
            # @card.use()
            # current.match.set('last_move', new Date().toString().split(' ').slice(0,5).join(' '))
          else
            if not current.turn
              alert "It's not your turn!"
            else
              if current.deck.get('actions') < 1
                alert "You have no actions left!"
        else
          if @clicked and Math.abs(@dy) < 6
            @clicked = false

            views.carddetail.swipeview.slide(@$el.index(), 0)

            changePage '#card-detail'#,
              # transition: 'pop'
            #FIXME: swip.js breaks when pop is set


        @dx = @dy = 0

      discard: () ->
        @remove()
        @undelegateEvents()
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

      trash: () ->
        @remove()
        @undelegateEvents()
        nh = _.clone current.deck.get('hand')
        nh = nh.minus(gsub(@card.name, ' ', '_'))
        current.deck.set('hand', nh)
        current.deck.set('amount_trashed', current.deck.get('amount_trashed') + 1)
        if current.deck.get('amount_trashed') == current.deck.get('amount_to_trash')
          console.log 'trash limit reached'
          $('.trash').hide()

    class MatchView extends Backbone.View
      initialize: () ->
        @bind()
        @render()

        document.addEventListener "active", =>
          console.log 'active'
          current.match.fetch
            success: =>
              @render_turn()
              @render_scoreboard()
              @render_hand()
              @$el.find('#log').html(_.last(current.match.get('log')))
              @$el.find('#mine > .count').html(current.match.get('mine').length)
              @$el.find('#to_spend > .count').html(current.deck.to_spend())
        , false

      el: '#match'

      events:
        'tap #end_turn': 'end_turn'
        'tap #lobby_header': 'back_to_lobby'
        'tap #shop_link': 'render_shop'

      bind: ->

        # Match ==================================
        current.match.on 'change:log', =>
          console.log "current.match change:log"
          @$el.find('#log').html(_.last(current.match.get('log')))
          @render_scoreboard() #TODO: I think this is being called before the hands change

        current.match.on 'change:mine', =>
          $count = @$el.find('#mine > .count')
          $count.css '-webkit-animation-name', 'popchange'
          $count.one 'webkitAnimationEnd', =>
            $count.css '-webkit-animation-name', ''

          setTimeout =>
            $count.html(current.match.get('mine').length)
          , 50

        current.match.on 'change:turn', =>
          current.turn = if current.match.get('turn') == current.user.id then true else false
          @render_turn()
          @render_scoreboard()


        # Deck ==================================
        current.deck.on 'change:hand', =>
          @render_hand()
          @$el.find('#to_spend > .count').html(current.deck.to_spend())

        current.deck.on 'change:extra_spend', =>
          @$el.find('#to_spend > .count').html(current.deck.to_spend())

        current.deck.on 'change:actions', =>
          console.log "current.deck change:actions"
          @$el.find('#actions > .count').html(current.deck.get 'actions')

      render_scoreboard: ->

        $players_bar = $(".two.players")
        switch current.match.get('players').length
          when 3
            $players_bar = $(".three.players")
          when 4
            $players_bar = $(".four.players")

        $players_bar.show()
        $players_bar.find('li').removeClass('turn')
        for player in current.match.get('players')

          if $players_bar.find("[data-id*='#{player.id}']").length < 1
            $player = $('#templates').find(".player").clone().attr("data-id", "#{player.id}")
            $players_bar.append($player)
            $player.find('.name').html(player.username)
          else
            $player = $players_bar.find("[data-id*='#{player.id}']")

          if current.match.get('turn') == player.id
            $player.addClass('turn')
          if player.id == current.user.id
            $player.find('.score').html(current.deck.total_points())
          else
            players_decks = new Decks()
            players_decks.url = "#{server_url}/decks_by_user/#{player.id}"
            _$player = $player
            players_decks.fetch
              success: ->
                deck = players_decks.where(match_id: current.match.get('id'))[0]
                _$player.find('.score').html(deck.total_points()) # FIXME: this won't work with three players

      render_hand: ->
        if typeof views.hand == 'object'
          for view in views.hand
            view.remove()
            view.undelegateEvents()
        else
          views.hand = []

        for card in current.deck.get('hand')
          views.hand.push new CardListView(cards[card])

      render_turn: ->
        if current.turn
          @$el.find('#end_turn').show()
          @$el.find('#turn').hide()
        else
          @$el.find('#end_turn').hide()
          @$el.find('#turn').show()
          player = _.find current.match.get('players'), (player) ->
            player.id == current.match.get('turn')
          @$el.find('#turn > .count').html(player.username)

      render: ->

        current.turn = if current.match.get('turn') == current.user.id then true else false

        if views.carddetail
          views.carddetail.render()
        else
          views.carddetail = new CardDetailView
          views.carddetail.render()

        @$el.find('#log').html(_.last(current.match.get('log')))
        @$el.find('#actions > .count').html(current.deck.get 'actions')
        @$el.find('#mine > .count').html(current.match.get('mine').length)
        @$el.find('#to_spend > .count').html(current.deck.to_spend())
        @$el.find(".players").find('li').remove()

        @render_hand()
        @render_turn()
        @render_scoreboard()

      end_turn: ->
        console.log 'MatchView#end_turn'
        $('#loader').show()
        $('#loader').css('opacity', 1)
        $('#loader').find('#loading-text').html('Submitting turn...')
        current.match.set('last_move', new Date().toString().split(' ').slice(0,5).join(' '))
        pushLog "<span class='name'>#{current.user.username}</span> ended their turn"
        $.post "#{server_url}/end_turn/#{current.match.get('id')}", {'match': current.match.toJSON()}, (data) =>
          current.match.set JSON.parse(data)["match"]
          current.deck.set JSON.parse(data)["deck"]
          $('#loader').hide()
          # @render()

      back_to_lobby: ->
        changePage "#lobby",
          transition: 'slide'
          reverse: true

      render_shop: ->
        if views.shop
          views.shop.render()
        else
          views.shop = new ShopView
        changePage "#shop",
          transition: 'slide'
          reverse: true


    # Lobby

    class NewMatchUsernameView extends Backbone.View
      initialize: ->
        # Nothing..

      el: '#new_match_username'

      events:
        'tap .back': 'back'

      back: ->
        console.log 'click'
        changePage "#new_match",
          transition: 'slide'
          reverse: true

    class NewMatchView extends Backbone.View
      initialize: ->
        # I dunno..

      el: '#new_match'

      events:
        'tap .back': 'back'
        'tap .username': 'username'

      back: ->
        changePage "#lobby",
          transition: 'slideup'
          reverse: true

      username: ->
        changePage "#new_match_username",
          transition: 'slide'

    class MatchListView extends Backbone.View
      initialize: (@match, @deck) ->
        console.log 'init MatchListView'
        @setElement $('#templates').find(".match-item-view").clone()

        if pusher.channel("#{@match.get('id')}")
          sub = pusher.channel("#{@match.get('id')}")
        else
          sub = pusher.subscribe("#{@match.get('id')}")
        # TODO: write server method for getting match and current user deck in one request

        document.addEventListener "active", =>
          sub.unbind 'change_turn', change_turn
          sub.unbind 'update', update


        change_turn = (data) =>
          @match.fetch # FIXME: this is being called but it's not hitting the server
            error: (model, res) =>
              alert "something went wrong"
              console.log res
            success: =>
              @deck.fetch
                success: =>
                  @render()

        update = (data) =>
          @match.fetch # FIXME: ditto
            success: =>
              @deck.fetch
                success: =>
                  @render()

        sub.bind 'change_turn', change_turn
        sub.bind 'update', update

        setInterval =>
          @render_last_move()
        , 60000

        @render()

      rid: Math.floor(Math.floor(Math.random()*(100)))

      events:
        'tap': 'render_match'

      render: ->
        console.log 'MatchListView#render'
        if @match.get('turn') == current.user.id
          $('#matches').find('#your-turn').prepend(@el)
        else
          $('#matches').find('#their-turn').prepend(@el)
        players = @match.get('players').filter (player) ->
          player.id isnt current.user.id
        @$el.find('.head').html("Mining with #{player.username for player in players}")
        console.log 'checking last move'

        if "#{@match.get('last_move')}" == "null"
          # think of something to say here
          @$el.find('.subhead').html("No moves yet!")
        else
          @$el.find('.subhead').html("Last move #{$.timeago @match.get('last_move')}")
          @$el.find('.log').html("#{_.last(@match.get('log'))}")

      render_last_move: ->
        if "#{@match.get('last_move')}" == "null"
          # think of something to say here
          @$el.find('.subhead').html("No moves yet!")
        else
          @$el.find('.subhead').html("Last move #{$.timeago @match.get('last_move')}")

      render_match: ->
        @$el.css('background-color', '#e4e4e4')
        setTimeout =>
          @$el.css('background-color', '#fff')
        , 350

        console.log 'MatchListView#render_match'
        current.match = @match
        current.deck = @deck

        console.log "checking if MatchView instance exists."
        if views.match
          views.match.render()
          views.match.bind()
        else
          console.log 'MatchView instance doesnt exist. Creating new matchview'
          views.match = new MatchView

        changePage '#match',
          transition: 'slide'

        console.log typeof @match.collection

    class LobbyView extends Backbone.View
      initialize: () ->
        console.log 'init LobbyView'
        views.newmatchview = new NewMatchView

        document.addEventListener "active", =>
          console.log 'active'
          collections.matches.fetch
            success: =>
              collections.decks.fetch
                success: =>
                  @render()
        , false

        # Initiate Pusher subscriptions

        user_channel.bind 'new_match', (match) =>
          collections.matches.add match
          collections.decks.fetch
            success: =>
              alert "You've been challenged to a new game!"
              @render()

        @render()

      el: '#lobby'

      events:
        'tap #refresh_lobby': 'render'
        'tap #create_match': 'create_match'
        'tap .logout': 'logout'

      render: ->
        console.log "render lobby"
        # @$el.find('.match-item-view').remove()
        $('#loader').hide()

        if typeof views.matchlist == 'object'
          for view in views.matchlist
            view.remove()
            view.undelegateEvents()
        else
          views.matchlist = []

        collections.matches.each (match) ->
          console.log 'iterating matches in LobbyView#render'
          deck = collections.decks.find (deck) ->
            deck.get('match_id') == match.get('id')
          views.matchlist.push new MatchListView(match, deck)

      logout: ->
        console.log "LobbyView#logout"
        $.cookie('token', null)
        pusher.unsubscribe("#{current.user.id}")
        changePage "#home"
          
      create_match: ->
        changePage "#new_match",
          transition: 'slideup'

    # Home

    class LoginView extends Backbone.View
      initialize: ->

      el: '#login'

      events:
        'submit #login-form': 'login'
        'tap #facebook-auth': 'facebook_login'
        'tap .back': 'back'


      facebook_login: ->
        console.log 'facebook login'
        FB.login (session) ->
          $('#loader').show()
          if session and session.status isnt 'not_authorized' and session.status isnt 'notConnected'
            if session.authResponse['accessToken']
              FB.api '/me', (user) ->
                $.post("#{server_url}/signin.json",
                  facebook:
                    name: user.name
                    uid: user.id
                    token: session.authResponse['accessToken']
                , (user) ->
                  if user.error?
                    alert 'error'
                  else
                    $('#loader').hide()
                    $.cookie 'token', user.token,
                      expires: 7300
                    views.home.set_user()

                , 'json')
        , {scope: 'email'}

      facebook_auth: (e) ->
        console.log 'facebook_auth function'
        window.plugins.childBrowser.showWebPage "#{server_url}/auth/facebook?display=touch"
        window.plugins.childBrowser.onLocationChange = (loc) =>
          if /access_token/.test(loc)
            # URL looks like: server.com/access_token/:access_token
            access_token = unescape(loc).split("access_token/")[1]
            $.cookie "token", access_token,
              expires: 7300

            window.plugins.childBrowser.close()
            views.home.set_user()

      login: (e) ->
        $('#loader').show()
        $.post("#{server_url}/signin.json", $('#login-form').serialize(), (user) ->
          if user.error?
            alert 'invalid username and/or password'
            $('#loader').hide()
          else
            $('#loader').hide()
            $.cookie 'token', user.token,
              expires: 7300
            console.log $.cookie 'token'
            views.home.set_user()

        , 'json')
        e.preventDefault()

      back: ->
        changePage "#home",
          transition: 'slideup'
          reverse: true

    class SignupView extends Backbone.View
      initialize: ->

      el: '#signup'

      events:
        'submit #signup-form': 'signup'
        'tap .back': 'back'

      signup: (e) ->
        console.log 'hi'
        $.post("#{server_url}/users.json", $('#signup-form').serialize(), (user) ->
          console.log user
          if user.errors?
            console.log user
          else
            $.cookie 'token', user.token,
              expires: 7300
            views.home.set_user()

        , 'json')
        e.preventDefault()

      back: ->
        changePage "#home",
          transition: 'slideup'
          reverse: true

    class HomeView extends Backbone.View
      initialize: ->
        collections.matches = new Matches
        collections.decks = new Decks

        if $.cookie("token")?
          # TODO: match token with user on server side, if match, execute the below block
          console.log 'cookie found'
          console.log $.cookie('token')
          # TODO: add 'logging in' animation loader
          $('#loader').show()
          $('#loader').find('#loading-text').html('Logging in...')
          @set_user()
        else
          console.log 'cookie not found'

      el: '#home'

      events:
        'tap #login-button': 'login'
        'tap #signup-button': 'signup'

      login: ->
        unless views.login
          views.login = new LoginView

        changePage "#login",
          transition: "slideup"

      signup: ->
        unless views.signup
          views.signup = new SignupView

        changePage "#signup",
          transition: "slideup"


      set_user: ->
        $.ajax 
          url: "#{server_url}/users/1"
          dataType: 'json'
          success: (data) -> # users/:id param is arbitrary.
            current.user = data.user
            collections.matches.add data.matches
            collections.decks.add data.decks
            user_channel = pusher.subscribe("#{current.user.id}")
            if views.lobby
              views.lobby.render()
            else
              views.lobby = new LobbyView

            changePage "#lobby"

          error: (data) ->
            alert "Sorry, there was an error. Please relink your account with facebook."
            $('#loader').hide()
            facebook_auth set_user


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
      if $('#username').val() == current.user.username
        alert "You can't start a game with yourself!"
      else
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


    $(document).bind('touchmove', (e) ->
      if window.inAction
        e.preventDefault()
      else
        window.globalDrag = true;
    ).bind('touchend touchcancel', (e) ->
      window.globalDrag = false
    )

    views.home = new HomeView

      








