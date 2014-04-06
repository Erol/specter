spec 'run in file level scope' do
  file = Specter.now.file
  scopes = Specter.now.scopes

  assert scopes.size, :==, 1
  assert scopes[0].description, :==, file.name
end
