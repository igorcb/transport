# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
#Transport::Application.config.secret_key_base = 'cec97dac6eb103294ce09864c6c9c1291de0c328025c0413b303b13454b579d55b86ba8debc3cb3f752068bb192f6f0c51dfe49825dd9668cb65c42ceb4e59cb'

# require 'securerandom'
#
# def secure_token
#   token_file = Rails.root.join('.secret')
#   if File.exist?(token_file)
#     # Use the existing token.
#     File.read(token_file).chomp
#   else
#     # Generate a new token and store it in token_file.
#     token = SecureRandom.hex(64)
#     File.write(token_file, token)
#     token
#   end
# end
#
# Transport::Application.config.secret_key_base = secure_token
