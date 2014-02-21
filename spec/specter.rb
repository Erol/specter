require 'stringio'

def silent
  $stdout = StringIO.new
  result = yield
  $stdout = STDOUT
  result
end

spec '#run returns a true value if none of the spec files failed' do
  status = silent do
    specter = Specter.new
    specter.patterns.push 'spec/examples/empty.rb', 'spec/examples/pass.rb'
    specter.run
  end

  assert status
end

spec '#run returns a false value if any of the spec files failed' do
  status = silent do
    specter = Specter.new
    specter.patterns.push 'spec/examples/fail.rb', 'spec/examples/pass.rb'
    specter.run
  end

  refute status
end

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

spec 'assert passes if the given expression is true' do
  assert true
end

spec 'assert fails if the given expression is false' do
  raises Specter::FailedAssert do
    assert false
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
