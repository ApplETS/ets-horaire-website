Alors(/^je suis sur (.*)$/) do |page|
  expect(current_path).to eq(path_to(page))
end