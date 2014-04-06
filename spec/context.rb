require 'specter/context'

subject Specter::Context

spec '.new accepts nothing' do
  context = Specter::Context.new

  assert context.name, :nil?
end
