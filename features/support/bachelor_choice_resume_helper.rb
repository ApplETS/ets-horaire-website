# encoding: utf-8

module BachelorChoiceResumeHelper
  def should_have_resume_containing(bachelor, session)
    within '.bachelor-choice-resume' do
      expect(page).to have_selector("input[value='#{bachelor}']")
      expect(page).to have_selector("input[value='#{session}']")
      expect(page).to have_selector("input[value='Nouveaux Étudiants: Non']")
    end
  end
end

World(BachelorChoiceResumeHelper)