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

spec '#filenames include patterns matching #includes' do
  specter = Specter.new
  specter.includes << 'spec/examples/files/*.rb'

  filenames = specter.filenames

  assert filenames, :include?, 'spec/examples/files/included.rb'
  assert filenames, :include?, 'spec/examples/files/excluded.rb'
  assert filenames, :include?, 'spec/examples/files/required.rb'
end

spec '#filenames exclude patterns matching #excludes' do
  specter = Specter.new
  specter.includes << 'spec/examples/files/*.rb'
  specter.excludes << 'spec/examples/files/excluded.rb'

  filenames = specter.filenames

  assert filenames, :include?, 'spec/examples/files/included.rb'
  assert filenames, :include?, 'spec/examples/files/required.rb'

  refute filenames, :include?, 'spec/examples/files/excluded.rb'
end

spec '#filenames exclude patterns matching #requires' do
  specter = Specter.new
  specter.includes << 'spec/examples/files/*.rb'
  specter.requires << 'spec/examples/files/required.rb'

  filenames = specter.filenames

  assert filenames, :include?, 'spec/examples/files/included.rb'
  assert filenames, :include?, 'spec/examples/files/excluded.rb'

  refute filenames, :include?, 'spec/examples/files/required.rb'
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
