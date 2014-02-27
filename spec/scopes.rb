@outside = 'outside'

scope 'a scope' do
  @inside = 'inside'

  spec 'instance variables outside the scope are undefined' do
    refute defined? @outside
  end

  spec 'instance variables inside the scope are defined' do
    assert defined? @inside
  end
end

scope 'another scope' do
  spec 'instance variables inside a different scope are undefined' do
    refute defined? @inside
  end
end

spec 'instance variables outside a scope are defined' do
  assert defined? @outside
end

spec 'instance variables inside a scope are undefined' do
  refute defined? @inside
end
