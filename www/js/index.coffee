server_url = "http://localhost:3000"

$ ->

  if $.cookie('token')?
    console.log('hi')
    $.mobile.changePage "#lobby",
      transition: "none"

  $("#facebook-auth").click ->
    window.plugins.childBrowser.showWebPage "#{server_url}/auth/facebook?display=touch"

  $('.logout').click ->
    $.cookie('token', null)
    $.mobile.changePage "#home",
      transition: "none"

  $('#create_match').click ->
    # console.log($.cookie('token'))
    $.ajax(
      type: 'GET'
      url: "#{server_url}/friends.json"
      dataType: 'json'
      success: (data) ->
        console.log(data)
        console.log('victory is mine!')
        list = (friend, type) ->
          # if typeof friend == 'object'
          console.log(friend.id)
          console.log(friend.name)
          $(".#{type}").append("<label><input id='users_' name='users[]' type='checkbox' value='#{friend.id}'>#{friend.name}</label>").trigger('create')
        list friend, 'play_friends' for friend in data.play_friends
        # list friend, 'invite_friends' for friend in data.invite_friends
      error: (xhr, txtstat, err) ->
        console.log(err)

        
    )
