spec 'subject is not set' do
  refute Specter.now.subject
end

subject Specter

spec 'subject is set' do
  assert Specter.now.subject, :==, Specter
end
