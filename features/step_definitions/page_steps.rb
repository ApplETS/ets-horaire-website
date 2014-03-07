# encoding: utf-8

Alors(/^je suis sur (.*)$/) do |page|
  expect(current_path).to eq(path_to(page))
end