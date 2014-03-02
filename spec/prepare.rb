prepare do
  @value = 1
end

spec 'prepare blocks are called for this spec' do
  assert @value, :==, 1
end

spec 'change value' do
  @value = 2
end

spec 'prepare blocks are called again for this spec' do
  assert @value, :==, 1
end
