prepare do |given|
  given.file = true
end

spec 'givens from file level scope are defined' do |given|
  assert given.file
end

scope 'first level scope' do
  prepare do |given|
    given.first = true
  end

  spec 'givens from file level scope are defined' do |given|
    assert given.file
  end

  spec 'givens from first level scope are defined' do |given|
    assert given.first
  end
end
