spec 'run in file level scope' do
  file = Specter.now.file
  scopes = Specter.now.scopes

  assert scopes.size, :==, 1
  assert scopes[0].description, :==, file.name
end

scope 'first level scope' do
  spec 'run in first level scope' do
    file = Specter.now.file
    scopes = Specter.now.scopes

    assert scopes.size, :==, 2
    assert scopes[0].description, :==, file.name
    assert scopes[1].description, :==, 'first level scope'
  end
end
