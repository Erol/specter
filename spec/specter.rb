spec '#run returns a true value if none of the spec files failed' do
  specter = Specter.new
  specter.patterns.push 'spec/examples/empty.rb', 'spec/examples/pass.rb'

  assert specter.run
end

spec '#run returns a false value if any of the spec files failed' do
  specter = Specter.new
  specter.patterns.push 'spec/examples/fail.rb', 'spec/examples/pass.rb'

  refute specter.run
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
