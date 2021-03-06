require 'specter/context'

subject Specter::Context

spec '.new accepts nothing' do
  context = Specter::Context.new

  assert context.name, :nil?
end

spec '.new accepts a hash of attributes' do
  context = Specter::Context.new name: 'Apple'

  assert context.name, :==, 'Apple'
end

spec 'return value for an existing attribute' do
  context = Specter::Context.new
  context.name = 'Apple'

  assert context.name, :==, 'Apple'
end

spec 'return nil for a non-existing attribute' do
  context = Specter::Context.new

  assert context.name, :nil?
end
