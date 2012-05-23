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
    Array::minus = (v) -> x for x in @ when x!=v

    # pusher = new Pusher('efc99ac7a3e488aaa691')
    # channel = pusher.subscribe('mine-games')
    # channel.bind('new_match', (data) ->
    #   console.log(data)
    #   $('.matches').append("<li><a href='#match' class='match-list-item' data-transition='slide' data-id='#{data.match.id}'>#{user.username for user in data.match.users}</a></li>").listview('refresh')
    # )



    templates =
      LobbyMatchListItem: (id, players) ->
        "<li><a>#{player.username for player in players}</a></li>"
      CardListItem: (name, desc) ->
        "<li class='card'><a href='#card-detail' class='card-list-item' data-transition='slide'><img src='#{gsub(name, ' ', '_')}_thumb.png' alt='' />#{name}#{desc}</a></li>"


    actions =
      discard: (view, number, type, callback) ->
        view.match.selection = []
        view.events['click'] = 'select'
        if number == 'any'
          
          # display done button
          # do stuff
        else
          if view.selection.length == number
            callback()
            # end fundction
          # do stuff


    #   discard
    #     change click event handler
    #     add card to array
    #     if nummber is passed as argument
    #       function ends when array.length == nummber
    #     else
    #      function ends when 'done' is clicked

    #     done
    #       change event handler back
    #       return array.length
    #       execute callback function



    # Models / Collections
    # ============================================

    class Match extends Backbone.Model

    class Matches extends Backbone.Collection
      initialize: ->
        @fetch()

      model: Match
      url: "#{server_url}/matches"

    class Deck extends Backbone.Model

    class Decks extends Backbone.Collection
      initialize: ->
        @fetch()

      model: Deck
      url: "#{server_url}/decks"


    # Views
    # ============================================

    class CardDetailView extends Backbone.View
      el: 'what'

    class CardListView extends Backbone.View
      initialize: (@match, @card) ->
        # @setElement templates.CardListItem(@card, 'this is just some card')
        @setElement $('#templates').find("##{gsub(@card, ' ', '_')}").clone()

      events:
        'click': 'render_card'
        'touchstart': 'touchstart'
        'touchmove': 'touchmove'
      w: 55
      touch:
        x1: 0
        y1: 0
      swiping: false
      dragging: false
      selected: false
      selection: []

      render_card: ->
        console.log 'render me!'

      touchstart: (e) ->
        # touch.x1 = e.touches[0].pageX
        # touch.y1 = e.touches[0].pageY
        @touch.x1 = e.originalEvent.pageX
        @touch.y1 = e.originalEvent.pageY

      touchmove: (e) ->
        @dx = e.originalEvent.pageX - @touch.x1
        @dy = e.originalEvent.pageY - @touch.y1
        if Math.abs(@dy) < 6 and Math.abs(@dx) > 0 and not @swiping and not @dragging
          @swiping = true
          window.inAction = true
          @$el.addClass "drag"
        if @swiping
          if @dx > 0 and @dx < @w
            @used = false
            pct = @dx / @w
            pct = 0  if pct < 0.05
          else if @dx < 0 and @dx > -@w
          else if @dx >= @w
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

      select: ->
        if @selected
          @selected = true
          @$el.addClass('selected')
          @selection.push @
        else
          @selected = false
          @$el.removeClass('selected')
          @selection.minus @

    class MatchView extends Backbone.View

      initialize: (@match, @deck) ->
        @render()

      el: '#match'

      render: ->
        console.log 'about to render cards'
        @$el.find('#hand').html('')
        for card in @deck.get('hand')
          do (card) =>
            view = new CardListView(@match, card)
            @$el.find('#hand').append(view.el)

        $.mobile.changePage "#match",
        transition: "slide"

        # render all the other shit too


    class MatchListView extends Backbone.View

      initialize: (@match, @deck) ->
        @setElement templates.LobbyMatchListItem(@match.get('id'), @match.get('players'))

      events:
        'click': 'render_match'

      render_match: ->
        console.log 'rendering match'
        view = new MatchView(@match, @deck)
        # view.render()
        
    class LobbyView extends Backbone.View

      initialize: (@matches, @decks) ->
        @render()

      el: '#lobby'

      events:
        'click #refresh_lobby': 'refresh'
        'click .logout': 'logout'

      logout: ->
        $.cookie('token', null)
        $.mobile.changePage "#home",
          transition: "flip"

      render: =>
        @matches.on 'reset', => # 'reset' event is triggered when Collection#fetch completes
          @decks.on 'reset', =>
            console.log 'iterating...'
            $.mobile.changePage "#lobby",
            transition: "none"
            for match in @matches.models
              do (match) =>
                deck = @decks.where(match_id: match.get('id'))
                view = new MatchListView(match, deck[0])

                @$el.find('#matches').append(view.el).listview('refresh')

      refresh: ->
        @matches.fetch(add: true)
        @decks.fetch(add: true)
        # Look for new matches


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
      lobby = new LobbyView(new Matches, new Decks)

    $("#facebook-auth").on 'click', ->
      console.log 'clicked facebook'
      facebook_auth ->
        lobby = new LobbyView(new Matches, new Decks)

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













