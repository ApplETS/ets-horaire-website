require 'spec_helper'
require 'fileutils'

describe "convert_pdfs:to_json" do
  include_context "rake"

  before(:each) do
    FileUtils.rm_rf Rails.root.join('tmp/courses')
    ENV['FROM_FOLDER'] = Rails.root.join('spec/fixtures/pdfs').to_s
    ENV['TO_FOLDER'] = Rails.root.join('tmp/courses').to_s

    FileUtils.mkdir Rails.root.join('tmp/courses')
  end
  after(:each) do
    FileUtils.rm_rf Rails.root.join('tmp/courses')
    ENV['FROM_FOLDER'] = nil
    ENV['TO_FOLDER'] = nil
  end

  it "should convert the pdfs to json files" do
    subject.invoke

    Dir.glob(Rails.root.join('tmp/courses/*.json')) do |expected_file_path|
      basename = File.basename(expected_file_path)
      actual_file_path = Rails.root.join(File.join('db/courses/test', basename)).to_s

      expected = File.open(expected_file_path, 'r').read
      actual = File.open(actual_file_path, 'r').read

      expect(expected).to eq(actual)
    end
  end
end