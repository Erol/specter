spec '#run returns a true value if none of the spec files failed' do
  specter = Specter.new
  specter.patterns.push 'spec/examples/empty.rb', 'spec/examples/pass.rb'

  assert specter.run
end
