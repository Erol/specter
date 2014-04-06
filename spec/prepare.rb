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

scope 'first level scope' do
  prepare do
    $first = true
  end

  spec 'call prepare blocks from file level scope to first level scope' do
    assert $file, :==, true
    assert $first, :==, true
    assert $second, :==, false
  end

  scope 'second level scope' do
    prepare do
      $second = true
    end

    spec 'call prepare blocks from file level scope to second level scope' do
      assert $file, :==, true
      assert $first, :==, true
      assert $second, :==, true
    end
  end
end
