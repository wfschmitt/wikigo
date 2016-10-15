#First User
User.find_or_create_by(id: 1) do |user|
  user.email = 'wiki@example.com'
  user.password = 'password'
end

#First and Main page
Word.find_or_create_by(title: 'Main Page') do |word|
  word.title = 'Main Page'
  word.body = "Wiki wiki go!"
end

#Default User Registration Token
Option.find_or_create_by(option_key: 'USER_REGISTRATION_TOKEN') do |v|
  v.option_value = SecureRandom.uuid.gsub!(/-/,'')
end

