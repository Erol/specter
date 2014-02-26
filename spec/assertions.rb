subject '#raises'

spec 'pass if the block raises the expected exception' do
  raises StandardError do
    raise StandardError
  end
end

spec 'fail if the block does not raise an exception' do
  raises Specter::MissingException do
    raises StandardError do
    end
  end
end

spec 'fail if the block raises a different exception' do
  raises Specter::DifferentException do
    raises StandardError do
      raise Exception
    end
  end
end



subject '#assert'

scope 'true expression' do
  spec 'passes' do
    assert true
  end
end

scope 'false expression' do
  spec 'fails with a message' do
    raises Specter::FailedAssert, 'expected: nil is true' do
      assert nil
    end
  end
end

scope 'true expression and predicate' do
  spec 'passes' do
    assert [1], :any?
  end
end

scope 'false expression and predicate' do
  spec 'fails with a message' do
    raises Specter::FailedAssert, 'expected: [1] is empty' do
      assert [1], :empty?
    end
  end
end

scope 'operator is true for operands' do
  spec 'passes' do
    assert 1, :==, 1
  end
end

scope 'operator is false for operands' do
  spec 'fails with a message' do
    raises Specter::FailedAssert, 'expected: 2 == 1' do
      assert 2, :==, 1
    end
  end
end



subject '#refute'

scope 'false expression' do
  spec 'passes' do
    refute nil
  end
end

scope 'true expression' do
  spec 'fails with a message' do
    raises Specter::FailedRefute, 'expected: true is false' do
      refute true
    end
  end
end

scope 'false expression and predicate' do
  spec 'passes' do
    refute [1], :empty?
  end
end

scope 'true expression and predicate' do
  spec 'fails with a message' do
    raises Specter::FailedRefute, 'expected: [] is not empty' do
      refute [], :empty?
    end
  end
end

scope 'operator is false for operands' do
  spec 'passes' do
    refute 2, :==, 1
  end
end

scope 'operator is true for operands' do
  spec 'fails with a message' do
    raises Specter::FailedRefute, 'expected: not 1 == 1' do
      refute 1, :==, 1
    end
  end
end



subject '#flunk'

spec 'raises a default exception' do
  raises Specter::Flunked do
    flunk 'Flunked'
  end
end

spec 'raises the given exception' do
  raises Specter::FailedAssert do
    flunk 'FailedAssert', Specter::FailedAssert
  end
end
