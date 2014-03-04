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

scope do
  spec 'prepare blocks are called for this spec inside a scope' do
    assert @value, :==, 1
  end

  spec 'change value' do
    @value = 2
  end

  spec 'prepare blocks are called again for this spec inside a scope' do
    assert @value, :==, 1
  end
end

scope do
  prepare do
    @value = 3
  end

  spec 'prepare blocks inside the scope are called for this spec inside the scope' do
    assert @value, :==, 3
  end

  spec 'change value' do
    @value = 2
  end

  spec 'prepare blocks inside the scope are called again for this spec inside the scope' do
    assert @value, :==, 3
  end
end

spec 'prepare blocks outside the scope are not called for this spec' do
  assert @value, :==, 1
end
