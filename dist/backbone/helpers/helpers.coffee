App.Helpers = {
  gravatar_url: (email, size = 96) ->
    encoded_email = CryptoJS.MD5(email.trim().toLowerCase())
    "http://www.gravatar.com/avatar/#{encoded_email}.jpg?s=#{size}"
}
