require 'stringio'

def silent
  $stdout = StringIO.new
  result = yield
  $stdout = STDOUT
  result
end

spec 'included files are ran' do
  output = %x{./bin/specter spec/examples/files/*.rb}

  assert output, :include?, 'This is an included file.'
  assert output, :include?, 'Running: spec/examples/files/included.rb'
end

spec 'required files are loaded' do
  output = %x{./bin/specter -r spec/examples/files/required.rb spec/examples/files/*.rb}

  assert output, :include?, 'This is a required file.'
end

spec 'required files are not ran' do
  output = %x{./bin/specter -r spec/examples/files/required.rb spec/examples/files/*.rb}

  refute output, :include?, 'Running: spec/examples/files/required.rb'
end

spec 'excluded files are not ran' do
  output = %x{./bin/specter -e spec/examples/files/excluded.rb spec/examples/files/*.rb}

  refute output, :include?, 'This is an excluded file.'
  refute output, :include?, 'Running: spec/examples/files/excluded.rb'
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

subject 'Specter local variables'

variable = {value: 1}

scope do
  variable[:value] = 2

  spec 'changes inside the current spec are allowed' do
    variable[:value] = 3

    assert variable[:value], :==, 3
  end

  spec 'changes outside the current spec are discarded' do
    assert variable[:value], :==, 2
  end
end

spec 'changes outside the current scope are discarded' do
  assert variable[:value], :==, 1
end
