# THIS FILE IS BARE.. NO CLOSURE WRAPPER

server_url = "http://localhost:3000"

preventBehavior = (e) ->
  e.preventDefault()
document.addEventListener "touchmove", preventBehavior, false

onBodyLoad = ->
  document.addEventListener "deviceready", onDeviceReady, false

onDeviceReady = ->
  console.log('device ready.')
  window.plugins.childBrowser.onLocationChange = (loc) ->
    if /access_token/.test(loc)
      console.log('token found')
      # URL looks like: server.com/access_token/:access_token
      access_token = unescape(loc).split("access_token/")[1]
      $.cookie "token", access_token,
        expires: 7300

      window.plugins.childBrowser.close()
      $.mobile.changePage "#lobby",
        transition: "none"


  $ ->

    get_lobby = ->
      console.log('get lobby')
      console.log "cookie: #{$.cookie('token')}"
      $.ajax(
        type: 'GET'
        url: "#{server_url}/matches.json"
        dataType: 'json'
        success: (data) ->
          console.log 'got matches'
          $('.matches').html('')
          add = (match) ->
            $('.matches').append("<li><a href='#match' class='match-list-item' data-transition='slide' data-id='#{match.id}'>#{user.username for user in match.users}</a></li>").listview('refresh')
          add match for match in data
      )

    # Home
    # ============================================

    # Skip to the lobby if the user has alread logged in.
    if $.cookie("token")?
      console.log "cookie: #{$.cookie('token')}"
      $.mobile.changePage "#lobby",
        transition: "none"
      get_lobby()

    $("#facebook-auth").click ->
      # console.log(childBrowser)
      window.plugins.childBrowser.showWebPage "#{server_url}/auth/facebook?display=touch"


    # Lobby
    # ============================================

    $('.logout').click ->
      console.log("cookie: #{$.cookie('token')}")
      $.cookie('token', null)
      $.mobile.changePage "#home",
        transition: "flip"

    $('#lobby').live('pageshow', ->
      get_lobby()
    )
    $('#refresh_lobby').click ->
      get_lobby()


    $('#new_match_facebook').live('pageshow', ->
      console.log("cookie: #{$.cookie('token')}")
      $.ajax(
        type: 'GET'
        url: "#{server_url}/friends.json"
        dataType: 'json'
        success: (data) ->
          console.log('victory is mine!')
          $(".#{type}").html('')
          list = (friend, type) ->
            # if typeof friend == 'object'
            $(".#{type}").append("<label><input id='users_' name='users[]' type='checkbox' value='#{friend.id}'>#{friend.name}</label>").trigger('create')
          list friend, 'play_friends' for friend in data.play_friends
          # list friend, 'invite_friends' for friend in data.invite_friends
        error: (xhr, txtstat, err) ->
          console.log(err)
      )
    )

    $('.match-list-item').live("click", ->
      console.log('getting match data')
      $.getJSON("#{server_url}/matches/#{$(this).attr('data-id')}.json", (data) ->
        console.log(data)
        $('.hand').html('')
        add = (card) ->
          $('.hand').append("<li><a href='#'>#{card}</a></li>").listview('refresh')
        add card for card in data.deck.hand
      )
    )


    # Create Game
    # ============================================

    $('#login-form').submit (e) ->
      console.log('submitted')
      $.post("#{server_url}/signin.json", $(this).serialize(), (user) ->
        if user.error?
          alert 'invalid username and/or password'
        else
          $.cookie 'token', user.token
          $.mobile.changePage '#lobby',
            transition: 'slidedown'
        console.log(data)
      , 'json')
      e.preventDefault()

    $('#new-match-username-form').submit (e) ->
      console.log('submitted username form')
      $.post("#{server_url}/matches.json", $(this).serialize(), (data) ->
        if data.errors.length > 0
          alert error for error in data.errors
        else
          alert "match created"
        console.log(data)
      , 'json')
      e.preventDefault()














