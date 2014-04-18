prepare do |given|
  given.file = true
end

spec 'givens from file level scope are defined' do |given|
  assert given.file
end
