# encoding: utf-8

Alors(/^je devrais voir apparaitre:$/) do |results|
  should_have_all_periods_of(results)
end