spec 'load required files' do
  output = %x{./bin/specter -r spec/examples/files/required.rb spec/examples/files/*.rb}

  assert output, :include?, 'Load: spec/examples/files/required.rb'
end

spec 'do not run required files' do
  output = %x{./bin/specter -r spec/examples/files/required.rb spec/examples/files/*.rb}

  refute output, :include?, 'Run: spec/examples/files/required.rb'
end

spec 'run included files' do
  output = %x{./bin/specter spec/examples/files/*.rb}

  assert output, :include?, 'Run: spec/examples/files/included.rb'
end

spec 'do not run excluded files' do
  output = %x{./bin/specter -e spec/examples/files/excluded.rb spec/examples/files/*.rb}

  refute output, :include?, 'Run: spec/examples/files/excluded.rb'
end
