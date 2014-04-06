prepare do
  $file = true
end

prepare do
  $first = false
end

prepare do
  $second = false
end

spec 'call prepare blocks in file level scope only' do
  assert $file, :==, true
  assert $first, :==, false
  assert $second, :==, false
end
