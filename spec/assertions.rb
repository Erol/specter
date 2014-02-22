spec 'raises pass if the block raises the expected exception' do
  raises StandardError do
    raise StandardError
  end
end

spec 'raises fail if the block does not raise an exception' do
  raises Specter::MissingException do
    raises StandardError do
    end
  end
end

spec 'raises fail if the block raises a different exception' do
  raises Specter::DifferentException do
    raises StandardError do
      raise Exception
    end
  end
end

scope 'true expression' do
  spec 'assert passes' do
    assert true
  end
end

scope 'false expression' do
  spec 'assert fails with a message' do
    raises Specter::FailedAssert, 'expected: nil is true' do
      assert nil
    end
  end
end

scope 'true expression and predicate' do
  spec 'assert passes' do
    assert [1], :any?
  end
end

scope 'false expression and predicate' do
  spec 'assert fails with a message' do
    raises Specter::FailedAssert, 'expected: [1] is empty' do
      assert [1], :empty?
    end
  end
end

spec 'refute passes if the given expression is false' do
  refute false
end

spec 'refute fails if the given expression is true' do
  raises Specter::FailedRefute do
    refute true
  end
end

spec 'refute fails with failure message' do
  raises Specter::FailedRefute, 'expected: true is false' do
    refute true
  end
end

spec 'flunk raises a default exception' do
  raises Specter::Flunked do
    flunk 'Flunked'
  end
end

spec 'flunk raises the given exception' do
  raises Specter::FailedAssert do
    flunk 'FailedAssert', Specter::FailedAssert
  end
end
