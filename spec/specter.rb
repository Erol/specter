require 'stringio'

def silent
  $stdout = StringIO.new
  result = yield
  $stdout = STDOUT
  result
end

spec '.now returns the current context' do
  assert Specter.now, :is_a?, Specter::Context
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

spec 'subject is not set' do
  refute Specter.current[:subject]
end

subject Specter

spec 'subject is set' do
  assert Specter.current[:subject]
end
