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
