# encoding: utf-8

require 'cgi'

module OutputHelper
  def output_key_of(url)
    url_query = URI::parse(url).query
    query_parameters = CGI::parse(url_query)
    query_parameters['cle']
  end

  def should_have_all_periods_persisted(results, schedules)
    nb_periods = 0
    schedules.each do |schedule|
      schedule.each do |group|
        nb_periods += group.periods.size
      end
    end
    expect(nb_periods).to eq(results.hashes.size)

    is_match = results.hashes.all? do |result|
      schedule = schedules[result["Numéro d'horaire"].to_i - 1]

      schedule.any? do |group|
        group.periods.any? do |period|
          result['Jour'].downcase == period.weekday.fr &&
          result['Période'] == "#{period.start_time.to_s} - #{period.end_time.to_s}" &&
          result['Cours'] == group.course_name &&
          result['Groupe'].to_i == group.nb &&
          result['Type'] == period.type
        end
      end
    end

    expect(is_match).to be_true
  end
end

World(OutputHelper)