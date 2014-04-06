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
