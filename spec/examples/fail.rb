require 'stringio'

$stdout = StringIO.new

spec 'fails' do
  assert false
end
